//
//  FlightListViewModelTests.swift
//  LiveFlightsTests
//
//  Created by Ivan Aguiar on 11/05/2025.
//

import XCTest
@testable import LiveFlights
import Combine

final class FlightListViewModelTests: XCTestCase {

    // MARK: - Inner Types

    typealias MockFlightsServiceProtocols = MockFlightsService & FlightsServiceRepresentable

    // MARK: - Properties

    private var viewModel: FlightListViewModel!
    private var mockService: MockFlightsServiceProtocols!
    private let mockAirline = AirlineModel.mock().data.first!
    private let mockFlights: [Flight] = FlightModel.mock().data
    private var cancellables: Set<AnyCancellable>!

    // MARK: - Setup

    override func setUp() {
        super.setUp()

        mockService = MockFlightsService()
        viewModel = FlightListViewModel(
            dependencies: .init(
                service: mockService,
                airline: mockAirline
            )
        )
        cancellables = []
    }

    // MARK: - TearDown

    override func tearDown() {
        viewModel = nil
        mockService = nil
        cancellables = nil

        super.tearDown()
    }

    // MARK: - Tests - fetchFlights

    func testFetchFlightsSuccess() async {
        // GIVEN
        mockService.fetchFlightsResult = .success(mockFlights)

        let stateExpectation = XCTestExpectation(description: "State should be success")
        let flightsExpectation = XCTestExpectation(description: "Flights should be loaded")

        var receivedFlights: [Flight] = []
        var receivedState: FlightListViewModel.State?

        viewModel.$flights
            .dropFirst()
            .sink { flights in
                receivedFlights = flights
                flightsExpectation.fulfill()
            }
            .store(in: &cancellables)

        viewModel.$state
            .dropFirst()
            .sink { state in
                receivedState = state
                stateExpectation.fulfill()
            }
            .store(in: &cancellables)

        // WHEN
        await viewModel.fetchFlights()

        // THEN
        await fulfillment(of: [stateExpectation, flightsExpectation], timeout: 0.1)
        XCTAssertEqual(receivedState, .success)
        XCTAssertEqual(receivedFlights, mockFlights)
        XCTAssertTrue(mockService.fetchFlightsCalled)
        XCTAssertEqual(mockService.fetchedIataCode, mockAirline.iataCode)
    }

    func testFetchFlightsFailure() async {
        // GIVEN
        let testError = NSError(domain: "TestError", code: 123, userInfo: [NSLocalizedDescriptionKey: "Failed to fetch flights"])
        mockService.fetchFlightsResult = .failure(testError)

        let stateExpectation = XCTestExpectation(description: "State should be error")
        let errorMessageExpectation = XCTestExpectation(description: "Error message should be set")

        var receivedState: FlightListViewModel.State?
        var receivedErrorMessage: String?

        viewModel.$state
            .dropFirst()
            .sink { state in
                receivedState = state
                stateExpectation.fulfill()
            }
            .store(in: &cancellables)

        viewModel.$errorMessage
            .dropFirst()
            .sink { errorMessage in
                receivedErrorMessage = errorMessage
                errorMessageExpectation.fulfill()
            }
            .store(in: &cancellables)

        // WHEN
        await viewModel.fetchFlights()

        // THEN
        await fulfillment(of: [stateExpectation, errorMessageExpectation], timeout: 0.1)
        XCTAssertEqual(receivedState, .error)
        XCTAssertEqual(receivedErrorMessage, "Error: \(testError)")
        XCTAssertTrue(mockService.fetchFlightsCalled)
        XCTAssertEqual(mockService.fetchedIataCode, mockAirline.iataCode)
        XCTAssertTrue(viewModel.flights.isEmpty) // Ensure flights array remains empty on error
    }

    func testInitialStateIsLoading() {
        // THEN
        XCTAssertEqual(viewModel.state, .loading)
    }

    func testInitialErrorMessageIsNil() {
        // THEN
        XCTAssertNil(viewModel.errorMessage)
    }

    func testInitialFlightsArrayIsEmpty() {
        // THEN
        XCTAssertTrue(viewModel.flights.isEmpty)
    }
}
