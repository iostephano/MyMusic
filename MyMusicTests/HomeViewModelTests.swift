//
//  HomeViewModelTests.swift
//  MyMusicTests
//
//  Created by Stephano Portella on 03/09/26.
//

import Testing
@testable import MyMusic

@MainActor
struct HomeViewModelTests {

    @Test("The default category shows every playlist in order")
    func allShowsEverything() {
        let vm = HomeViewModel()
        #expect(vm.filteredPlaylists == vm.playlists)
    }

    @Test("Novedades reverses the list")
    func novedadesReverses() {
        let vm = HomeViewModel()
        vm.selectedCategory = .nuevas
        #expect(vm.filteredPlaylists == vm.playlists.reversed())
    }

    @Test("Tendencias orders by song count, most first")
    func tendenciasOrdersBySongs() {
        let vm = HomeViewModel()
        vm.selectedCategory = .tendencias
        let counts = vm.filteredPlaylists.map(\.songs)
        #expect(counts == counts.sorted(by: >))
    }

    @Test("Top keeps at most three playlists")
    func topIsCapped() {
        let vm = HomeViewModel()
        vm.selectedCategory = .top
        #expect(vm.filteredPlaylists.count <= 3)
    }

    @Test("Filtering is deterministic: two reads give the same order")
    func filteringIsDeterministic() {
        let vm = HomeViewModel()
        for category in HomeViewModel.Category.allCases {
            vm.selectedCategory = category
            #expect(vm.filteredPlaylists == vm.filteredPlaylists)
        }
    }

    @Test("Every category returns a subset of the real playlists")
    func everyCategoryIsASubset() {
        let vm = HomeViewModel()
        let all = Set(vm.playlists)
        for category in HomeViewModel.Category.allCases {
            vm.selectedCategory = category
            #expect(Set(vm.filteredPlaylists).isSubset(of: all))
        }
    }

    @Test("Every category name is filled in")
    func categoryTitles() {
        for category in HomeViewModel.Category.allCases {
            #expect(!category.title.isEmpty)
        }
    }
}
