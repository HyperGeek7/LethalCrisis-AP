use anyhow::{Result, bail};
use blowfish::{Blowfish, BlowfishLE, cipher::KeyInit};
use byteorder::{LittleEndian, ReadBytesExt, WriteBytesExt};
use clap::Parser;
use encoding_rs::SHIFT_JIS;
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
    blowfish_decryptor: &Blowfish<LittleEndian>,
    pack_file: &mut File,
    toc_entries: &Vec<TocEntry>,
    output_dir: &Path,
) -> Result<()> {
    let mut builder = DirBuilder::new();
    builder.recursive(true);

    for toc_entry in toc_entries {
        let mut decrypted_content =
            toc_entry.load_decrypted_file_data(pack_file, blowfish_decryptor);

        let mut file_name_path = Path::new(&toc_entry.file_name);
        let modified_file_name = toc_entry.file_name.replace('\\', MAIN_SEPARATOR_STR);
        if MAIN_SEPARATOR != '\\' {
            file_name_path = Path::new(&modified_file_name);
        }
        if let Some(file_extension) = file_name_path.extension()
            && file_extension.to_str().unwrap() == "TXT"
        {
            let (shift_jis_content, _encoding_used, _had_errors) =
                SHIFT_JIS.decode(decrypted_content.as_slice());
            decrypted_content = Vec::from(shift_jis_content.as_bytes());
        }

        let mut full_path = output_dir.to_path_buf();
        full_path.push(file_name_path);

        let dir_path = full_path
            .parent()
            .unwrap_or_else(|| panic!("File path {} should have a parent.", full_path.display()));
        builder.create(dir_path).expect("Couldn't create directory");
        write(&full_path, &decrypted_content).expect("Couldn't write file.");
    }

    Ok(())
}

fn pack_file(
    blowfish_encryptor: &Blowfish<LittleEndian>,
    source_dir: &Path,
    output_file: &PathBuf,
) {
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

        while !pack_body.len().is_multiple_of(0x100) {
            pack_body.push(0u8);
        }

        let mut target_file_content =
            read(&path).unwrap_or_else(|_| panic!("Unable to read file {}.", &path.display()));
        if let Some(file_extension) = path.extension()
            && file_extension.to_str().unwrap() == "TXT"
        {
            let content_string = String::from_utf8(target_file_content).unwrap();
            let (encoded_file_content, _encoding_used, _had_errors) =
                SHIFT_JIS.encode(content_string.as_str());
            target_file_content = encoded_file_content.to_vec();
        }
        let mut encrypted_file_content = target_file_content.clone();
        if !path
            .extension()
            .unwrap_or_default()
            .eq_ignore_ascii_case("MPG")
        {
            encrypted_file_content =
                TocEntry::encrypt_file_data(&mut target_file_content, blowfish_encryptor);
        }

        toc_entries.push(TocEntry::new(
            &local_path,
            &encrypted_file_content,
            pack_body.len(),
        ));
        pack_body.extend(encrypted_file_content.iter());
    }

    let orig_toc_size = (toc_entries.len() * 0x50) + 8;
    let final_toc_size = (orig_toc_size.div_ceil(0x100)) * 0x100;
    let padding_needed = final_toc_size - orig_toc_size;
    let pad_vector = vec![0u8; padding_needed];

    for toc_entry in toc_entries.iter_mut() {
        toc_entry.start_offset += final_toc_size as u32;
    }

    let mut final_file = File::create(output_file).unwrap();
    final_file.write_all("PACK".as_bytes()).unwrap();
    final_file
        .write_u32::<LittleEndian>(toc_entries.len() as u32)
        .unwrap();

    for toc_entry in toc_entries.iter() {
        toc_entry.write_entry_to_file(&mut final_file);
    }

    final_file.write_all(&pad_vector).unwrap();
    final_file.write_all(&pack_body).unwrap();
    final_file.flush().unwrap();
}

fn patch_file() -> Result<()> {
    let args = Args::parse();
    let key: &[u8; 56] = include_bytes!("LC.key");
    let json_lua = include_str!("json.lua");
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
    let mut json_lib = lc_root.join("lua");
    println!("Checking for json.lua...");
    if !json_lib.exists() {
        dir_builder.create(&json_lib)?;
    }
    json_lib.push("json.lua");
    if !json_lib.exists() {
        println!("Installing json.lua...");
        write(json_lib, json_lua)?;
    }

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
        toc_entries.push(TocEntry::from_pack_file(&mut pack_file_handle));
    }

    let blowfish = BlowfishLE::new_from_slice(key).unwrap();

    println!("Unpacking file...");
    unpack_file(&blowfish, &mut pack_file_handle, &toc_entries, &unpack_dir)?;

    // One last sanity check. If the version string doesn't match, odds are good the decrypt failed.
    const EXPECTED_VERSION: &str = "1,2010,04,20,22,24,06";
    let version_file = unpack_dir.join("VERSION.TXT");
    if !version_file.exists() {
        bail!("Unpack step did not produce a valid VERSION.TXT file.");
    }
    if !args.skip_version_check {
        let version_data = read(version_file)?;
        let version_str = str::from_utf8(&version_data)?.trim();
        if version_str != EXPECTED_VERSION {
            bail!(
                "Got an unexpected version in VERSION.TXT! Expected {}, got {}",
                EXPECTED_VERSION,
                version_str
            );
        }
    }

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
    pack_file(&blowfish, &unpack_dir, p_file_path);

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
    let _ = io::stdin().read_line(&mut dummy);
    println!("{}", dummy);

    patch_result
}
