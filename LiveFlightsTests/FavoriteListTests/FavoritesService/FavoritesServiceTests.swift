//
//  FavoritesServiceTests.swift
//  LiveFlightsTests
//
//  Created by Ivan Aguiar on 10/05/2025.
//

import XCTest
@testable import LiveFlights

final class FavoritesServiceTests: XCTestCase {

    // MARK: - Inner Types

    typealias MockFavoritesRepositoryProtocols = MockFavoritesRepositoryRepresentable & FavoritesRepositoryRepresentable

    // MARK: - Properties

    private var service: FavoritesService!
    private var mockRepository: MockFavoritesRepositoryProtocols!
    private let mockAirline = AirlineModel.mock().data[0]

    // MARK: - Setup

    override func setUp() {
        super.setUp()

        mockRepository = MockFavoritesRepository()
        service = FavoritesService(
            dependencies: .init(
                repository: mockRepository
            )
        )
    }

    // MARK: - TearDown

    override func tearDown() {
        service = nil
        mockRepository = nil

        super.tearDown()
    }

    // MARK: - Tests - saveFavoriteAirline

    func testSaveFavoriteAirlineCallsRepository() throws {
        // GIVEN
        mockRepository.saveFavoriteAirlineResult = true

        // WHEN
        let result = try service.saveFavoriteAirline(mockAirline)

        // THEN
        XCTAssertTrue(mockRepository.saveFavoriteAirlineCalled)
        XCTAssertEqual(mockRepository.savedAirline?.id, mockAirline.id)
        XCTAssertTrue(result)
    }

    func testSaveFavoriteAirlineReturnsRepositoryResult() throws {
        // GIVEN
        mockRepository.saveFavoriteAirlineResult = false

        // WHEN
        let result = try service.saveFavoriteAirline(mockAirline)

        // THEN
        XCTAssertFalse(result)
    }

    // MARK: - Tests - deleteFavoriteAirline

    func testDeleteFavoriteAirlineCallsRepository() throws {
        // GIVEN
        mockRepository.deleteFavoriteAirlineResult = true

        // WHEN
        let result = try service.deleteFavoriteAirline(mockAirline)

        // THEN
        XCTAssertTrue(mockRepository.deleteFavoriteAirlineCalled)
        XCTAssertEqual(mockRepository.deletedAirline?.id, mockAirline.id)
        XCTAssertTrue(result)
    }

    func testDeleteFavoriteAirlineReturnsRepositoryResult() throws {
        // GIVEN
        mockRepository.deleteFavoriteAirlineResult = false

        // WHEN
        let result = try service.deleteFavoriteAirline(mockAirline)

        // THEN
        XCTAssertFalse(result)
    }

    // MARK: - Tests - fetchFavoriteAirlines

    func testFetchFavoriteAirlinesCallsRepository() throws {
        // WHEN
        let _ = try service.fetchFavoriteAirlines()

        // THEN
        XCTAssertTrue(mockRepository.fetchFavoriteAirlinesCalled)
    }

    func testFetchFavoriteAirlinesReturnsRepositoryResult() throws {
        // GIVEN
        let expectedAirlines = AirlineModel.mock().data
        mockRepository.fetchFavoriteAirlinesResult = expectedAirlines

        // WHEN
        let fetchedAirlines = try service.fetchFavoriteAirlines()

        // THEN
        XCTAssertEqual(fetchedAirlines, expectedAirlines)
    }

    func testFetchFavoriteAirlinesReturnsEmptyArrayWhenRepositoryReturnsNil() throws {
        // GIVEN
        mockRepository.fetchFavoriteAirlinesResult = nil

        // WHEN
        let fetchedAirlines = try service.fetchFavoriteAirlines()

        // THEN
        XCTAssertTrue(fetchedAirlines.isEmpty)
    }

    // MARK: - Tests - isAirlineFavorite

    func testIsAirlineFavoriteCallsRepository() {
        // WHEN
        _ = service.isAirlineFavorite(mockAirline)

        // THEN
        XCTAssertTrue(mockRepository.isAirlineFavoriteCalled)
        XCTAssertEqual(mockRepository.checkedAirlineId, mockAirline.id)
    }

    func testIsAirlineFavoriteReturnsRepositoryResult() {
        // GIVEN
        mockRepository.isAirlineFavoriteResult = true

        // WHEN
        let isFavorite = service.isAirlineFavorite(mockAirline)

        // THEN
        XCTAssertTrue(isFavorite)

        // GIVEN
        mockRepository.isAirlineFavoriteResult = false

        // WHEN
        let isNotFavorite = service.isAirlineFavorite(mockAirline)

        // THEN
        XCTAssertFalse(isNotFavorite)
    }
}
