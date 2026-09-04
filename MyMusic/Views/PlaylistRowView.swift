//
//  PlaylistRowView.swift
//  MyMusic
//
//  Created by Stephano Portella on 29/07/25.
//

import SwiftUI

struct PlaylistRowView: View {
    let playlist: Playlist

    @Environment(PlaybackManager.self) private var playback

    var body: some View {
        HStack(spacing: 16) {
            Image(playlist.imageName)
                .resizable()
                .scaledToFill()
                .frame(width: 60, height: 60)
                .clipShape(RoundedRectangle(cornerRadius: 12))

            VStack(alignment: .leading, spacing: 4) {
                Text(playlist.title)
                    .foregroundStyle(.white)
                    .font(.system(size: 16, weight: .semibold))
                Text("De \(playlist.author) · \(playlist.songs) canciones")
                    .foregroundStyle(.white.opacity(0.6))
                    .font(.system(size: 13))
            }

            Spacer()

            Button {
                playback.toggle(playlist.id)
            } label: {
                Image(systemName: playback.isPlaying(playlist.id) ? "pause.fill" : "play.fill")
                    .foregroundStyle(.white)
                    .padding(6)
                    .background(.gray.opacity(0.3), in: .circle)
            }
        }
    }
}
