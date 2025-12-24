## Project Structure

```
SwiftBoy/
├── SwiftBoyApp.swift
├── ContentView.swift
├── cpu_instrs.gb
├── Assets.xcassets/
│
├── GameBoy/                      # All emulator code
│   ├── GameBoy.swift            # Main coordinator
│   ├── Cartridge.swift          # ROM/MBC handling
│   │
│   ├── CPU/                     # CPU components
│   │   ├── CPU.swift           # Main CPU class
│   │   ├── Registers.swift     # CPU registers (AF, BC, DE, HL, SP, PC)
│   │   ├── Instructions.swift  # Opcode definitions
│   │   └── InstructionSet.swift # Instruction implementations
│   │
│   ├── Memory/                  # Memory components
│   │   ├── Memory.swift        # Memory management (MMU)
│   │   ├── MemoryMap.swift     # Address space constants
│   │   └── MBC/                # Memory Bank Controllers
│   │       ├── MBC1.swift
│   │       ├── MBC3.swift
│   │       └── MBC5.swift
│   │
│   ├── PPU/                     # Graphics components
│   │   ├── PPU.swift           # Picture Processing Unit
│   │   ├── Renderer.swift      # Frame rendering
│   │   ├── Sprite.swift        # OAM sprite handling
│   │   └── TileData.swift      # Tile/background map
│   │
│   ├── APU/                     # Audio components
│   │   └── APU.swift           # Audio Processing Unit
│   │
│   ├── Timer/                   # Timer component
│   │   └── Timer.swift         # Timer and divider
│   │
│   └── Joypad/                  # Input component
│       └── Joypad.swift        # Input handling
│
├── Views/                       # SwiftUI views
│   ├── GameDisplayView.swift
│   └── DebugViews/
│       ├── CPUDebugView.swift
│       ├── MemoryDebugView.swift
│       └── PPUDebugView.swift
│
└── Utilities/                   # Helper code
    ├── BitOperations.swift
    └── Constants.swift
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
