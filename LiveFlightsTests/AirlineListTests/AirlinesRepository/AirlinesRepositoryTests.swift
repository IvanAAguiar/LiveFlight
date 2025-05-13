//
//  AirlinesRepositoryTests.swift
//  LiveFlightsTests
//
//  Created by Ivan Aguiar on 09/05/2025.
//

import CoreData
import XCTest
@testable import LiveFlights

final class AirlinesRepositoryTests: XCTestCase {

    // MARK: - Properties

    private var repository: AirlinesRepository!
    private let coreDataManager = CoreDataManager.shared
    
    private let mockAirlines = AirlineModel.mock().data

    // MARK: - Setup

    override func setUp() {
        super.setUp()

        repository = AirlinesRepository()
        clearAllCachedData() // Ensure a clean state before each test
    }

    // MARK: - TearDown

    override func tearDown() {
        clearAllCachedData() // Clean up after each test
        repository = nil

        super.tearDown()
    }

    // MARK: - Tests - fetchCachedAirlines

    func testFetchCachedAirlinesReturnsEmptyWhenNoDataCached() throws {
        // WHEN
        let cachedAirlines = try repository.fetchCachedAirlines() ?? []

        // THEN
        XCTAssertTrue(cachedAirlines.isEmpty)
    }

    func testFetchCachedAirlinesReturnsCachedAirlinesWhenDataExists() throws {
        // GIVEN
        try repository.saveAirlines(mockAirlines)

        // WHEN
        let cachedAirlines = try repository.fetchCachedAirlines()

        // THEN
        XCTAssertNotNil(cachedAirlines)
        XCTAssertEqual(cachedAirlines?.count, mockAirlines.count)
        XCTAssertNotNil(mockAirlines.first(where: { $0.id == cachedAirlines?.first?.id }))
        XCTAssertNotNil(mockAirlines.first(where: { $0.airlineId == cachedAirlines?.first?.airlineId }))
        XCTAssertNotNil(mockAirlines.first(where: { $0.iataCode == cachedAirlines?.first?.iataCode }))
        XCTAssertNotNil(mockAirlines.first(where: { $0.airlineName == cachedAirlines?.first?.airlineName }))
        XCTAssertNotNil(mockAirlines.first(where: { $0.countryName == cachedAirlines?.first?.countryName }))
    }

    // MARK: - Tests - saveAirlines

    func testSaveAirlinesSavesAirlinesToCache() throws {
        // WHEN
        try repository.saveAirlines(mockAirlines)

        // THEN
        let fetchRequest: NSFetchRequest<AirlineEntity> = AirlineEntity.fetchRequest()
        let savedEntities = try coreDataManager.viewContext.fetch(fetchRequest)
        XCTAssertEqual(savedEntities.count, mockAirlines.count)
        XCTAssertNotNil(mockAirlines.first(where: { $0.id == savedEntities.first?.id }))
        XCTAssertNotNil(mockAirlines.first(where: { $0.airlineId == savedEntities.first?.airlineId }))
        XCTAssertNotNil(mockAirlines.first(where: { $0.iataCode == savedEntities.first?.iataCode }))
        XCTAssertNotNil(mockAirlines.first(where: { $0.airlineName == savedEntities.first?.airlineName }))
        XCTAssertNotNil(mockAirlines.first(where: { $0.countryName == savedEntities.first?.countryName }))
        XCTAssertFalse(savedEntities.first?.isFavorite ?? true) // Default should be false
    }

    // MARK: - Tests - updateAirlineIsFavorite

    func testUpdateAirlineIsFavoriteUpdatesExistingAirline() throws {
        // GIVEN
        try repository.saveAirlines(mockAirlines)
        let airlineIdToUpdate = mockAirlines.first!.id!
        let newIsFavoriteStatus = true

        // WHEN
        try repository.updateAirlineIsFavorite(airlineId: airlineIdToUpdate, isFavorite: newIsFavoriteStatus)

        // THEN
        let fetchRequest: NSFetchRequest<AirlineEntity> = AirlineEntity.fetchRequest()
        fetchRequest.predicate = NSPredicate(format: "id == %@", airlineIdToUpdate)
        let updatedEntities = try coreDataManager.viewContext.fetch(fetchRequest)
        XCTAssertEqual(updatedEntities.first?.isFavorite, newIsFavoriteStatus)
    }

    func testUpdateAirlineIsFavoriteDoesNotThrowErrorIfAirlineNotFound() throws {
        // WHEN
        try repository.updateAirlineIsFavorite(airlineId: "nonExistentId", isFavorite: true)

        // THEN
        // Test passes if no error is thrown. A warning is printed, which is acceptable for a unit test.
    }

    // MARK: - Tests - clearAllCachedAirlines

    func testClearAllCachedAirlinesRemovesAllCachedData() throws {
        // GIVEN
        try repository.saveAirlines(mockAirlines)

        // WHEN
        try repository.clearAllCachedAirlines()

        // THEN
        let fetchRequest: NSFetchRequest<AirlineEntity> = AirlineEntity.fetchRequest()
        let remainingEntities = try coreDataManager.viewContext.fetch(fetchRequest)
        XCTAssertTrue(remainingEntities.isEmpty)
    }
}

// MARK: - Helper Methods

extension AirlinesRepositoryTests {
    private func clearAllCachedData() {
        let fetchRequest: NSFetchRequest<NSFetchRequestResult> = AirlineEntity.fetchRequest()
        let batchDeleteRequest = NSBatchDeleteRequest(fetchRequest: fetchRequest)
        do {
            try coreDataManager.viewContext.execute(batchDeleteRequest)
            try coreDataManager.saveContext()
        } catch {
            fatalError("Failed to clear cached data: \(error)")
        }
    }
}
