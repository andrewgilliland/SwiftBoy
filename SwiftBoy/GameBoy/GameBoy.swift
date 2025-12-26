//
//  GameBoy.swift
//  SwiftBoy
//
//  Created by Andrew Gilliland on 12/25/25.
//

import Foundation

class GameBoy {
    // Hardware components
    private let memory: Memory
    // TODO: Add CPU, PPU, APU, Timer, Joypad
    
    // Display
    private static let screenWidth = 160
    private static let screenHeight = 144
    private static let bytesPerPixel = 4  // RGBA
    private static let frameBufferSize = screenWidth * screenHeight * bytesPerPixel
    
    private var frameBuffer: [UInt8]
    
    // Audio
    private static let audioBufferSize = 2048  // Stereo samples
    private var audioBuffer: [Int16]
    private var audioSampleCount: Int = 0
    
    // Input
    private var buttonState: UInt8 = 0
    
    // State
    private var romLoaded: Bool = false
    
    init() {
        print("[GameBoy] Initializing...")
        
        // Initialize memory system
        self.memory = Memory()
        
        // Initialize frame buffer with test pattern (alternating red/green)
        self.frameBuffer = [UInt8](repeating: 0, count: Self.frameBufferSize)
        for i in stride(from: 0, to: Self.frameBufferSize, by: 4) {
            let pixelIndex = i / 4
            frameBuffer[i + 0] = (pixelIndex % 2 == 0) ? 255 : 0  // R
            frameBuffer[i + 1] = (pixelIndex % 2 == 0) ? 0 : 255  // G
            frameBuffer[i + 2] = 0                                 // B
            frameBuffer[i + 3] = 255                               // A
        }
        
        // Initialize audio buffer with silence
        self.audioBuffer = [Int16](repeating: 0, count: Self.audioBufferSize)
        
        print("[GameBoy] Initialized")
    }
    
    deinit {
        print("[GameBoy] Deallocating")
    }
    
    // MARK: - ROM Loading
    
    func loadROM(_ data: Data) -> Bool {
        print("[GameBoy] Loading ROM: \(data.count) bytes")
        
        guard !data.isEmpty else {
            print("[GameBoy] ERROR: Empty ROM data")
            return false
        }
        
        // Load ROM into memory system
        let success = memory.loadROM(data)
        romLoaded = success
        
        if success {
            print("[GameBoy] ROM loaded successfully")
            
            // Verify ROM data
            let entryPoint = memory.read(address: 0x0100)
            print("[GameBoy] ROM entry point (0x0100): 0x\(String(entryPoint, radix: 16))")
            
            // TODO: Reset CPU after ROM load
            print("[GameBoy] Ready to run")
        } else {
            print("[GameBoy] ERROR: Failed to load ROM")
        }
        
        return success
    }
    
    // MARK: - Emulation
    
    func runFrame() {
        guard romLoaded else {
            print("[GameBoy] WARNING: runFrame() called but no ROM loaded")
            return
        }
        
        // Execute ~70,224 CPU cycles (one frame at 4.194 MHz, 60 Hz)
        // TODO: Implement CPU execution
        // TODO: Update PPU (render scanlines)
        // TODO: Update APU (generate audio samples)
        // TODO: Update timers
        // TODO: Handle interrupts
    }
    
    func reset() {
        print("[GameBoy] Resetting...")
        
        buttonState = 0
        audioSampleCount = 0
        
        // TODO: Reset CPU
        // TODO: Reset PPU
        // TODO: Reset APU
        // TODO: Reset timers
        
        print("[GameBoy] Reset complete")
    }
    
    // MARK: - Output
    
    func getFrameBuffer() -> UnsafePointer<UInt8> {
        return frameBuffer.withUnsafeBufferPointer { $0.baseAddress! }
    }
    
    func getAudioBuffer() -> (UnsafePointer<Int16>, Int) {
        // TODO: Generate actual audio samples
        audioSampleCount = 0
        return audioBuffer.withUnsafeBufferPointer { ($0.baseAddress!, audioSampleCount) }
    }
    
    // MARK: - Input
    
    func setButtonState(_ buttons: UInt8) {
        print("[GameBoy] Button state: 0x\(String(buttons, radix: 16))")
        buttonState = buttons
        
        // TODO: Update joypad registers
        // TODO: Trigger joypad interrupt if needed
    }
}
