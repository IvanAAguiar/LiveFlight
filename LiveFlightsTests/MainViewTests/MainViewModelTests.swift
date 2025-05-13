//
//  MainViewModelTests.swift
//  LiveFlightsTests
//
//  Created by Ivan Aguiar on 09/05/2025.
//

import XCTest
import Combine
@testable import LiveFlights

final class MainViewModelTests: XCTestCase {

    // MARK: - Properties

    var viewModel: MainViewModel!
    private var cancellables: Set<AnyCancellable>!

    // MARK: - Setup

    override func setUp() {
        super.setUp()
        viewModel = MainViewModel()
        cancellables = []
    }

    // MARK: - TearDown

    override func tearDown() {
        viewModel = nil
        cancellables = nil
        super.tearDown()
    }

    func testInitialSelectedTabIsAirlines() {
        // THEN
        XCTAssertEqual(viewModel.selectedTab, .airlines)
    }

    func testAirplaneInitialValuesAreCorrect() {
        // THEN
        XCTAssertEqual(viewModel.airplaneTitle, "Airlines")
        XCTAssertEqual(viewModel.favoriteTitle, "Favorites")
        XCTAssertEqual(viewModel.mapTitle, "Airlines")
        XCTAssertEqual(viewModel.airplaneIcon, "airplane")
        XCTAssertEqual(viewModel.favoriteIcon, "heart.fill")
        XCTAssertEqual(viewModel.mapIcon, "map.fill")
    }

    func testSelectedTabUpdatesPublishedValue() {
        // GIVEN
        let expectation = XCTestExpectation(description: "selectedTab should update")
        var updatedTab: AppTab?

        viewModel.$selectedTab
            .dropFirst() // Ignore initial value
            .sink { tab in
                updatedTab = tab
                expectation.fulfill()
            }
            .store(in: &cancellables)

        // WHEN
        viewModel.selectedTab = .favorites

        // THEN
        wait(for: [expectation], timeout: 0.1)
        XCTAssertEqual(updatedTab, .favorites)

        // Repeat for another tab to ensure it works correctly
        let secondExpectation = XCTestExpectation(description: "selectedTab should update again")
        var secondUpdatedTab: AppTab?

        viewModel.$selectedTab
            .dropFirst() // Ignore current value (.favorites)
            .sink { tab in
                secondUpdatedTab = tab
                secondExpectation.fulfill()
            }
            .store(in: &cancellables)

        viewModel.selectedTab = .map
        wait(for: [secondExpectation], timeout: 0.1)
        XCTAssertEqual(secondUpdatedTab, .map)
    }
}
