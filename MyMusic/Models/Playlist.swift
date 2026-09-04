//
//  Playlist.swift
//  MyMusic
//
//  Created by Stephano Portella on 29/07/25.
//

import Foundation

/// Una playlist de la maqueta. Los datos son ficticios y viven en
/// `HomeViewModel`; no hay reproducción real (ver README).
struct Playlist: Identifiable, Hashable, Sendable {
    let id = UUID()
    let title: String
    let author: String
    let songs: Int
    let imageName: String
}
