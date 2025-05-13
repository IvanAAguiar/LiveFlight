//
//  FlightsService.swift
//  LiveFlights
//
//  Created by Ivan Aguiar on 11/05/2025.
//

import Foundation

protocol FlightsServiceRepresentable {
    func fetchFlights(
        iataCode: String?,
        date: String?,
        status: String?
    ) async throws -> [Flight]
}

final class FlightsService: FlightsServiceRepresentable {

    // MARK: - Inner Types

    struct Dependencies {
        let repository: any FlightsRepositoryRepresentable
        let apiClient: any APIClientFlightsFetchable
    }

    // MARK: - Properties

    private let dependencies: Dependencies

    // MARK: - Init

    init(dependencies: Dependencies) {
        self.dependencies = dependencies
    }

    // MARK: - Methods

    func fetchFlights(
        iataCode: String? = nil,
        date: String? = nil,
        status: String? = nil
    ) async throws -> [Flight] {
        if /// Try to fetch flight list from CoreData first
            let cachedFlights = try dependencies.repository.fetchCachedFlights(),
            !cachedFlights.isEmpty
        { return cachedFlights }

        let flightsResponse = try await dependencies.apiClient.fetchFlights(iataCode: iataCode, date: date, status: status)
        let fetchedFlights = flightsResponse.data

        /// Save API data on CoreData to avoid extra calls
        try dependencies.repository.saveFlights(fetchedFlights)

        return fetchedFlights
    }
}

// MARK: - MockFlightsService

protocol MockFlightsServiceRepresentable {
    var fetchFlightsResult: Result<[Flight], Error> { get set}
    var fetchFlightsCalled: Bool { get set }
    var fetchedIataCode: String? { get set }
}

final class MockFlightsService: MockFlightsServiceRepresentable, FlightsServiceRepresentable {
    var fetchFlightsCalled = false
    var fetchedIataCode: String?
    var fetchFlightsResult: Result<[Flight], Error> = .success([])

    func fetchFlights(
        iataCode: String?,
        date: String?,
        status: String?
    ) async throws -> [Flight] {
        fetchFlightsCalled = true
        fetchedIataCode = iataCode
        return try fetchFlightsResult.get()
    }
}
