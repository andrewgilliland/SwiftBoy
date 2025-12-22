//
//  GameBoy.cpp
//  SwiftBoy
//
//  Created by Andrew Gilliland on 12/21/25.
//

#include "GameBoy.hpp"
#include <iostream>
#include <cstring>

GameBoy::GameBoy() 
    : audioSampleCount(0), buttonState(0), romLoaded(false) {
    std::cout << "[GameBoy] Constructor called" << std::endl;
    
    // Initialize frame buffer to a test pattern (alternating red/green)
    for (int i = 0; i < FRAME_BUFFER_SIZE; i += 4) {
        frameBuffer[i + 0] = (i / 4) % 2 == 0 ? 255 : 0;  // R
        frameBuffer[i + 1] = (i / 4) % 2 == 0 ? 0 : 255;  // G
        frameBuffer[i + 2] = 0;                            // B
        frameBuffer[i + 3] = 255;                          // A
    }
    
    // Initialize audio buffer to silence
    std::memset(audioBuffer, 0, sizeof(audioBuffer));
}

GameBoy::~GameBoy() {
    std::cout << "[GameBoy] Destructor called" << std::endl;
}

bool GameBoy::loadROM(const uint8_t* data, std::size_t size) {
    std::cout << "[GameBoy] Loading ROM: " << size << " bytes" << std::endl;
    
    if (data == nullptr || size == 0) {
        std::cerr << "[GameBoy] ERROR: Invalid ROM data" << std::endl;
        return false;
    }
    
    // TODO: Actually load ROM data into memory
    romLoaded = true;
    std::cout << "[GameBoy] ROM loaded successfully" << std::endl;
    return true;
}

void GameBoy::runFrame() {
    if (!romLoaded) {
        std::cout << "[GameBoy] WARNING: runFrame() called but no ROM loaded" << std::endl;
        return;
    }
    
    std::cout << "[GameBoy] Running frame (~70,224 CPU cycles)" << std::endl;
    
    // TODO: Execute CPU cycles
    // TODO: Update PPU (render scanlines)
    // TODO: Update APU (generate audio samples)
    // TODO: Update timers
    // TODO: Handle interrupts
    
    // For now, just cycle through colors in the frame buffer
    static uint8_t colorShift = 0;
    colorShift++;
    for (int i = 0; i < FRAME_BUFFER_SIZE; i += 4) {
        frameBuffer[i + 0] = (i / 4 + colorShift) % 255;  // R
        frameBuffer[i + 1] = (i / 4 * 2 + colorShift) % 255;  // G
        frameBuffer[i + 2] = (i / 4 * 3 + colorShift) % 255;  // B
        frameBuffer[i + 3] = 255;  // A
    }
}

const uint8_t* GameBoy::getFrameBuffer() {
    std::cout << "[GameBoy] getFrameBuffer() called" << std::endl;
    return frameBuffer;
}

const int16_t* GameBoy::getAudioBuffer(std::size_t* outSize) {
    std::cout << "[GameBoy] getAudioBuffer() called" << std::endl;
    
    if (outSize != nullptr) {
        *outSize = audioSampleCount;
    }
    
    // TODO: Generate actual audio samples
    // For now, return silence
    audioSampleCount = 0;
    return audioBuffer;
}

void GameBoy::setButtonState(uint8_t buttons) {
    std::cout << "[GameBoy] Button state: 0x" << std::hex << (int)buttons << std::dec << std::endl;
    buttonState = buttons;
    
    // TODO: Update joypad registers
    // TODO: Trigger joypad interrupt if needed
}

void GameBoy::reset() {
    std::cout << "[GameBoy] Reset called" << std::endl;
    
    buttonState = 0;
    audioSampleCount = 0;
    
    // TODO: Reset CPU state
    // TODO: Reset memory
    // TODO: Reset PPU
    // TODO: Reset APU
    // TODO: Reset timers
    
    std::cout << "[GameBoy] Reset complete" << std::endl;
}
