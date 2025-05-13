//
//  FavoriteAirlineViewModel.swift
//  LiveFlights
//
//  Created by Ivan Aguiar on 10/05/2025.
//

import Foundation

protocol FavoritesViewModelRepresentable: ObservableObject {
    var airlines: [Airline] { get set }
    var state: FavoritesViewModel.State { get set }

    func loadFavoriteAirlines()
    func deleteFavorite(_ airline: Airline)
}

final class FavoritesViewModel: FavoritesViewModelRepresentable {

    // MARK: - Inner Types

    enum State: Equatable {
        case success
        case failure(any GenericErrorViewModelRepresentable)
        case empty(any GenericErrorViewModelRepresentable)

        static func == (rhs: State, lhs: State) -> Bool {
            switch (rhs, lhs) {
            case (.success, .success): return true
            case (.failure, .failure): return true
            case (.empty, .empty): return true
            default: return false
            }
        }
    }

    private enum Constants {
        static let emptyImage: String = "empty_image"
    }

    struct Dependencies {
        let service: FavoritesServiceRepresentable
    }

    // MARK: - Properties

    @Published var airlines: [Airline] = []
    @Published var state: State = .success

    private let dependencies: Dependencies

    // MARK: - Init

    init(dependencies: Dependencies) {
        self.dependencies = dependencies
    }

    // MARK: - Methods

    func loadFavoriteAirlines() {
        do {
            airlines = try dependencies.service.fetchFavoriteAirlines()

            if airlines.isEmpty {
                state = .empty(GenericErrorViewModel(systemImageName: Constants.emptyImage))
            }
        } catch {
            state = .failure(GenericErrorViewModel(errorMessage: error.localizedDescription))
        }
    }

    func deleteFavorite(_ airline: Airline) {
        do {
            _ = try dependencies.service.deleteFavoriteAirline(airline)
            loadFavoriteAirlines()
        } catch {
            state = .failure(GenericErrorViewModel(errorMessage: error.localizedDescription))
        }
    }
}
