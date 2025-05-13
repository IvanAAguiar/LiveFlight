//
//  MainViewModel.swift
//  LiveFlights
//
//  Created by Ivan Aguiar on 09/05/2025.
//

import Foundation

protocol MainViewModelRepresentable: ObservableObject {
    var selectedTab: AppTab { get set }
    var airplaneTitle: String { get }
    var favoriteTitle: String { get }
    var mapTitle: String { get }
    var airplaneIcon: String { get }
    var favoriteIcon: String { get }
    var mapIcon: String { get }
}

final class MainViewModel: MainViewModelRepresentable {

    // MARK: - Inner Types

    private enum Constants {
        static let airplaneTitle = "Airlines"
        static let favoriteTitle = "Favorites"
        static let mapTitle = "Map"
        static let airplaneIcon = "airplane"
        static let favoriteIcon = "heart.fill"
        static let mapIcon = "map.fill"
    }

    // MARK: - Properties

    @Published var selectedTab: AppTab = .airlines

    var airplaneTitle = Constants.airplaneTitle
    var favoriteTitle = Constants.favoriteTitle
    var mapTitle = Constants.airplaneTitle
    var airplaneIcon = Constants.airplaneIcon
    var favoriteIcon = Constants.favoriteIcon
    var mapIcon = Constants.mapIcon

    //MARK: - Init

    init() {
        /// Set up the initial state of this instance, assigning values to its properties as needed.
    }
}
