//
//  FeaturedCardView.swift
//  MyMusic
//
//  Created by Stephano Portella on 29/07/25.
//

import SwiftUI

struct FeaturedCard: Identifiable, Equatable, Sendable {
    let id = UUID()
    let title: String
    let description: String
    let imageName: String
    let tint: Tint

    enum Tint {
        case discover, fresh

        var color: Color {
            switch self {
            case .discover: Color.purple.opacity(0.35)
            case .fresh: Color("AccentColor").opacity(0.6)
            }
        }
    }
}

struct FeaturedCardView: View {
    let card: FeaturedCard

    @Environment(PlaybackManager.self) private var playback
    @State private var isLiked = false
    @State private var downloadState: DownloadState = .idle

    private enum DownloadState { case idle, done }

    var body: some View {
        ZStack {
            card.tint.color
                .clipShape(RoundedRectangle(cornerRadius: 20))

            HStack {
                VStack(alignment: .leading, spacing: 8) {
                    Text(card.title)
                        .font(.system(size: 20, weight: .bold))
                        .foregroundStyle(.white)

                    Text(card.description)
                        .font(.system(size: 14))
                        .foregroundStyle(.white.opacity(0.8))

                    HStack(spacing: 16) {
                        Button {
                            withAnimation(.easeInOut) { playback.toggle(card.id) }
                        } label: {
                            Image(systemName: playback.isPlaying(card.id) ? "pause.fill" : "play.fill")
                                .foregroundStyle(.white)
                                .padding(10)
                                .background(.black, in: .circle)
                                .scaleEffect(playback.isPlaying(card.id) ? 1.1 : 1)
                        }

                        Button {
                            withAnimation(.easeInOut) { isLiked.toggle() }
                        } label: {
                            Image(systemName: isLiked ? "heart.fill" : "heart")
                                .foregroundStyle(isLiked ? .red : .white)
                                .scaleEffect(isLiked ? 1.2 : 1)
                        }

                        Button {
                            flashDownload()
                        } label: {
                            Image(systemName: downloadState == .done ? "checkmark.circle.fill" : "arrow.down.circle")
                                .foregroundStyle(.white)
                                .scaleEffect(downloadState == .done ? 1.2 : 1)
                        }
                    }
                    .padding(.top, 8)
                }

                Spacer()

                Image(card.imageName)
                    .resizable()
                    .scaledToFill()
                    .frame(width: 120, height: 120)
                    .clipShape(RoundedRectangle(cornerRadius: 16))
            }
            .padding()
        }
        .frame(width: 320, height: 160)
    }

    private func flashDownload() {
        withAnimation(.spring(response: 0.3, dampingFraction: 0.5)) { downloadState = .done }
        Task {
            try? await Task.sleep(for: .seconds(1.2))
            withAnimation { downloadState = .idle }
        }
    }
}
