//
//  PlaylistListView.swift
//  MyMusic
//
//  Created by Stephano Portella on 29/07/25.
//

import SwiftUI

struct PlaylistListView: View {
    let playlists: [Playlist]

    var body: some View {
        VStack(alignment: .leading, spacing: 16) {
            HStack {
                Text("Playlists del día")
                    .foregroundStyle(.white)
                    .font(.system(size: 20, weight: .semibold))

                Spacer()

                Button("Ver todo") {}
                    .font(.system(size: 14))
                    .foregroundStyle(.white.opacity(0.7))
            }

            ForEach(playlists) { playlist in
                PlaylistRowView(playlist: playlist)
            }
        }
    }
}
