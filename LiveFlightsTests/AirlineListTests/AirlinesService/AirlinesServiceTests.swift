//
//  AirlinesServiceTests.swift
//  LiveFlightsTests
//
//  Created by Ivan Aguiar on 05/05/2025.
//

import XCTest
@testable import LiveFlights

final class AirlinesServiceTests: XCTestCase {

    // MARK: - Inner Types

    typealias MockRepositoryProtocols = AirlinesRepositoryRepresentable & MockAirlinesRepositoryRepresentable
    typealias MockAPIClientProtocols = MockAPIClientAirlinesFetchable & MockAPIClientAirlinesFetchable

    // MARK: - Properties

    private var mockRepository: MockRepositoryProtocols!
    private var mockAPIClient: MockAPIClientProtocols!
    private var service: AirlinesService!

    private let mockAirlineResponse = AirlineModel.mock()
    private let mockAirlines = AirlineModel.mock().data

    private let genericError = NSError(domain: "TestError", code: 123, userInfo: [NSLocalizedDescriptionKey: "Generic Test Error"])

    // MARK: - Setup

    override func setUp() {
        super.setUp()

        mockRepository = MockAirlinesRepository()
    }

    // MARK: - TearDown

    override func tearDown() {
        service = nil
        mockRepository = nil
        mockAPIClient = nil

        super.tearDown()
    }

    // MARK: - Tests - fetchAirlines

    func testFetchAirlinesFetchesFromCacheWhenAvailableAndNotEmpty() async throws {
        // GIVEN
        setupService(
            apiResult: .success(mockAirlineResponse),
            cachedAirlines: mockAirlines
        )

        // WHEN
        let fetchedAirlines = try await service.fetchAirlines()

        // THEN
        XCTAssertEqual(fetchedAirlines, mockAirlines)
        XCTAssertFalse(mockRepository.saveAirlinesCalled)
    }

    func testFetchAirlinesFetchesFromAPIWhenCacheEmpty() async throws {
        // GIVEN
        setupService(
            apiResult: .success(mockAirlineResponse),
            cachedAirlines: []
        )

        // WHEN
        let fetchedAirlines = try await service.fetchAirlines()

        // THEN
        XCTAssertEqual(fetchedAirlines, mockAirlines)
        XCTAssertTrue(mockRepository.saveAirlinesCalled)
        XCTAssertEqual(mockRepository.savedAirlines, mockAirlines)
    }

    func testFetchAirlinesFetchesFromAPIWhenCacheNil() async throws {
        // GIVEN
        setupService(apiResult: .success(mockAirlineResponse), cachedAirlines: nil)

        // WHEN
        let fetchedAirlines = try await service.fetchAirlines()

        // THEN
        XCTAssertEqual(fetchedAirlines, mockAirlines)
        XCTAssertTrue(mockRepository.saveAirlinesCalled)
        XCTAssertEqual(mockRepository.savedAirlines, mockAirlines)
    }

    func testFetchAirlinesFetchesFromAPIAndSavesToCache() async throws {
        // GIVEN
        setupService(
            apiResult: .success(mockAirlineResponse),
            cachedAirlines: nil
        )

        // WHEN
        _ = try await service.fetchAirlines()

        // THEN
        XCTAssertTrue(mockRepository.saveAirlinesCalled)
        XCTAssertEqual(mockRepository.savedAirlines, mockAirlines)
    }

    func testFetchAirlinesThrowsErrorWhenAPIFails() async {
        // GIVEN
        setupService(
            apiResult: .failure(genericError),
            cachedAirlines: nil
        )

        // WHEN
        do {
            _ = try await service.fetchAirlines()
            XCTFail("Fetch should have thrown an error")
        } catch {
            // THEN
            XCTAssertEqual(error as NSError, genericError)
            XCTAssertFalse(mockRepository.saveAirlinesCalled)
        }
    }

    // MARK: - Tests - updateAirlineIsFavorite

    func testUpdateAirlineIsFavoriteCallsRepositoryMethod() throws {
        // GIVEN
        setupService(apiResult: .success(mockAirlineResponse))
        let airlineId = "testId"
        let isFavorite = true

        // WHEN
        try service.updateAirlineIsFavorite(airlineId: airlineId, isFavorite: isFavorite)

        // THEN
        XCTAssertEqual(mockRepository.updatedAirlineId, airlineId)
        XCTAssertEqual(mockRepository.updatedIsFavorite, isFavorite)
    }
}

// MARK: - Helper Methods

extension AirlinesServiceTests {
    private func setupService(
        apiResult: Result<AirlineModel, Error>,
        cachedAirlines: [Airline]? = nil
    ) {
        mockRepository.cachedAirlines = cachedAirlines
        mockAPIClient = MockAviationStackAPIClient(fetchAirlinesResult: apiResult)

        service = AirlinesService(dependencies:
                .init(
                    repository: mockRepository,
                    apiClient: mockAPIClient as! APIClientAirlinesFetchable
                )
        )
    }
}
