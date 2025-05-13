//
//  AirlineListViewModel.swift
//  LiveFlights
//
//  Created by Ivan Aguiar on 05/05/2025.
//

import Foundation
import Combine
import CoreData

protocol AirlineListViewModelRepresentable: ObservableObject {
    var screenTitle: String { get }
    var loadingMessage: String { get }
    var state: AirlineListViewModel.State { get set }
    var searchText: String { get set }
    var filterPlaceholder: String { get }
    var selectedAirline: Airline? { get set }
    var airlinesToShown: [Airline] { get }

    func onAppear() async
    func filterAirlines(searchText: String) async
    func saveAirline(_ airline: Airline) -> Bool
    func deleteAirline(_ airline: Airline) -> Bool
}

final class AirlineListViewModel: AirlineListViewModelRepresentable {

    // MARK: - Inner Types

    enum State: Equatable {
        case loading
        case failure(any GenericErrorViewModelRepresentable)
        case empty(any GenericErrorViewModelRepresentable)
        case success

        static func == (rhs: State, lhs: State) -> Bool {
            switch (rhs, lhs) {
            case (.loading, .loading): return true
            case (.failure, .failure): return true
            case (.empty, .empty): return true
            case (.success, .success): return true
            default: return false
            }
        }
    }

    private enum Constants {
        static let screenTitle = "Live Flights App"
        static let loadingText = "Loading Airlines..."
        static let filterPlaceHolder = "Search by name or IATA code"
        static let errorTitle = "Data Loading Error"
        static let emptyTitle = "No Airlines Available"
        static let emptyMessage = "The list of airlines is currently empty."
    }

    struct Dependencies {
        let service: AirlinesServiceRepresentable
        let favoritesService: FavoritesServiceRepresentable
    }

    // MARK: - Properties

    let screenTitle = Constants.screenTitle
    let loadingMessage = Constants.loadingText
    let filterPlaceholder = Constants.filterPlaceHolder

    @Published var state: State = .loading
    @Published var searchText: String = ""
    @Published var selectedAirline: Airline?
    @Published var airlinesToShown: [Airline] = []

    var airlines: [Airline] = []

    private let dependencies: Dependencies

    //MARK: - Init

    init(dependencies: Dependencies) {
        self.dependencies = dependencies
    }

    // MARK: - Methods

    @MainActor
    func onAppear() async {
        await fetchAirlines()

        /// Add here other call if needed. Ex. Analytic methods.
    }
}

// MARK: - Fetch Airlines

extension AirlineListViewModel {
    private func fetchAirlines() async {
        do {
            let airlines = try await dependencies.service.fetchAirlines(
                name: nil,
                iataCode: nil
            )

            await handleSuccess(model: airlines)
        } catch let error {
            handleFailure(error: error)
        }
    }
}

// MARK: - Handle Success

extension AirlineListViewModel {
    func handleSuccess(model: [Airline]) async {
        guard !model.isEmpty else {
            state = .empty(createEmptyErrorViewModel())
            return
        }

        airlines = model

        await MainActor.run {
            airlinesToShown =  model
            state = .success
        }
    }

    func createEmptyErrorViewModel() -> any GenericErrorViewModelRepresentable {
        GenericErrorViewModel(
            errorTitle: Constants.emptyTitle,
            errorMessage: Constants.emptyMessage
        )
    }
}

// MARK: - Handle Failure

extension AirlineListViewModel {
    func handleFailure(error: Error) {
        state = .failure(createErrorViewModel(error))
    }

    func createErrorViewModel(_ error: Error) -> any GenericErrorViewModelRepresentable {
        GenericErrorViewModel(
            errorTitle: Constants.errorTitle,
            errorMessage: error.localizedDescription,
            retryAction: { [weak self] in
                Task {
                    await self?.fetchAirlines()
                }
            }
        )
    }
}

// MARK: - Filters

extension AirlineListViewModel {
    func filterAirlines(searchText: String) async {
        if searchText.isEmpty {
            airlinesToShown = airlines
        } else {
            let lowercasedSearchText = searchText.lowercased()
            airlinesToShown = airlines.filter { airline in
                (airline.airlineName?.lowercased().contains(lowercasedSearchText) ?? false) ||
                (airline.iataCode?.lowercased().contains(lowercasedSearchText) ?? false)
            }
        }
    }
}

// MARK: - Save Airlines

extension AirlineListViewModel {
    func saveAirline(_ airline: Airline) -> Bool {
        do {
            let isSaved = try dependencies.favoritesService.saveFavoriteAirline(airline)
            try dependencies.service.updateAirlineIsFavorite(airlineId: airline.id ?? "", isFavorite: isSaved)

            return isSaved
        } catch {
            state = .failure(createErrorViewModel(error))
            return false
        }
    }

    func deleteAirline(_ airline: Airline) -> Bool {
        do {
            let isDeleted = try dependencies.favoritesService.deleteFavoriteAirline(airline)
            try dependencies.service.updateAirlineIsFavorite(airlineId: airline.id ?? "", isFavorite: !isDeleted)

            return isDeleted
        } catch {
            state = .failure(createErrorViewModel(error))
            return false
        }
    }
}
