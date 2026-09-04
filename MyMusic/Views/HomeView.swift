//
//  HomeView.swift
//  MyMusic
//
//  Created by Stephano Portella on 29/07/25.
//

import SwiftUI

struct HomeView: View {
    @State private var viewModel = HomeViewModel()

    // El fondo Metal decorativo se ancla arriba a la izquierda y sobresale de la
    // pantalla, así solo se ve el "rayo" difuminado en esa esquina.
    private let backgroundSize = CGSize(width: 300, height: 600)
    private let backgroundOffset = CGSize(width: -80, height: -80)

    var body: some View {
        ZStack(alignment: .bottom) {
            VStack {
                TornasolBackgroundView()
                    .frame(width: backgroundSize.width, height: backgroundSize.height)
                    .offset(backgroundOffset)
                    .allowsHitTesting(false)
                Spacer()
            }
            .ignoresSafeArea()

            ScrollView(.vertical, showsIndicators: false) {
                VStack(alignment: .leading, spacing: 24) {
                    HeaderView()
                    CategorySelectorView(selected: $viewModel.selectedCategory)

                    Text("Selección y tendencias")
                        .font(.system(size: 20, weight: .semibold))
                        .foregroundStyle(.white)

                    ScrollView(.horizontal, showsIndicators: false) {
                        HStack(spacing: 16) {
                            ForEach(viewModel.featuredCards) { card in
                                FeaturedCardView(card: card)
                            }
                        }
                        .padding(.horizontal, 4)
                    }

                    PlaylistListView(playlists: viewModel.filteredPlaylists)
                        .padding(.bottom, 100)
                }
                .padding(.horizontal)
                .padding(.top, 20)
            }

            CustomTabBarView(selectedTab: $viewModel.selectedTab)
        }
        .preferredColorScheme(.dark)
    }
}

#Preview {
    HomeView()
        .environment(PlaybackManager())
}
