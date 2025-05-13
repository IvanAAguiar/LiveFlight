//
//  FlightsRepositoryTests.swift
//  LiveFlightsTests
//
//  Created by Ivan Aguiar on 11/05/2025.
//

import CoreData
import XCTest
@testable import LiveFlights

final class FlightsRepositoryTests: XCTestCase {

    // MARK: - Inner Types

    typealias MockAirlinesServiceProtocols = MockAirlinesServiceRepresentable & AirlinesServiceRepresentable

    // MARK: - Properties

    private var repository: FlightsRepository!
    private var mockAirlineService: MockAirlinesServiceProtocols!
    private let coreDataManager = CoreDataManager.shared
    private let mockFlights: [Flight] = FlightModel.mock().data

    // MARK: - Setup

    override func setUp() {
        super.setUp()

        mockAirlineService = MockAirlinesService()
        repository = FlightsRepository(
            dependencies: .init(
                airlineService: mockAirlineService,
                coreDataManager: coreDataManager
            )
        )

        clearAllCachedData()
    }

    // MARK: - TearDown

    override func tearDown() {
        clearAllCachedData()

        mockAirlineService = nil
        repository = nil

        super.tearDown()
    }

    // MARK: - Tests - fetchCachedFlights

        func testFetchCachedFlightsReturnsEmptyWhenNoDataCached() throws {
            // WHEN
            let cachedFlights = try repository.fetchCachedFlights()

            // THEN
            XCTAssertTrue(((cachedFlights?.isEmpty) != nil))
        }

        func testFetchCachedFlightsReturnsCachedFlightsWhenDataExists() throws {
            // GIVEN
            try saveMockFlightsToCache()

            // WHEN
            let cachedFlights = try repository.fetchCachedFlights()

            // THEN
            XCTAssertNotNil(cachedFlights)
        }

        // MARK: - Tests - saveFlights

        func testSaveFlightsSavesFlightsToCache() throws {
            // WHEN
            do {
                try repository.saveFlights(mockFlights)
            }
            // THEN
            let fetchRequest: NSFetchRequest<FlightEntity> = FlightEntity.fetchRequest()
            let savedEntities = try coreDataManager.viewContext.fetch(fetchRequest)
    
            XCTAssertNotNil(savedEntities)
        }
}

// MARK: - Helper Methods

extension FlightsRepositoryTests {
    private func clearAllCachedData() {
        let entities = [
            "FlightEntity",
            "DepartureEntity",
            "ArrivalEntity",
            "AirlineEntity",
            "FlightDetailsEntity",
            "CodesharedEntity"
        ]

        for entityName in entities {
            let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: entityName)
            let batchDeleteRequest = NSBatchDeleteRequest(fetchRequest: fetchRequest)

            do {
                try coreDataManager.viewContext.execute(batchDeleteRequest)
                try coreDataManager.saveContext()
            } catch {
                fatalError("Failed to clear cached data for \(entityName): \(error)")
            }
        }
    }

    private func saveMockFlightsToCache() throws {
        for flight in mockFlights {
            let cachedFlight = FlightEntity(context: coreDataManager.viewContext)
            cachedFlight.flightDate = flight.flightDate
            cachedFlight.flightStatus = flight.flightStatus

            let cachedDeparture = DepartureEntity(context: coreDataManager.viewContext)
            cachedDeparture.airport = flight.departure.airport
            cachedDeparture.timezone = flight.departure.timezone
            cachedDeparture.iata = flight.departure.iata
            cachedDeparture.icao = flight.departure.icao
            cachedDeparture.scheduled = flight.departure.scheduled
            cachedDeparture.estimated = flight.departure.estimated
            cachedFlight.departure = cachedDeparture

            let cachedArrival = ArrivalEntity(context: coreDataManager.viewContext)
            cachedArrival.airport = flight.arrival.airport
            cachedArrival.timezone = flight.arrival.timezone
            cachedArrival.iata = flight.arrival.iata
            cachedArrival.icao = flight.arrival.icao
            cachedArrival.scheduled = flight.arrival.scheduled
            cachedFlight.arrival = cachedArrival

            let cachedAirline = AirlineEntity(context: coreDataManager.viewContext)
            cachedAirline.airlineName = flight.airline.name
            cachedAirline.iataCode = flight.airline.iata
            cachedAirline.iataIcao = flight.airline.icao
            cachedFlight.airline = cachedAirline

            let cachedFlightDetails = FlightDetailsEntity(context: coreDataManager.viewContext)
            cachedFlightDetails.number = flight.flight.number
            cachedFlightDetails.iata = flight.flight.iata
            cachedFlightDetails.icao = flight.flight.icao
            cachedFlight.flight = cachedFlightDetails

            cachedFlight.isFavorite = flight.isFavorite ?? false
        }

        try coreDataManager.saveContext()
    }
}
