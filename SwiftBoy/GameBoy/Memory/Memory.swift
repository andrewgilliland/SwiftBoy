//
//  Memory.swift
//  SwiftBoy
//
//  Created by Andrew Gilliland on 12/25/25.
//

import Foundation

class Memory {
    // Memory regions
    private var rom: [UInt8]      // 0x0000-0x7FFF (32KB ROM)
    private var vram: [UInt8]     // 0x8000-0x9FFF (8KB Video RAM)
    private var wram: [UInt8]     // 0xC000-0xDFFF (8KB Work RAM)
    private var oam: [UInt8]      // 0xFE00-0xFE9F (Sprite Attribute Table)
    private var io: [UInt8]       // 0xFF00-0xFF7F (I/O Registers)
    private var hram: [UInt8]     // 0xFF80-0xFFFE (High RAM)
    private var interruptEnable: UInt8  // 0xFFFF
    
    // ROM metadata
    private var romSize: Int = 0
    
    // Memory sizes
    private static let romSize = 0x8000    // 32KB
    private static let vramSize = 0x2000   // 8KB
    private static let wramSize = 0x2000   // 8KB
    private static let oamSize = 0x00A0    // 160 bytes
    private static let ioSize = 0x0080     // 128 bytes
    private static let hramSize = 0x007F   // 127 bytes
    
    init() {
        print("[Memory] Initializing...")
        
        // Initialize all memory regions
        self.rom = [UInt8](repeating: 0, count: Self.romSize)
        self.vram = [UInt8](repeating: 0, count: Self.vramSize)
        self.wram = [UInt8](repeating: 0, count: Self.wramSize)
        self.oam = [UInt8](repeating: 0, count: Self.oamSize)
        self.io = [UInt8](repeating: 0, count: Self.ioSize)
        self.hram = [UInt8](repeating: 0, count: Self.hramSize)
        self.interruptEnable = 0
        
        print("[Memory] Initialized")
    }
    
    deinit {
        print("[Memory] Deallocating")
    }
    
    // MARK: - ROM Loading
    
    func loadROM(_ data: Data) -> Bool {
        print("[Memory] Loading ROM: \(data.count) bytes")
        
        guard !data.isEmpty else {
            print("[Memory] ERROR: Empty ROM data")
            return false
        }
        
        // Check ROM size and truncate if necessary
        let bytesToCopy = min(data.count, Self.romSize)
        if data.count > Self.romSize {
            print("[Memory] WARNING: ROM size (\(data.count)) exceeds maximum (\(Self.romSize)), truncating...")
        }
        
        // Copy ROM data
        data.prefix(bytesToCopy).enumerated().forEach { index, byte in
            rom[index] = byte
        }
        romSize = bytesToCopy
        
        // Print first few ROM bytes for debugging
        let firstBytes = rom.prefix(4).map { String(format: "0x%02x", $0) }.joined(separator: " ")
        print("[Memory] First ROM bytes: \(firstBytes)")
        
        // Print ROM entry point
        let entryBytes = rom[0x0100..<0x0104].map { String(format: "0x%02x", $0) }.joined(separator: " ")
        print("[Memory] ROM entry point (0x0100): \(entryBytes)")
        
        print("[Memory] ROM loaded successfully")
        return true
    }
    
    // MARK: - Memory Access
    
    func read(address: UInt16) -> UInt8 {
        switch address {
        case 0x0000...0x7FFF:  // ROM
            return rom[Int(address)]
            
        case 0x8000...0x9FFF:  // VRAM
            return vram[Int(address - 0x8000)]
            
        case 0xA000...0xBFFF:  // External RAM (TODO: implement)
            return 0xFF
            
        case 0xC000...0xDFFF:  // WRAM
            return wram[Int(address - 0xC000)]
            
        case 0xE000...0xFDFF:  // Echo RAM (mirror of WRAM)
            return wram[Int(address - 0xE000)]
            
        case 0xFE00...0xFE9F:  // OAM
            return oam[Int(address - 0xFE00)]
            
        case 0xFEA0...0xFEFF:  // Unusable
            return 0xFF
            
        case 0xFF00...0xFF7F:  // I/O Registers
            return io[Int(address - 0xFF00)]
            
        case 0xFF80...0xFFFE:  // HRAM
            return hram[Int(address - 0xFF80)]
            
        case 0xFFFF:  // Interrupt Enable Register
            return interruptEnable
            
        default:
            print("[Memory] WARNING: Invalid read at 0x\(String(address, radix: 16))")
            return 0xFF
        }
    }
    
    func write(address: UInt16, value: UInt8) {
        switch address {
        case 0x0000...0x7FFF:  // ROM (read-only, but used for MBC control)
            // TODO: Handle MBC register writes
            break
            
        case 0x8000...0x9FFF:  // VRAM
            vram[Int(address - 0x8000)] = value
            
        case 0xA000...0xBFFF:  // External RAM (TODO: implement)
            break
            
        case 0xC000...0xDFFF:  // WRAM
            wram[Int(address - 0xC000)] = value
            
        case 0xE000...0xFDFF:  // Echo RAM (mirror of WRAM)
            wram[Int(address - 0xE000)] = value
            
        case 0xFE00...0xFE9F:  // OAM
            oam[Int(address - 0xFE00)] = value
            
        case 0xFEA0...0xFEFF:  // Unusable
            break
            
        case 0xFF00...0xFF7F:  // I/O Registers
            io[Int(address - 0xFF00)] = value
            
        case 0xFF80...0xFFFE:  // HRAM
            hram[Int(address - 0xFF80)] = value
            
        case 0xFFFF:  // Interrupt Enable Register
            interruptEnable = value
            
        default:
            print("[Memory] WARNING: Invalid write at 0x\(String(address, radix: 16))")
        }
    }
    
    // MARK: - Direct Access
    
    func getVRAM() -> UnsafePointer<UInt8> {
        return vram.withUnsafeBufferPointer { $0.baseAddress! }
    }
}
