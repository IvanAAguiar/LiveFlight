//
//  FlightListViewModel.swift
//  LiveFlights
//
//  Created by Ivan Aguiar on 11/05/2025.
//

import Foundation
import Combine

protocol FlightListViewModelRepresentable: ObservableObject {
    var flights: [Flight] { get }
    var state: FlightListViewModel.State { get }
    var loadingMessage: String { get }
    var screenTitle: String { get }
    var searchText: String { get set }
    var filterPlaceholder: String { get }

    func onAppear() async
    func filterFlights(searchText: String) async
}

final class FlightListViewModel: FlightListViewModelRepresentable {

    // MARK: - Inner Types

    enum State {
        case loading
        case error(any GenericErrorViewModelRepresentable)
        case empty(any GenericErrorViewModelRepresentable)
        case success
    }

        private enum Constants {
            static let screenTitle = "Flights"
            static let loadingText = "Loading Flights..."
            static let filterPlaceHolder = "5J309"
        }

    struct Dependencies {
        let service: any FlightsServiceRepresentable
        let airline: Airline
    }

    // MARK: - Properties

    @Published var flightsToShown: [Flight] = []
    @Published var state: State = .loading
    @Published var searchText: String = ""

    var flights: [Flight] = []

    var screenTitle: String = Constants.screenTitle
    let loadingMessage = Constants.loadingText
    let filterPlaceholder = Constants.filterPlaceHolder

    private let dependencies: Dependencies

    // MARK: - Init

    init(dependencies: Dependencies) {
        self.dependencies = dependencies
    }

    // MARK: - Methods

    @MainActor
    func onAppear() async {
        await fetchFlights()

        /// Add here other call if needed. Ex. Analytic methods.
    }
}

// MARK: - Fetch Flights

extension FlightListViewModel {
    private func fetchFlights() async {
        do {
            let flights = try await dependencies.service.fetchFlights(iataCode: dependencies.airline.iataCode, date: nil, status: nil)

            await handleSuccess(model: flights)
        } catch {
            handleFailure(error: error)
        }
    }
}

// MARK: - Handle Success

extension FlightListViewModel {
    func handleSuccess(model: [Flight]) async {
        guard !model.isEmpty else {
            state = .empty(GenericErrorViewModel(systemImageName: "empty_image"))
            return
        }

        flights = model

        await MainActor.run {
            flightsToShown =  model
            state = .success
        }
    }
}

// MARK: - Handle Failure

extension FlightListViewModel {
    func handleFailure(error: Error) {
        state = .error(GenericErrorViewModel(errorMessage: error.localizedDescription))
    }
}
// MARK: - Filters

extension FlightListViewModel {
    func filterFlights(searchText: String) async {
        if searchText.isEmpty {
            flightsToShown = flights
        } else {
            let lowercasedSearchText = searchText.lowercased()
            flightsToShown = flights.filter { flight in
                (flight.flight.number.lowercased().contains(lowercasedSearchText))
                || (flight.flight.iata.lowercased().contains(lowercasedSearchText))
                || (flight.flight.icao.lowercased().contains(lowercasedSearchText))
            }
        }
    }
}
