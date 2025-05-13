//
//  FavoritesViewModelTests.swift
//  LiveFlightsTests
//
//  Created by Ivan Aguiar on 10/05/2025.
//

import XCTest
@testable import LiveFlights
import Combine

final class FavoritesViewModelTests: XCTestCase {

    // MARK: - Inner Types

    typealias MockFavoritesServiceProtocols = MockFavoritesServiceRepresentable & FavoritesServiceRepresentable

    // MARK: - Properties

    private var viewModel: FavoritesViewModel!
    private var mockService: MockFavoritesServiceProtocols!
    private let mockAirlines = AirlineModel.mock().data
    private var cancellables: Set<AnyCancellable>!

    // MARK: - Setup

    override func setUp() {
        super.setUp()

        mockService = MockFavoritesService()
        viewModel = FavoritesViewModel(
            dependencies: .init(
                service: mockService
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

    // MARK: - Tests - loadFavoriteAirlines

    func testLoadFavoriteAirlinesSuccess() {
        // GIVEN
        mockService.fetchFavoriteAirlinesResult = .success(mockAirlines)

        let expectation = XCTestExpectation(description: "Airlines should be loaded and state should be success")

        viewModel.$airlines
            .dropFirst() // Ignore initial value
            .sink { airlines in
                XCTAssertEqual(airlines, self.mockAirlines)
                expectation.fulfill()
            }
            .store(in: &cancellables)

        viewModel.$state
            .dropFirst()
            .sink { state in
                XCTAssertEqual(state, .success)
            }
            .store(in: &cancellables)

        // WHEN
        viewModel.loadFavoriteAirlines()

        // THEN
        wait(for: [expectation], timeout: 0.1)
        XCTAssertTrue(mockService.fetchFavoriteAirlinesCalled)
    }

    func testLoadFavoriteAirlinesEmpty() {
        // GIVEN
        mockService.fetchFavoriteAirlinesResult = .success([])

        let expectation = XCTestExpectation(description: "State should be empty")

        viewModel.$airlines
            .dropFirst()
            .sink { airlines in
                XCTAssertTrue(airlines.isEmpty)
            }
            .store(in: &cancellables)

        viewModel.$state
            .dropFirst()
            .sink { state in
                if case .empty(let errorViewModel) = state {
                    XCTAssertEqual(errorViewModel.systemImageName, "empty_image")
                    expectation.fulfill()
                } else {
                    XCTFail("State should be .empty")
                }
            }
            .store(in: &cancellables)

        // WHEN
        viewModel.loadFavoriteAirlines()

        // THEN
        wait(for: [expectation], timeout: 0.1)
        XCTAssertTrue(mockService.fetchFavoriteAirlinesCalled)
    }

    func testLoadFavoriteAirlinesFailure() {
        // GIVEN
        let testError = NSError(domain: "TestError", code: 123, userInfo: [NSLocalizedDescriptionKey: "Failed to fetch"])
        mockService.fetchFavoriteAirlinesResult = .failure(testError)

        let expectation = XCTestExpectation(description: "State should be failure")

        viewModel.$state
            .dropFirst()
            .sink { state in
                if case .failure(let errorViewModel) = state {
                    XCTAssertEqual(errorViewModel.errorMessage, testError.localizedDescription)
                    expectation.fulfill()
                } else {
                    XCTFail("State should be .failure")
                }
            }
            .store(in: &cancellables)

        // WHEN
        viewModel.loadFavoriteAirlines()

        // THEN
        wait(for: [expectation], timeout: 0.1)
        XCTAssertTrue(mockService.fetchFavoriteAirlinesCalled)
    }

    // MARK: - Tests - deleteFavorite

    func testDeleteFavoriteSuccess() {
        // GIVEN
        mockService.deleteFavoriteAirlineResult = .success(true)
        mockService.fetchFavoriteAirlinesResult = .success([]) // Simulate successful reload after delete

        let expectation = XCTestExpectation(description: "Airlines should be reloaded after deletion")

        viewModel.$airlines
            .dropFirst()
            .sink { airlines in
                XCTAssertTrue(airlines.isEmpty)
                expectation.fulfill()
            }
            .store(in: &cancellables)

        // WHEN
        viewModel.deleteFavorite(mockAirlines[0])

        // THEN
        wait(for: [expectation], timeout: 0.1)
        XCTAssertTrue(mockService.deleteFavoriteAirlineCalled)
        XCTAssertEqual(mockService.deletedAirline?.id, mockAirlines[0].id)
        XCTAssertTrue(mockService.fetchFavoriteAirlinesCalled)
    }

    func testDeleteFavoriteFailure() {
        // GIVEN
        let testError = NSError(domain: "TestError", code: 456, userInfo: [NSLocalizedDescriptionKey: "Failed to delete"])
        mockService.deleteFavoriteAirlineResult = .failure(testError)

        let expectation = XCTestExpectation(description: "State should be failure on delete")

        viewModel.$state
            .dropFirst()
            .sink { state in
                if case .failure(let errorViewModel) = state {
                    XCTAssertEqual(errorViewModel.errorMessage, testError.localizedDescription)
                    expectation.fulfill()
                } else {
                    XCTFail("State should be .failure")
                }
            }
            .store(in: &cancellables)

        // WHEN
        viewModel.deleteFavorite(mockAirlines[0])

        // THEN
        wait(for: [expectation], timeout: 0.1)
        XCTAssertTrue(mockService.deleteFavoriteAirlineCalled)
        XCTAssertEqual(mockService.deletedAirline?.id, mockAirlines[0].id)
        XCTAssertFalse(mockService.fetchFavoriteAirlinesCalled) // Should not try to reload on delete failure
    }
}
