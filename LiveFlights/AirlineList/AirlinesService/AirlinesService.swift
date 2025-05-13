//
//  AirlinesService.swift
//  LiveFlights
//
//  Created by Ivan Aguiar on 05/05/2025.
//

import Foundation
import CoreData

protocol AirlinesServiceRepresentable {
    func fetchAirlines(
        name: String?,
        iataCode: String?
    ) async throws -> [Airline]
    func updateAirlineIsFavorite(airlineId: String, isFavorite: Bool) throws
}

final class AirlinesService: AirlinesServiceRepresentable {

    //MARK: - Inner Types

    struct Dependencies {
        let repository: any AirlinesRepositoryRepresentable
        let apiClient: any APIClientAirlinesFetchable
    }

    // MARK: - Properties

    private let dependencies: Dependencies


    // MARK: - Init

    init(dependencies: Dependencies) {
        self.dependencies = dependencies
    }

    // MARK: - Methods

    func fetchAirlines(
        name: String? = nil,
        iataCode: String? = nil
    ) async throws -> [Airline] {
        if /// Try to fetch airline list from CoreData first
            let cachedAirlines = try dependencies.repository.fetchCachedAirlines(
                name: name,
                iataCode: iataCode
            ),
            !cachedAirlines.isEmpty
        { return cachedAirlines }
        
        let airlineResponse = try await dependencies.apiClient.fetchAirlines(
            name: name,
            iataCode: iataCode
        )

        let fetchedAirlines = airlineResponse.data

        /// Save API data on CoreData to avoid extra calls
        try dependencies.repository.saveAirlines(fetchedAirlines)

        return fetchedAirlines
    }

    func updateAirlineIsFavorite(airlineId: String, isFavorite: Bool) throws {
        try dependencies.repository.updateAirlineIsFavorite(
                airlineId: airlineId,
                isFavorite: isFavorite
            )
        }

    /// Implement additional methods as needed.
}

// MARK: - MockAirlinesService

protocol MockAirlinesServiceRepresentable {
    var fetchAirlinesResult: Result<[Airline], Error> { get set }
    var isAirlineSaved: Bool { get set }
}

final class MockAirlinesService: MockAirlinesServiceRepresentable, AirlinesServiceRepresentable {

    // MARK: - Properties

    var fetchAirlinesResult: Result<[Airline], Error> = .success([])
    var isAirlineSaved: Bool = false

    // MARK: - Init

    init() {}

    // MARK: - Methods

    func fetchAirlines(
        name: String? = nil,
        iataCode: String? = nil
    ) async throws -> [Airline] {
        switch fetchAirlinesResult {
        case .success(let airlines):
            return airlines
        case .failure:
            throw NSError(
                domain: "TestError",
                code: 123,
                userInfo: [NSLocalizedDescriptionKey: "Generic Test Error"]
            )
        }
    }

    func updateAirlineIsFavorite(airlineId: String, isFavorite: Bool) throws {
        isAirlineSaved.toggle()
    }
}
