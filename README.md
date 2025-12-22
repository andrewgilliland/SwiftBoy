## Design Goals

    1.	C++ owns emulation
    2.	Swift owns UI
    3.	One call per frame
    4.	No per-instruction bridging
    5.	Plain data at the boundary

## Core Concepts

### Fixed hardware facts

    •	Resolution: 160 × 144
    •	Frame rate: ~59.73 Hz
    •	Pixel format: RGBA8888
    •	Audio: stereo PCM

## MVP Roadmap (in order)

    1. [] ROM loading
    2. [] CPU instruction decoding
    3. [] Memory bus
    4. [] PPU scanline rendering
    5. [] Frame buffer output
    6. [] SwiftUI display
    7. [] Input mapping
    8. [] Audio
    9. [] Timing accuracy
    10. [] Save states
