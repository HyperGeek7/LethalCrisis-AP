use std::{
    fs::File,
    io::{Read, Seek, SeekFrom, Write},
};

use blowfish::{
    cipher::{generic_array::GenericArray, BlockDecrypt, BlockEncrypt},
    Blowfish,
};
use byteorder::{LittleEndian, ReadBytesExt, WriteBytesExt};
use crc::{Crc, CRC_32_ISO_HDLC};
use encoding_rs::SHIFT_JIS;

#[derive(Debug)]
pub struct TocEntry {
    pub file_name: String,
    pub name_crc: u32,
    pub data_crc: u32,
    pub start_offset: u32,
    pub file_length: u32,
}

impl TocEntry {
    pub fn new(file_name: &str, file_content: &[u8], start_offset: usize) -> TocEntry {
        let checksum_calc = Crc::<u32>::new(&CRC_32_ISO_HDLC);

        TocEntry {
            file_name: file_name.to_owned(),
            name_crc: checksum_calc.checksum(&file_name.to_owned().into_bytes()),
            data_crc: checksum_calc.checksum(file_content),
            start_offset: start_offset as u32,
            file_length: file_content.len().try_into().unwrap()
        }
    }

    pub fn from_pack_file(pack_file: &mut File) -> TocEntry {
        let mut file_name = [0u8; 0x40];
        pack_file.read_exact(&mut file_name).unwrap();
        let name_crc = pack_file.read_u32::<LittleEndian>().unwrap();
        let data_crc = pack_file.read_u32::<LittleEndian>().unwrap();
        let start_offset = pack_file.read_u32::<LittleEndian>().unwrap();
        let file_length = pack_file.read_u32::<LittleEndian>().unwrap();

        //let file_name = file_name.trim_matches('\0');
        let file_name = match file_name.iter().position(|&x| x == b'\0') {
            Some(i) => &file_name[..i],
            None => &file_name[..],
        };

        let (file_name, _encoding_used, _had_errors) = SHIFT_JIS.decode(file_name);

        TocEntry {
            file_name: file_name.to_string(),
            name_crc,
            data_crc,
            start_offset,
            file_length,
        }
    }

    pub fn load_file_data(&self, pack_file: &mut File) -> Vec<u8> {
        let mut file_content = vec![0u8; self.file_length.try_into().unwrap()];
        pack_file
            .seek(SeekFrom::Start(self.start_offset.into()))
            .expect("Unable to seek to start position.");
        pack_file
            .read_exact(&mut file_content)
            .expect("Unable to read full file content");

        file_content
    }

    pub fn load_decrypted_file_data(
        &self,
        pack_file: &mut File,
        blowfish_decryptor: &Blowfish<LittleEndian>,
    ) -> Vec<u8> {
        let file_data = self.load_file_data(pack_file);

        if String::from_utf8(file_data[0..4].to_vec()).unwrap_or(String::from("")) != "LZSS" {
            return file_data;
        }

        let decrypted_length = (&file_data[4..8]).read_u32::<LittleEndian>().unwrap();
        let file_data = &file_data[8..];
        let mut encrypted_blocks = Vec::new();

        for chunk in file_data.chunks(8) {
            encrypted_blocks.push(GenericArray::clone_from_slice(chunk));
        }
        blowfish_decryptor.decrypt_blocks(&mut encrypted_blocks);

        let mut decrypted_content: Vec<u8> = encrypted_blocks.iter().flatten().copied().collect();

        decrypted_content.truncate(decrypted_length.try_into().unwrap());

        decrypted_content
    }

    pub fn encrypt_file_data(
        file_content: &mut [u8],
        blowfish_encryptor: &Blowfish<LittleEndian>,
    ) -> Vec<u8> {
        let decrypted_length = file_content.len();

        let mut decrypted_blocks = Vec::new();

        let mut chunk_iter = file_content.chunks_exact(8);
        for chunk in chunk_iter.by_ref() {
            decrypted_blocks.push(GenericArray::clone_from_slice(chunk));
        }

        if !chunk_iter.remainder().is_empty() {
            let remaining_bytes = chunk_iter.remainder().len();
            let padding_bytes_needed = (8 - remaining_bytes) as u8;
            let mut padded_final_chunk = [0_u8; 8];
            let bytes_read = chunk_iter
                .remainder()
                .read(&mut padded_final_chunk)
                .unwrap();
            if bytes_read < remaining_bytes {
                panic!("Unable to read remaining bytes");
            }
            padded_final_chunk[7] = padding_bytes_needed;
            decrypted_blocks.push(GenericArray::clone_from_slice(
                padded_final_chunk.as_slice(),
            ));
        }

        blowfish_encryptor.encrypt_blocks(&mut decrypted_blocks);

        let encrypted_content: Vec<u8> = decrypted_blocks.iter().flatten().copied().collect();
        let mut final_content = "LZSS".as_bytes().to_vec();
        final_content.extend_from_slice(&decrypted_length.to_le_bytes()[0..4]);
        final_content.extend(encrypted_content.iter());

        final_content
    }

    pub fn write_entry_to_file(&self, out_file: &mut File) {
        let (file_name, _encoding_used, _had_errors) = SHIFT_JIS.encode(&self.file_name);
        let mut file_name = file_name.to_vec();
        while file_name.len() < 0x40 {
            file_name.push(0u8);
        }
        out_file.write_all(file_name.as_slice()).unwrap();
        out_file.write_u32::<LittleEndian>(self.name_crc).unwrap();
        out_file.write_u32::<LittleEndian>(self.data_crc).unwrap();
        out_file
            .write_u32::<LittleEndian>(self.start_offset)
            .unwrap();
        out_file
            .write_u32::<LittleEndian>(self.file_length)
            .unwrap();
    }
}
