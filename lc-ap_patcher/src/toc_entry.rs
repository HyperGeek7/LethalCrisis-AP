use std::{
    fs::File,
    io::{Read, Seek, SeekFrom, Write},
};

use anyhow::Result;
use byteorder::{LittleEndian, ReadBytesExt, WriteBytesExt};
use crc::{Crc, CRC_32_ISO_HDLC};

#[derive(Debug)]
pub struct TocEntry {
    pub file_name: Vec<u8>,
    pub name_crc: u32,
    pub data_crc: u32,
    pub start_offset: u32,
    pub file_length: u32,
    pub file_content: Vec<u8>,
}

impl TocEntry {
    pub fn new(file_name: &[u8], file_content: &[u8], start_offset: usize) -> TocEntry {
        let checksum_calc = Crc::<u32>::new(&CRC_32_ISO_HDLC);

        TocEntry {
            file_name: file_name.to_owned(),
            name_crc: checksum_calc.checksum(file_name),
            data_crc: checksum_calc.checksum(file_content),
            start_offset: start_offset as u32,
            file_length: file_content.len().try_into().unwrap(),
            file_content: file_content.to_vec(),
        }
    }

    pub fn from_pack_file(pack_file: &mut File) -> Result<TocEntry> {
        let mut file_name = [0u8; 0x40];
        pack_file.read_exact(&mut file_name)?;
        let name_crc = pack_file.read_u32::<LittleEndian>()?;
        let data_crc = pack_file.read_u32::<LittleEndian>()?;
        let start_offset = pack_file.read_u32::<LittleEndian>()?;
        let file_length = pack_file.read_u32::<LittleEndian>()?;

        let file_name = match file_name.iter().position(|&x| x == b'\0') {
            Some(i) => &file_name[..i],
            None => &file_name[..],
        };

        let current_position = pack_file.stream_position()?;
        pack_file.seek(SeekFrom::Start(start_offset as u64))?;
        let mut file_content = vec![0u8; file_length as usize];
        pack_file.read_exact(&mut file_content)?;
        pack_file.seek(SeekFrom::Start(current_position))?;

        Ok(TocEntry {
            file_name: file_name.to_vec(),
            name_crc,
            data_crc,
            start_offset,
            file_length,
            file_content
        })
    }

    pub fn write_entry_to_file(&self, out_file: &mut File) -> Result<()> {
        let mut file_name = self.file_name.clone();
        file_name.resize(0x40, 0u8);

        out_file.write_all(&file_name)?;
        out_file.write_u32::<LittleEndian>(self.name_crc)?;
        out_file.write_u32::<LittleEndian>(self.data_crc)?;
        out_file
            .write_u32::<LittleEndian>(self.start_offset)?;
        out_file
            .write_u32::<LittleEndian>(self.file_length)?;
        
        Ok(())
    }
}
