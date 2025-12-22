//
//  Memory.hpp
//  SwiftBoy
//
//  Created by Andrew Gilliland on 12/21/25.
//

#pragma once
#include <cstdint>
#include <array>

class Memory
{
public:
    Memory();

    // Read/Write interface
    uint8_t read(uint16_t address);
    void write(uint16_t address, uint8_t value);

    // ROM loading
    bool loadROM(const uint8_t *data, std::size_t size);

    // Direct VRAM access for PPU
    const uint8_t *getVRAM() const { return vram.data(); }

private:
    // Memory regions
    std::array<uint8_t, 0x8000> rom;  // 0x0000-0x7FFF (32KB ROM)
    std::array<uint8_t, 0x2000> vram; // 0x8000-0x9FFF (8KB Video RAM)
    std::array<uint8_t, 0x2000> wram; // 0xC000-0xDFFF (8KB Work RAM)
    std::array<uint8_t, 0x00A0> oam;  // 0xFE00-0xFE9F (Sprite Attribute Table)
    std::array<uint8_t, 0x0080> hram; // 0xFF80-0xFFFE (High RAM)
    std::array<uint8_t, 0x0080> io;   // 0xFF00-0xFF7F (I/O Registers)

    std::size_t romSize;
};
