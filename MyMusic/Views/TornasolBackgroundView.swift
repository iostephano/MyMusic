//
//  TornasolBackgroundView.swift
//  MyMusic
//
//  Created by Stephano Portella on 29/07/25.
//

import SwiftUI
import MetalKit

/// Fondo decorativo: un "rayo" iridiscente animado dibujado por un fragment
/// shader de Metal. Si el dispositivo no tiene Metal, la vista queda transparente
/// y no pasa nada más.
struct TornasolBackgroundView: UIViewRepresentable {

    func makeUIView(context: Context) -> MTKView {
        let view = MTKView()
        view.colorPixelFormat = .bgra8Unorm
        view.clearColor = MTLClearColor(red: 0, green: 0, blue: 0, alpha: 0)
        view.framebufferOnly = false
        view.isPaused = false
        view.enableSetNeedsDisplay = false
        view.preferredFramesPerSecond = 60
        view.layer.isOpaque = false

        guard let device = MTLCreateSystemDefaultDevice() else { return view }
        view.device = device

        if let renderer = TornasolRenderer(device: device) {
            context.coordinator.renderer = renderer
            view.delegate = renderer
        }
        return view
    }

    func updateUIView(_ uiView: MTKView, context: Context) {}

    func makeCoordinator() -> Coordinator { Coordinator() }

    final class Coordinator {
        var renderer: TornasolRenderer?
    }
}
