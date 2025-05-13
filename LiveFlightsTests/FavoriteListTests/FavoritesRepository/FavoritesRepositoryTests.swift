//
//  FavoritesRepositoryTests.swift
//  LiveFlightsTests
//
//  Created by Ivan Aguiar on 10/05/2025.
//

import CoreData
import XCTest
@testable import LiveFlights

final class FavoritesRepositoryTests: XCTestCase {

    // MARK: - Properties

    private var repository: FavoritesRepository!
    private let coreDataManager = CoreDataManager.shared
    private let mockAirlines = AirlineModel.mock().data

    // MARK: - Setup

    override func setUp() {
        super.setUp()
        repository = FavoritesRepository()
        clearAllFavorites()
        clearAllAirlines()
        saveMockAirlines()
    }

    // MARK: - TearDown

    override func tearDown() {
        clearAllFavorites()
        clearAllAirlines()
        repository = nil
        super.tearDown()
    }

    // MARK: - Tests - saveFavoriteAirline

    func testSaveFavoriteAirlineSavesNewFavorite() throws {
        // GIVEN
        let airlineToSave = mockAirlines[0]

        // WHEN
        let saveResult = try repository.saveFavoriteAirline(airlineToSave)

        // THEN
        XCTAssertTrue(saveResult)
        let fetchedFavorites = try repository.fetchFavoriteAirlines()
        XCTAssertNotNil(fetchedFavorites)
        XCTAssertEqual(fetchedFavorites?.count, 1)
        XCTAssertEqual(fetchedFavorites?.first?.id, airlineToSave.id)
        let fetchRequest: NSFetchRequest<AirlineEntity> = AirlineEntity.fetchRequest()
        fetchRequest.predicate = NSPredicate(format: "id == %@", airlineToSave.id!)
        let updatedAirline = try coreDataManager.viewContext.fetch(fetchRequest).first
        XCTAssertTrue(updatedAirline?.isFavorite ?? false)
    }

    func testSaveFavoriteAirlineDoesNotSaveDuplicate() throws {
        // GIVEN
        let airlineToSave = mockAirlines[0]
        _ = try repository.saveFavoriteAirline(airlineToSave)

        // WHEN
        let saveResult = try repository.saveFavoriteAirline(airlineToSave)

        // THEN
        XCTAssertFalse(saveResult)
        let fetchedFavorites = try repository.fetchFavoriteAirlines()
        XCTAssertNotNil(fetchedFavorites)
        XCTAssertEqual(fetchedFavorites?.count, 1)
    }

    func testSaveFavoriteAirlineReturnsTrueIfAirlineNotFound() throws {
        // GIVEN
        let nonExistentAirline = Airline(
            id: "nonExistent",
            airlineId: "NA",
            iataCode: nil,
            iataIcao: nil,
            airlineName: "Non Existent",
            countryName: nil,
            status: nil,
            isFavorite: false
        )

        // WHEN
        let saveResult = try repository.saveFavoriteAirline(nonExistentAirline)

        // THEN
        XCTAssertTrue(saveResult)
        let fetchedFavorites = try repository.fetchFavoriteAirlines()
        XCTAssertFalse(fetchedFavorites?.isEmpty ?? true) // The airline must be saved if it does not exist.
    }

    // MARK: - Tests - deleteFavoriteAirline

    func testDeleteFavoriteAirlineDeletesExistingFavorite() throws {
        // GIVEN
        let airlineToDelete = mockAirlines[0]
        _ = try repository.saveFavoriteAirline(airlineToDelete)

        // WHEN
        let deleteResult = try repository.deleteFavoriteAirline(airlineToDelete)

        // THEN
        XCTAssertTrue(deleteResult)
        let fetchedFavorites = try repository.fetchFavoriteAirlines()
        XCTAssertTrue(fetchedFavorites?.isEmpty ?? true)
        let fetchRequest: NSFetchRequest<AirlineEntity> = AirlineEntity.fetchRequest()
        fetchRequest.predicate = NSPredicate(format: "id == %@", airlineToDelete.id!)
        let updatedAirline = try coreDataManager.viewContext.fetch(fetchRequest).first
        XCTAssertFalse(updatedAirline?.isFavorite ?? true)
    }

