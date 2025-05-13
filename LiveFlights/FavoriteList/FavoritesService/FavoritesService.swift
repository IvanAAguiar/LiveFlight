//
//  FavoritesService.swift
//  LiveFlights
//
//  Created by Ivan Aguiar on 10/05/2025.
//

protocol FavoritesServiceRepresentable {
    func saveFavoriteAirline(_ airline: Airline) throws -> Bool
    func deleteFavoriteAirline(_ airline: Airline) throws -> Bool
    func fetchFavoriteAirlines() throws -> [Airline]
    func isAirlineFavorite(_ airline: Airline) -> Bool
}

final class FavoritesService: FavoritesServiceRepresentable {

    // MARK: - Inner Types

    struct Dependencies {
        let repository: FavoritesRepositoryRepresentable
    }

    //MARK: - Properties

    private let dependencies: Dependencies

    // MARK: - Init

    init(dependencies: Dependencies) {
        self.dependencies = dependencies
    }

    // MARK: - Methods

    func saveFavoriteAirline(_ airline: Airline) throws -> Bool {
        try dependencies.repository.saveFavoriteAirline(airline)
    }

    func deleteFavoriteAirline(_ airline: Airline) throws -> Bool {
        try dependencies.repository.deleteFavoriteAirline(airline)
    }

    func fetchFavoriteAirlines() throws -> [Airline] {
        try dependencies.repository.fetchFavoriteAirlines() ?? []
    }

    func isAirlineFavorite(_ airline: Airline) -> Bool {
        dependencies.repository.isAirlineFavorite(airlineId: airline.id ?? "")
    }

    /// Implement additional methods as needed.
}

// MARK: - MockFavoritesService

protocol MockFavoritesServiceRepresentable {
    var saveFavoriteAirlineCalled: Bool { get set }
    var deleteFavoriteAirlineCalled: Bool { get set }
    var fetchFavoriteAirlinesCalled: Bool { get set }
    var isAirlineFavoriteCalled: Bool { get set }

    var saveFavoriteAirlineResult: Result<Bool, Error> { get set }
    var deleteFavoriteAirlineResult: Result<Bool, Error> { get set }
    var fetchFavoriteAirlinesResult: Result<[Airline], Error> { get set }
    var isAirlineFavoriteResult: Bool { get set }

    var savedAirline: Airline? { get set }
    var deletedAirline: Airline? { get set }
    var checkedAirline: Airline? { get set }
}

final class MockFavoritesService: MockFavoritesServiceRepresentable, FavoritesServiceRepresentable {
    var saveFavoriteAirlineCalled = false
    var deleteFavoriteAirlineCalled = false
    var fetchFavoriteAirlinesCalled = false
    var isAirlineFavoriteCalled = false

    var saveFavoriteAirlineResult: Result<Bool, Error> = .success(true)
    var deleteFavoriteAirlineResult: Result<Bool, Error> = .success(true)
    var fetchFavoriteAirlinesResult: Result<[Airline], Error> = .success([])
    var isAirlineFavoriteResult: Bool = false

    var savedAirline: Airline?
    var deletedAirline: Airline?
    var checkedAirline: Airline?

    func saveFavoriteAirline(_ airline: Airline) throws -> Bool {
        saveFavoriteAirlineCalled = true
        savedAirline = airline
        return try saveFavoriteAirlineResult.get()
    }

    func deleteFavoriteAirline(_ airline: Airline) throws -> Bool {
        deleteFavoriteAirlineCalled = true
        deletedAirline = airline
        return try deleteFavoriteAirlineResult.get()
    }

    func fetchFavoriteAirlines() throws -> [Airline] {
        fetchFavoriteAirlinesCalled = true
        return try fetchFavoriteAirlinesResult.get()
    }

    func isAirlineFavorite(_ airline: Airline) -> Bool {
        isAirlineFavoriteCalled = true
        checkedAirline = airline
        return isAirlineFavoriteResult
    }
}

