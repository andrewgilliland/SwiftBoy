//
//  ContentView.swift
//  SwiftBoy
//
//  Created by Andrew Gilliland on 12/20/25.
//

import SwiftUI
import GameBoy

struct ContentView: View {
    @State private var gameboy: GameBoy?
    @State private var result: String = "No ROM loaded"
    
    var body: some View {
        VStack {
            Image(systemName: "globe")
                .imageScale(.large)
                .foregroundStyle(.tint)
            Text(result)
        }
        .padding()
        .onAppear {
            // Create the GameBoy instance
            gameboy = GameBoy()
            
            // Example: Load a test ROM (you'd normally load from a file)
            let testData: [UInt8] = [0x00, 0xC3, 0x50, 0x01] // Sample bytes
            testData.withUnsafeBufferPointer { buffer in
                if let baseAddress = buffer.baseAddress {
                    let success = gameboy?.loadROM(baseAddress, buffer.count)
                    result = success == true ? "ROM loaded!" : "Failed to load ROM"
                }
            }
        }
    }
}
