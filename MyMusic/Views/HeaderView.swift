//
//  HeaderView.swift
//  MyMusic
//
//  Created by Stephano Portella on 29/07/25.
//

import SwiftUI

struct HeaderView: View {
    @State private var isHeartActive = false
    @State private var isSearching = false
    @State private var searchText = ""

    var body: some View {
        VStack(alignment: .leading, spacing: 16) {
            HStack {
                Image("profile")
                    .resizable()
                    .scaledToFill()
                    .frame(width: 44, height: 44)
                    .clipShape(.circle)

                Spacer()

                HStack(spacing: 12) {
                    CircleIconButton(systemName: "magnifyingglass") {
                        withAnimation { isSearching.toggle() }
                    }
                    CircleIconButton(
                        systemName: isHeartActive ? "heart.fill" : "heart",
                        color: isHeartActive ? .red : .white
                    ) {
                        isHeartActive.toggle()
                    }
                }
            }

            if isSearching {
                TextField("Buscar…", text: $searchText)
                    .textFieldStyle(.roundedBorder)
                    .transition(.move(edge: .top).combined(with: .opacity))
            }

            Text("Hola, Jenny")
                .font(.system(size: 32, weight: .bold))
                .foregroundStyle(.white)
                .padding(.leading, 4)
        }
    }
}

struct CircleIconButton: View {
    let systemName: String
    var color: Color = .white
    var action: () -> Void

    var body: some View {
        Button(action: action) {
            Image(systemName: systemName)
                .foregroundStyle(color)
                .frame(width: 36, height: 36)
                .background(.ultraThinMaterial, in: .circle)
        }
    }
}
