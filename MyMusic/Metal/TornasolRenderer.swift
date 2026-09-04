//
//  TornasolRenderer.swift
//  MyMusic
//
//  Created by Stephano Portella on 29/07/25.
//

import MetalKit

/// Dibuja el fragment shader `tornasol_fragment` sobre un quad a pantalla
/// completa, pasándole el tiempo transcurrido. Si algo del pipeline falla, el
/// inicializador devuelve `nil` y la vista se queda transparente.
final class TornasolRenderer: NSObject, MTKViewDelegate {

    private let commandQueue: MTLCommandQueue
    private let pipelineState: MTLRenderPipelineState
    private let startTime = CACurrentMediaTime()

    init?(device: MTLDevice) {
        guard let commandQueue = device.makeCommandQueue(),
              let library = device.makeDefaultLibrary(),
              let vertexFunction = library.makeFunction(name: "vertex_main"),
              let fragmentFunction = library.makeFunction(name: "tornasol_fragment") else {
            return nil
        }

        let descriptor = MTLRenderPipelineDescriptor()
        descriptor.vertexFunction = vertexFunction
        descriptor.fragmentFunction = fragmentFunction

        let attachment = descriptor.colorAttachments[0]!
        attachment.pixelFormat = .bgra8Unorm
        attachment.isBlendingEnabled = true
        attachment.rgbBlendOperation = .add
        attachment.alphaBlendOperation = .add
        attachment.sourceRGBBlendFactor = .sourceAlpha
        attachment.sourceAlphaBlendFactor = .sourceAlpha
        attachment.destinationRGBBlendFactor = .oneMinusSourceAlpha
        attachment.destinationAlphaBlendFactor = .oneMinusSourceAlpha

        guard let pipelineState = try? device.makeRenderPipelineState(descriptor: descriptor) else {
            return nil
        }

        self.commandQueue = commandQueue
        self.pipelineState = pipelineState
        super.init()
    }

    func mtkView(_ view: MTKView, drawableSizeWillChange size: CGSize) {}

    func draw(in view: MTKView) {
        guard let drawable = view.currentDrawable,
              let descriptor = view.currentRenderPassDescriptor,
              let commandBuffer = commandQueue.makeCommandBuffer(),
              let encoder = commandBuffer.makeRenderCommandEncoder(descriptor: descriptor) else { return }

        encoder.setRenderPipelineState(pipelineState)

        var time = Float(CACurrentMediaTime() - startTime)
        encoder.setFragmentBytes(&time, length: MemoryLayout<Float>.size, index: 0)

        encoder.drawPrimitives(type: .triangle, vertexStart: 0, vertexCount: 6)
        encoder.endEncoding()

        commandBuffer.present(drawable)
        commandBuffer.commit()
    }
}
