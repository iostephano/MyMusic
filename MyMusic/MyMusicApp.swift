//
//  MyMusicApp.swift
//  MyMusic
//
//  Created by Stephano Portella on 29/07/25.
//

import SwiftUI

@main
struct MyMusicApp: App {
    @State private var playbackManager = PlaybackManager()

    var body: some Scene {
        WindowGroup {
            HomeView()
                .environment(playbackManager)
        }
    }
}
