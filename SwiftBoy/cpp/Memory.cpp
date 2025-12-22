//
//  Memory.cpp
//  SwiftBoy
//
//  Created by Andrew Gilliland on 12/21/25.
//

#include "Memory.hpp"
#include <iostream>
#include <cstring>

Memory::Memory() : romSize(0)
{
    std::cout << "[Memory] Constructor called" << std::endl;

    // Initialize all memory regions to 0
    rom.fill(0);
    vram.fill(0);
    wram.fill(0);
    oam.fill(0);
    hram.fill(0);
    io.fill(0);
}

bool Memory::loadROM(const uint8_t *data, std::size_t size)
{
    std::cout << "[Memory] Loading ROM: " << size << " bytes" << std::endl;

    if (data == nullptr || size == 0)
    {
        std::cerr << "[Memory] ERROR: Invalid ROM data" << std::endl;
        return false;
    }

    if (size > rom.size())
    {
        std::cerr << "[Memory] WARNING: ROM size (" << size
                  << ") exceeds maximum (" << rom.size()
                  << "), truncating..." << std::endl;
        size = rom.size();
    }

    // Copy ROM data into memory
    std::memcpy(rom.data(), data, size);
    romSize = size;

    // Print first few bytes for verification
    std::cout << "[Memory] First ROM bytes: "
              << std::hex
              << "0x" << (int)rom[0] << " "
              << "0x" << (int)rom[1] << " "
              << "0x" << (int)rom[2] << " "
              << "0x" << (int)rom[3]
              << std::dec << std::endl;

    std::cout << "[Memory] ROM loaded successfully" << std::endl;
    return true;
}

uint8_t Memory::read(uint16_t address)
{
    // ROM (0x0000-0x7FFF)
    if (address < 0x8000)
    {
        return rom[address];
    }
    // VRAM (0x8000-0x9FFF)
    else if (address < 0xA000)
    {
        return vram[address - 0x8000];
    }
    // External RAM (0xA000-0xBFFF) - Not implemented yet
    else if (address < 0xC000)
    {
        return 0xFF; // Return open bus value
    }
    // Work RAM (0xC000-0xDFFF)
    else if (address < 0xE000)
    {
        return wram[address - 0xC000];
    }
    // Echo RAM (0xE000-0xFDFF) - Mirrors 0xC000-0xDDFF
    else if (address < 0xFE00)
    {
        return wram[address - 0xE000];
    }
    // OAM (0xFE00-0xFE9F)
    else if (address < 0xFEA0)
    {
        return oam[address - 0xFE00];
    }
    // Unusable memory (0xFEA0-0xFEFF)
    else if (address < 0xFF00)
    {
        return 0xFF;
    }
    // I/O Registers (0xFF00-0xFF7F)
    else if (address < 0xFF80)
    {
        return io[address - 0xFF00];
    }
    // High RAM (0xFF80-0xFFFE)
    else if (address < 0xFFFF)
    {
        return hram[address - 0xFF80];
    }
    // Interrupt Enable Register (0xFFFF)
    else
    {
        return hram[0x7F]; // Store at end of HRAM
    }
}

void Memory::write(uint16_t address, uint8_t value)
{
    // ROM (0x0000-0x7FFF) - Read-only, but used for MBC control
    if (address < 0x8000)
    {
        // TODO: Implement MBC (Memory Bank Controller) support
        std::cout << "[Memory] ROM write ignored: 0x"
                  << std::hex << address << " = 0x" << (int)value
                  << std::dec << std::endl;
        return;
    }
    // VRAM (0x8000-0x9FFF)
    else if (address < 0xA000)
    {
        vram[address - 0x8000] = value;
    }
    // External RAM (0xA000-0xBFFF) - Not implemented yet
    else if (address < 0xC000)
    {
        // TODO: Implement cartridge RAM
    }
    // Work RAM (0xC000-0xDFFF)
    else if (address < 0xE000)
    {
        wram[address - 0xC000] = value;
    }
    // Echo RAM (0xE000-0xFDFF) - Mirrors 0xC000-0xDDFF
    else if (address < 0xFE00)
    {
        wram[address - 0xE000] = value;
    }
    // OAM (0xFE00-0xFE9F)
    else if (address < 0xFEA0)
    {
        oam[address - 0xFE00] = value;
    }
    // Unusable memory (0xFEA0-0xFEFF)
    else if (address < 0xFF00)
    {
        // Ignored
    }
    // I/O Registers (0xFF00-0xFF7F)
    else if (address < 0xFF80)
    {
        io[address - 0xFF00] = value;
    }
    // High RAM (0xFF80-0xFFFE)
    else if (address < 0xFFFF)
    {
        hram[address - 0xFF80] = value;
    }
    // Interrupt Enable Register (0xFFFF)
    else
    {
        hram[0x7F] = value;
    }
}
