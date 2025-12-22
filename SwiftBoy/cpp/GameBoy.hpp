//
//  GameBoy.hpp
//  SwiftBoy
//
//  Created by Andrew Gilliland on 12/21/25.
//

#pragma once
#include <cstdint>
#include <cstddef>
#include "Memory.hpp"

class GameBoy {
public:
    GameBoy();
    ~GameBoy();
    
    bool loadROM(const uint8_t* data, std::size_t size);
    void runFrame();                      // Run ~70,224 cycles (1/60 sec)
    const uint8_t* getFrameBuffer();      // 160x144x4 RGBA bytes
    const int16_t* getAudioBuffer(std::size_t* outSize);  // Stereo PCM
    void setButtonState(uint8_t buttons); // Bit flags for A/B/Start/Select/D-pad
    void reset();
    
private:
    static constexpr int SCREEN_WIDTH = 160;
    static constexpr int SCREEN_HEIGHT = 144;
    static constexpr int BYTES_PER_PIXEL = 4;  // RGBA
    static constexpr int FRAME_BUFFER_SIZE = SCREEN_WIDTH * SCREEN_HEIGHT * BYTES_PER_PIXEL;
    static constexpr int AUDIO_BUFFER_SIZE = 2048;  // Stereo samples
    
    uint8_t frameBuffer[FRAME_BUFFER_SIZE];
    int16_t audioBuffer[AUDIO_BUFFER_SIZE];
    std::size_t audioSampleCount;
    uint8_t buttonState;
    bool romLoaded;
    
    // Hardware components
    Memory memory;
};
