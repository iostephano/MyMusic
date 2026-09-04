//
//  CategorySelectorView.swift
//  MyMusic
//
//  Created by Stephano Portella on 29/07/25.
//

import SwiftUI

struct CategorySelectorView: View {
    @Binding var selected: HomeViewModel.Category

    var body: some View {
        ScrollView(.horizontal, showsIndicators: false) {
            HStack(spacing: 12) {
                ForEach(HomeViewModel.Category.allCases) { category in
                    Button {
                        selected = category
                    } label: {
                        Text(category.title)
                            .font(.system(size: 14, weight: .medium))
                            .padding(.vertical, 8)
                            .padding(.horizontal, 16)
                            .background(
                                selected == category ? Color("AccentColor") : Color.white.opacity(0.08),
                                in: .capsule
                            )
                            .foregroundStyle(selected == category ? .black : .white)
                    }
                }
            }
        }
    }
}
