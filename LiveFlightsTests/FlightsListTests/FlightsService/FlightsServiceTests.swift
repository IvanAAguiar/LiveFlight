//
//  FlightsServiceTests.swift
//  LiveFlightsTests
//
//  Created by Ivan Aguiar on 12/05/2025.
//

import XCTest
@testable import LiveFlights
import Combine

// MARK: - Mock API Client

final class FlightsServiceTests: XCTestCase {

    // MARK: - Inner Types

    typealias MockRepositoryProtocols = AirlinesRepositoryRepresentable & MockAirlinesRepositoryRepresentable

    // MARK: - Properties

    private var service: FlightsService!
    private var mockRepository: MockFlightsRepository!
    private var mockAPIClient: MockFlightsProtocols!
    private let mockFlightsResponse: FlightModel = FlightModel.mock()
    private let mockFlights: [Flight] = FlightModel.mock().data

    // MARK: - Setup

    override func setUp() {
        super.setUp()

        mockRepository = MockFlightsRepository()
        mockAPIClient = MockAviationStackAPIClient()
        service = FlightsService(
            dependencies: .init(
                repository: mockRepository,
                apiClient: mockAPIClient
            )
        )
    }

    // MARK: - TearDown

    override func tearDown() {
        service = nil
        mockRepository = nil
        mockAPIClient = nil

        super.tearDown()
    }

    // MARK: - Tests - fetchFlights

    func testFetchFlightsReturnsCachedDataWhenAvailableAndNotEmpty() async throws {
        // GIVEN
        mockRepository.fetchCachedFlightsResult = .success(mockFlights)

        // WHEN
        let fetchedFlights = try await service.fetchFlights()

        // THEN
        XCTAssertTrue(mockRepository.fetchCachedFlightsCalled)
        XCTAssertFalse(mockAPIClient.fetchFlightsCalled)
        XCTAssertEqual(fetchedFlights, mockFlights)
        XCTAssertFalse(mockRepository.saveFlightsCalled)
    }

    func testFetchFlightsFetchesFromAPIWhenCacheIsEmpty() async throws {
        // GIVEN
        mockRepository.fetchCachedFlightsResult = .success([])
        mockAPIClient.fetchFlightsResult = .success(mockFlightsResponse)

        // WHEN
        let fetchedFlights = try await service.fetchFlights()

        // THEN
        XCTAssertTrue(mockRepository.fetchCachedFlightsCalled)
        XCTAssertTrue(mockRepository.fetchCachedFlightsCalled)
        XCTAssertEqual(fetchedFlights, mockFlightsResponse.data)
        XCTAssertTrue(mockRepository.saveFlightsCalled)
        XCTAssertEqual(mockRepository.savedFlights, mockFlightsResponse.data)
    }

    func testFetchFlightsFetchesFromAPIWhenCacheIsNil() async throws {
        // GIVEN
        mockRepository.fetchCachedFlightsResult = .success(nil)
        mockAPIClient.fetchFlightsResult = .success(mockFlightsResponse)

        // WHEN
        let fetchedFlights = try await service.fetchFlights(iataCode: "CC", date: nil, status: "delayed")

        // THEN
        XCTAssertTrue(mockRepository.fetchCachedFlightsCalled)
        XCTAssertEqual(fetchedFlights, mockFlightsResponse.data)
        XCTAssertTrue(mockRepository.saveFlightsCalled)
        XCTAssertEqual(mockRepository.savedFlights, mockFlightsResponse.data)
    }

    func testFetchFlightsThrowsErrorFromAPIService() async throws {
        // GIVEN
        let testError = NSError(domain: "APIServiceError", code: 400, userInfo: [NSLocalizedDescriptionKey: "Failed to fetch from API"])
        mockRepository.fetchCachedFlightsResult = .success([])
        mockAPIClient.fetchFlightsResult = .failure(testError)

        // WHEN
        do {
            _ = try await service.fetchFlights()
            XCTFail("Expected fetchFlights to throw an error")
        } catch {
            // THEN
            XCTAssertTrue(mockRepository.fetchCachedFlightsCalled)
            XCTAssertNil(mockAPIClient.fetchedStatus)
            XCTAssertEqual(error as NSError, testError)
            XCTAssertFalse(mockRepository.saveFlightsCalled)
        }
    }

    func testFetchFlightsThrowsErrorFromCache() async throws {
        // GIVEN
        let testError = NSError(domain: "CoreDataError", code: 500, userInfo: [NSLocalizedDescriptionKey: "Failed to fetch from cache"])
        mockRepository.fetchCachedFlightsResult = .failure(testError)

        // WHEN
        do {
            _ = try await service.fetchFlights(iataCode: "EE", date: nil, status: "cancelled")
            XCTFail("Expected fetchFlights to throw an error")
        } catch {
            // THEN
            XCTAssertTrue(mockRepository.fetchCachedFlightsCalled)
            XCTAssertFalse(mockAPIClient.fetchFlightsCalled)
            XCTAssertEqual(error as NSError, testError)
            XCTAssertFalse(mockRepository.saveFlightsCalled)
        }
    }
}
