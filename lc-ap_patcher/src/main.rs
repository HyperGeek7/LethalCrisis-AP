use anyhow::{Result, bail};
use byteorder::{LittleEndian, ReadBytesExt, WriteBytesExt};
use clap::Parser;
use std::fs::remove_dir_all;
use std::io;
use std::path::MAIN_SEPARATOR_STR;
use std::{fs::DirBuilder, fs::File, fs::copy, fs::read, fs::write};
use std::{
    io::{Read, Write},
    path::MAIN_SEPARATOR,
    path::Path,
    path::PathBuf,
};
use walkdir::WalkDir;
use zip::ZipArchive;

mod toc_entry;
use crate::toc_entry::TocEntry;

#[derive(Parser)]
struct Args {
    #[arg(
        value_name = "FILE",
        help = "The p file to be unpacked or repacked",
        default_value_os_t = PathBuf::from("Lethal Crisis.p")
    )]
    p_file: PathBuf,

    #[arg(
        short,
        long,
        help = "Overwrite an existing backup file instead of aborting"
    )]
    overwrite_backup: bool,

    #[arg(
        short,
        long,
        help = "Skip the check against version string. Only use if you're sure you know what you're doing."
    )]
    skip_version_check: bool,
}

fn unpack_file(
    toc_entries: &Vec<TocEntry>,
    output_dir: &Path,
) -> Result<()> {
    let mut builder = DirBuilder::new();
    builder.recursive(true);

    for toc_entry in toc_entries {
        let file_name = String::from_utf8_lossy(&toc_entry.file_name).to_string();
        let mut file_name_path = Path::new(&file_name);
        let modified_file_name = file_name.replace('\\', MAIN_SEPARATOR_STR);
        if MAIN_SEPARATOR != '\\' {
            file_name_path = Path::new(&modified_file_name);
        }

        let mut full_path = output_dir.to_path_buf();
        full_path.push(file_name_path);

        let dir_path = full_path
            .parent()
            .unwrap_or_else(|| panic!("File path {} should have a parent.", full_path.display()));
        builder.create(dir_path).expect("Couldn't create directory");
        write(&full_path, &toc_entry.file_content).expect("Couldn't write file.");
    }

    Ok(())
}

fn pack_file(
    source_dir: &Path,
    output_file: &PathBuf,
) -> Result<()> {
    let mut pack_body: Vec<u8> = Vec::new();
    let mut toc_entries: Vec<TocEntry> = Vec::new();

    for path in WalkDir::new(source_dir)
        .into_iter()
        .filter_map(|e| e.ok())
        .filter(|e| e.metadata().unwrap().is_file())
        .map(|e| e.into_path())
    {
        let local_path = path
            .strip_prefix(source_dir)
            .unwrap()
            .to_owned()
            .to_string_lossy()
            .replace(MAIN_SEPARATOR_STR, "\\");

        let next_size = pack_body.len().div_ceil(0x100) * 0x100;
        pack_body.resize(next_size, 0u8);

        let target_file_content = read(&path)?;

        toc_entries.push(TocEntry::new(
            local_path.as_bytes(),
            &target_file_content,
            pack_body.len(),
        ));
        pack_body.extend(target_file_content.iter());
    }

    let orig_toc_size = (toc_entries.len() * 0x50) + 8;
    let final_toc_size = (orig_toc_size.div_ceil(0x100)) * 0x100;
    let padding_needed = final_toc_size - orig_toc_size;
    let pad_vector = vec![0u8; padding_needed];

    for toc_entry in toc_entries.iter_mut() {
        toc_entry.start_offset += final_toc_size as u32;
    }

    let mut final_file = File::create(output_file)?;
    final_file.write_all("PACK".as_bytes())?;
    final_file.write_u32::<LittleEndian>(toc_entries.len() as u32)?;

    for toc_entry in toc_entries.iter() {
        toc_entry.write_entry_to_file(&mut final_file)?;
    }

    final_file.write_all(&pad_vector)?;
    final_file.write_all(&pack_body)?;
    final_file.flush()?;

    Ok(())
}

fn patch_file() -> Result<()> {
    let args = Args::parse();
    let dir_builder = DirBuilder::new();

    // Let's do some sanity checks first...
    if !&args.p_file.exists() {
        bail!("p file not found. Did you drag it onto the exe?");
    }
    let p_file_path = &args.p_file.canonicalize()?;
    if !p_file_path.exists() || !p_file_path.is_file() {
        bail!("p file does not exist or is not a file.");
    }

    let lc_root = p_file_path.parent().unwrap();

    let patch_zip = lc_root.join("ap_patch_files.lczip");
    if !patch_zip.exists() {
        bail!("ap_patch_files.lczip was not found.");
    }

    let p_file_backup = p_file_path.with_added_extension("vanilla");
    let mut make_backup = true;
    if p_file_backup.exists() {
        if args.overwrite_backup {
            println!("Backup file already exists, but overwrite flag was given. We will clobber.");
        }
        else {
            println!("Backup file already exists. Assume we are updating and proceed.");
            make_backup = false;
        }
    }
    let unpack_dir = lc_root.join("unpack_tmp");
    if unpack_dir.exists() {
        bail!("Temporary unpacking directory already exists! Aborting.");
    }

    dir_builder.create(unpack_dir.clone())?;

    let mut toc_entries: Vec<TocEntry> = Vec::new();

    let mut pack_file_handle = File::open(p_file_path)?;
    let mut magic = [0u8; 4];
    pack_file_handle.read_exact(&mut magic)?;
    assert_eq!(magic, "PACK".as_bytes());

    let item_count = pack_file_handle.read_u32::<LittleEndian>()?;

    for _i in 0..item_count {
        toc_entries.push(TocEntry::from_pack_file(&mut pack_file_handle)?);
    }

    println!("Unpacking file...");
    unpack_file(&toc_entries, &unpack_dir)?;

    // Alright, let's party.
    println!("Ok, everything looks clean. Patching...");
    if make_backup {
        copy(p_file_path, p_file_backup)?;
        println!("Backup created...");
    }
    let mut patch_zip_archive = ZipArchive::new(File::open(patch_zip)?)?;
    println!("Extracting patch files...");
    patch_zip_archive.extract(&unpack_dir)?;

    println!("Repacking file...");
    pack_file(&unpack_dir, p_file_path)?;

    println!("Cleaning up...");
    remove_dir_all(unpack_dir)?;

    Ok(())
}

fn main() -> Result<()> {
    let patch_result = patch_file();

    match patch_result {
        Ok(_) => {
            println!("AP patch applied successfully!");
        }
        Err(ref e) => {
            println!("{}", e);
        }
    }

    println!("Press enter to exit.");
    let mut dummy = String::new();
    io::stdin().read_line(&mut dummy)?;

    patch_result
}
