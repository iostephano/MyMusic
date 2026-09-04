//
//  HomeViewModel.swift
//  MyMusic
//
//  Created by Stephano Portella on 29/07/25.
//

import Observation

@Observable
final class HomeViewModel {

    enum Category: String, CaseIterable, Identifiable {
        case all, nuevas, tendencias, top

        var id: Self { self }

        var title: String {
            switch self {
            case .all: "Todas"
            case .nuevas: "Novedades"
            case .tendencias: "Tendencias"
            case .top: "Top"
            }
        }
    }

    enum Tab: CaseIterable {
        case inicio, biblioteca, bucle, ajustes
    }

    var selectedCategory: Category = .all
    var selectedTab: Tab = .inicio

    let playlists: [Playlist] = [
        Playlist(title: "Reverie Estelar", author: "Budiarti", songs: 8, imageName: "artist1"),
        Playlist(title: "Confesiones de Medianoche", author: "Nocturna", songs: 12, imageName: "artist2"),
        Playlist(title: "Ecos en la Niebla", author: "Synthwave", songs: 10, imageName: "artist3"),
        Playlist(title: "Ecos del Mañana", author: "Lumen", songs: 9, imageName: "artist3")
    ]

    let featuredCards: [FeaturedCard] = [
        FeaturedCard(
            title: "Descubre semanal",
            description: "Instrumentales lentas para acompañar el día.",
            imageName: "featured_artist",
            tint: .discover
        ),
        FeaturedCard(
            title: "Aire fresco",
            description: "Novedades y tonos nocturnos con carácter.",
            imageName: "featured_artist",
            tint: .fresh
        )
    ]

    /// Playlists a mostrar según la categoría. Es determinista: dos accesos
    /// seguidos con la misma categoría devuelven el mismo orden (la versión
    /// anterior barajaba en cada acceso y la lista parpadeaba al redibujar).
    var filteredPlaylists: [Playlist] {
        switch selectedCategory {
        case .all:
            return playlists
        case .nuevas:
            return playlists.reversed()
        case .tendencias:
            return playlists.sorted { $0.songs > $1.songs }
        case .top:
            return playlists.sorted { $0.songs > $1.songs }.prefix(3).map { $0 }
        }
    }
}
