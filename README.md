## Project Structure

```
SwiftBoy/
├── SwiftBoy/                          # Swift UI layer
│   ├── SwiftBoyApp.swift              # App entry point
│   ├── Views/
│   │   ├── ContentView.swift          # Main game screen
│   │   ├── GameControlsView.swift     # Virtual D-pad & buttons
│   │   ├── GameDisplayView.swift      # Renders 160x144 frame buffer
│   │   └── ROMPickerView.swift        # File picker for .gb files
│   ├── ViewModels/
│   │   └── EmulatorViewModel.swift    # Swift interface to emulator
│   ├── Services/
│   │   └── AudioService.swift         # AVAudioEngine for sound output
│   └── cpp/                           # C++ emulator core
│       ├── module.modulemap           # (already exists)
│       ├── GameBoy.hpp                # Main emulator facade
│       ├── GameBoy.cpp
│       ├── Core/                      # Emulator components
│       │   ├── CPU.hpp/cpp            # Sharp LR35902 CPU
│       │   ├── Memory.hpp/cpp         # Memory bus (0x0000-0xFFFF)
│       │   ├── PPU.hpp/cpp            # Picture Processing Unit
│       │   ├── APU.hpp/cpp            # Audio Processing Unit
│       │   ├── Timer.hpp/cpp          # Timer registers
│       │   ├── Joypad.hpp/cpp         # Controller input
│       │   └── Cartridge.hpp/cpp      # ROM/RAM/MBC handling
│       └── Utils/
│           └── Types.hpp              # Common types (uint8_t, etc.)
```

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
