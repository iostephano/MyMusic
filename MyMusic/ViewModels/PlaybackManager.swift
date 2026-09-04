//
//  PlaybackManager.swift
//  MyMusic
//
//  Created by Stephano Portella on 29/07/25.
//

import Foundation
import Observation

/// Lleva qué elemento está "sonando" en la maqueta. No reproduce audio: solo
/// alterna el identificador para que la UI muestre el botón de pausa (ver README).
@Observable
final class PlaybackManager {

    private(set) var nowPlayingID: UUID?

    func toggle(_ id: UUID) {
        nowPlayingID = (nowPlayingID == id) ? nil : id
    }

    func isPlaying(_ id: UUID) -> Bool {
        nowPlayingID == id
    }
}
