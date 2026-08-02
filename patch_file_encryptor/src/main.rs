use std::{
    fs::{create_dir_all, read, write},
    path::PathBuf,
};

use anyhow::Result;
use blowfish::{
    Blowfish, BlowfishLE,
    cipher::{Array, BlockCipherEncrypt, KeyInit},
};
use byteorder::LittleEndian;
use clap::Parser;
use walkdir::WalkDir;

#[derive(Parser)]
struct Args {
    #[arg(
        short,
        long,
        value_name = "DIR",
        help = "Directory containing files to encrypt"
    )]
    input_dir: PathBuf,

    #[arg(
        short,
        long,
        value_name = "DIR",
        help = "Directory to output encrypted files to"
    )]
    output_dir: PathBuf,
}

fn encrypt_file(
    blowfish: &Blowfish<LittleEndian>,
    input_path: &PathBuf,
    output_path: &PathBuf,
) -> Result<()> {
    let file_content = read(input_path)?;
    let decrypted_length = file_content.len();

    let mut decrypted_blocks = Vec::new();

    let mut chunk_iter = file_content.chunks_exact(8);
    for chunk in chunk_iter.by_ref() {
        decrypted_blocks.push(Array::try_from(chunk)?);
    }

    if !chunk_iter.remainder().is_empty() {
        let mut remainder = chunk_iter.remainder().to_vec();
        let remaining_bytes = chunk_iter.remainder().len();
        let padding_bytes_needed = (8 - remaining_bytes) as u8;
        remainder.resize(8, 0u8);

        remainder[7] = padding_bytes_needed;
        decrypted_blocks.push(Array::try_from(remainder.as_slice())?);
    }

    blowfish.encrypt_blocks(&mut decrypted_blocks);

    let encrypted_content: Vec<u8> = decrypted_blocks.iter().flatten().copied().collect();
    let mut final_content = "LZSS".as_bytes().to_vec();
    final_content.extend_from_slice(&decrypted_length.to_le_bytes()[0..4]);
    final_content.extend(encrypted_content.iter());

    write(output_path, final_content)?;

    Ok(())
}

fn main() -> Result<()> {
    let key = include_bytes!("LC.key");
    let blowfish = BlowfishLE::new_from_slice(key)?;
    let args = Args::parse();

    let input_dir = args.input_dir.canonicalize()?;

    for path in WalkDir::new(&input_dir)
        .into_iter()
        .filter_map(|e| e.ok())
        .map(|e| e.into_path())
        .filter(|e| e.exists() && e.is_file())
    {
        let sub_path = path.strip_prefix(&input_dir)?;
        let mut out_path = args.output_dir.to_path_buf();
        if !out_path.exists() {
            create_dir_all(&out_path)?;
        }
        out_path.push(sub_path);

        let containing_dir = out_path.parent().unwrap();
        if !containing_dir.exists() {
            create_dir_all(containing_dir)?;
        }

        encrypt_file(&blowfish, &path, &out_path)?;
    }

    Ok(())
}
