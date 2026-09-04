//
//  PlaybackManagerTests.swift
//  MyMusicTests
//
//  Created by Stephano Portella on 03/09/26.
//

import Testing
import Foundation
@testable import MyMusic

@MainActor
struct PlaybackManagerTests {

    @Test("Nothing is playing to start with")
    func startsIdle() {
        let manager = PlaybackManager()
        #expect(manager.nowPlayingID == nil)
    }

    @Test("Toggling an id starts it; toggling the same id stops it")
    func toggleIsReversible() {
        let manager = PlaybackManager()
        let id = UUID()

        manager.toggle(id)
        #expect(manager.isPlaying(id))

        manager.toggle(id)
        #expect(!manager.isPlaying(id))
        #expect(manager.nowPlayingID == nil)
    }

    @Test("Only one id plays at a time")
    func onlyOnePlays() {
        let manager = PlaybackManager()
        let first = UUID()
        let second = UUID()

        manager.toggle(first)
        manager.toggle(second)

        #expect(manager.isPlaying(second))
        #expect(!manager.isPlaying(first))
    }
}
