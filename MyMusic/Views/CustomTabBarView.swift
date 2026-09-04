//
//  CustomTabBarView.swift
//  MyMusic
//
//  Created by Stephano Portella on 29/07/25.
//

import SwiftUI

struct CustomTabBarView: View {
    @Binding var selectedTab: HomeViewModel.Tab

    private let tabs: [(tab: HomeViewModel.Tab, icon: String)] = [
        (.inicio, "house.fill"),
        (.biblioteca, "square.stack.fill"),
        (.bucle, "repeat"),
        (.ajustes, "gearshape.fill")
    ]

    var body: some View {
        HStack(spacing: 32) {
            ForEach(tabs, id: \.tab) { entry in
                Button {
                    selectedTab = entry.tab
                } label: {
                    Image(systemName: entry.icon)
                        .foregroundStyle(selectedTab == entry.tab ? .black : .white)
                        .frame(width: 44, height: 44)
                        .background(
                            selectedTab == entry.tab ? Color("AccentColor") : .clear,
                            in: .circle
                        )
                }
            }
        }
        .padding()
        .background(.ultraThinMaterial, in: .capsule)
        .padding(.horizontal)
        .padding(.bottom, 16)
    }
}
