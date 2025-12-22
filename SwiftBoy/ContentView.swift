//
//  ContentView.swift
//  SwiftBoy
//
//  Created by Andrew Gilliland on 12/20/25.
//

import SwiftUI
import GameBoy

struct GameDisplayView: View {
    let frameBuffer: [UInt8]
    
    var body: some View {
        Canvas { context, size in
            let width = 160
            let height = 144
            let scale = min(size.width / CGFloat(width), size.height / CGFloat(height))
            
            // Create image from pixel data
            if let image = createCGImage(from: frameBuffer, width: width, height: height) {
                let scaledSize = CGSize(width: CGFloat(width) * scale, height: CGFloat(height) * scale)
                let rect = CGRect(
                    x: (size.width - scaledSize.width) / 2,
                    y: (size.height - scaledSize.height) / 2,
                    width: scaledSize.width,
                    height: scaledSize.height
                )
                context.draw(Image(decorative: image, scale: 1.0), in: rect)
            }
        }
        .aspectRatio(160.0/144.0, contentMode: .fit)
    }
    
    private func createCGImage(from buffer: [UInt8], width: Int, height: Int) -> CGImage? {
        let bitsPerComponent = 8
        let bytesPerPixel = 4
        let bytesPerRow = width * bytesPerPixel
        
        let colorSpace = CGColorSpaceCreateDeviceRGB()
        let bitmapInfo = CGBitmapInfo(rawValue: CGImageAlphaInfo.premultipliedLast.rawValue)
        
        guard let providerRef = CGDataProvider(data: Data(buffer) as CFData) else {
            return nil
        }
        
        return CGImage(
            width: width,
            height: height,
            bitsPerComponent: bitsPerComponent,
            bitsPerPixel: bytesPerPixel * 8,
            bytesPerRow: bytesPerRow,
            space: colorSpace,
            bitmapInfo: bitmapInfo,
            provider: providerRef,
            decode: nil,
            shouldInterpolate: false,
            intent: .defaultIntent
        )
    }
}

struct ContentView: View {
    @State private var gameboy: GameBoy?
    @State private var frameBuffer: [UInt8] = []
    @State private var timer: Timer?
    
    var body: some View {
        VStack(spacing: 20) {
            Text("SwiftBoy Emulator")
                .font(.title)
                .bold()
            
            GameDisplayView(frameBuffer: frameBuffer)
                .frame(width: 320, height: 288) // 160x144 scaled 2x
                .border(Color.gray, width: 2)
            
            Text("\(frameBuffer.isEmpty ? "Initializing..." : "Running at 60 FPS")")
                .font(.caption)
                .foregroundColor(.secondary)
        }
        .padding()
        .onAppear {
            // Create the GameBoy instance
            gameboy = GameBoy()
            
            // Load test ROM
            let testData: [UInt8] = [0x00, 0xC3, 0x50, 0x01]
            testData.withUnsafeBufferPointer { buffer in
                if let baseAddress = buffer.baseAddress {
                    _ = gameboy?.loadROM(baseAddress, buffer.count)
                }
            }
            
            // Get initial frame buffer
            updateFrameBuffer()
            
            // Start rendering at 60 FPS
            timer = Timer.scheduledTimer(withTimeInterval: 1.0/60.0, repeats: true) { _ in
                Task { @MainActor in
                    gameboy?.runFrame()
                    updateFrameBuffer()
                }
            }
        }
        .onDisappear {
            timer?.invalidate()
        }
    }
    
    private func updateFrameBuffer() {
        guard let buffer = gameboy?.getFrameBuffer() else { return }
        
        // Copy C++ buffer to Swift array (160 * 144 * 4 = 92,160 bytes)
        frameBuffer = Array(UnsafeBufferPointer(start: buffer, count: 160 * 144 * 4))
    }
}