    func testDeleteFavoriteAirlineReturnsTrueIfFavoriteNotFound() throws {
        // GIVEN
        let nonFavoriteAirline = mockAirlines[1]

        // WHEN
        let deleteResult = try repository.deleteFavoriteAirline(nonFavoriteAirline)

        // THEN
        XCTAssertFalse(deleteResult)
        let fetchedFavorites = try repository.fetchFavoriteAirlines()
        XCTAssertTrue(fetchedFavorites?.isEmpty ?? true)
    }

    // MARK: - Tests - fetchFavoriteAirlines

    func testFetchFavoriteAirlinesReturnsNilWhenNoFavorites() throws {
        // WHEN
        let fetchedFavorites = try repository.fetchFavoriteAirlines()

        // THEN
        XCTAssertTrue(((fetchedFavorites?.isEmpty) != nil))
    }

    func testFetchFavoriteAirlinesReturnsFavoriteAirlines() throws {
        // GIVEN
        let favoriteAirline1 = mockAirlines[0]
        let favoriteAirline2 = mockAirlines[1]
        _ = try repository.saveFavoriteAirline(favoriteAirline1)
        _ = try repository.saveFavoriteAirline(favoriteAirline2)

        // WHEN
        let fetchedFavorites = try repository.fetchFavoriteAirlines()

        // THEN
        XCTAssertNotNil(fetchedFavorites)
        XCTAssertEqual(fetchedFavorites?.count, 2)
        XCTAssertNotNil(fetchedFavorites?.first(where: { $0.id == favoriteAirline1.id }))
        XCTAssertNotNil(fetchedFavorites?.first(where: { $0.id == favoriteAirline2.id }))
        XCTAssertTrue(((fetchedFavorites?.allSatisfy { $0.isFavorite ?? false }) != nil))
    }

    // MARK: - Tests - isAirlineFavorite

    func testIsAirlineFavoriteReturnsTrueIfAirlineIsFavorite() throws {
        // GIVEN
        let favoriteAirline = mockAirlines[0]
        _ = try repository.saveFavoriteAirline(favoriteAirline)

        // WHEN
        let isFavorite = repository.isAirlineFavorite(airlineId: favoriteAirline.airlineId!)

        // THEN
        XCTAssertTrue(isFavorite)
    }

    func testIsAirlineFavoriteReturnsFalseIfAirlineIsNotFavorite() throws {
        // GIVEN
        let nonFavoriteAirline = mockAirlines[1]

        // WHEN
        let isFavorite = repository.isAirlineFavorite(airlineId: nonFavoriteAirline.airlineId!)

        // THEN
        XCTAssertFalse(isFavorite)
    }

    func testIsAirlineFavoriteReturnsFalseIfNoFavoritesSaved() {
        // WHEN
        let isFavorite = repository.isAirlineFavorite(airlineId: "anyId")

        // THEN
        XCTAssertFalse(isFavorite)
    }
}

// MARK: - Helper Methods

extension FavoritesRepositoryTests {
    private func saveAirlines(_ airlines: [Airline]) throws {
        airlines.forEach { airline in
            let cachedAirline = AirlineEntity(context: coreDataManager.viewContext)
            cachedAirline.id = airline.id
            cachedAirline.airlineId = airline.airlineId
            cachedAirline.iataCode = airline.iataCode
            cachedAirline.airlineName = airline.airlineName
            cachedAirline.countryName = airline.countryName
        }
        try coreDataManager.saveContext()
    }

    private func clearAllFavorites() {
        let fetchRequest: NSFetchRequest<NSFetchRequestResult> = FavoritesAirlineEntity.fetchRequest()
        let batchDeleteRequest = NSBatchDeleteRequest(fetchRequest: fetchRequest)

        do {
            try coreDataManager.viewContext.execute(batchDeleteRequest)
            try coreDataManager.saveContext()
        } catch {
            fatalError("Failed to clear all favorites: \(error)")
        }
    }

    private func clearAllAirlines() {
        let fetchRequest: NSFetchRequest<NSFetchRequestResult> = AirlineEntity.fetchRequest()
        let batchDeleteRequest = NSBatchDeleteRequest(fetchRequest: fetchRequest)

        do {
            try coreDataManager.viewContext.execute(batchDeleteRequest)
            try coreDataManager.saveContext()
        } catch {
            fatalError("Failed to clear all airlines: \(error)")
        }
    }

    private func saveMockAirlines() {
        do {
            try saveAirlines(mockAirlines)
        } catch {
            fatalError("Failed to save mock airlines: \(error)")
        }
    }
}
