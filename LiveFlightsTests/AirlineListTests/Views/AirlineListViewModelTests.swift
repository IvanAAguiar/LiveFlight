//
//  AirlineListViewModelTests.swift
//  LiveFlightsTests
//
//  Created by Ivan Aguiar on 05/05/2025.
//

import XCTest
@testable import LiveFlights

final class AirlineListViewModelTests: XCTestCase {

    // MARK: - Inner Types

    typealias MockAirlinesServiceProtocols = MockAirlinesServiceRepresentable & AirlinesServiceRepresentable

    // MARK: - Properties

    private var mockAirlineService: MockAirlinesServiceProtocols!
    private var mockFavoritesService: FavoritesServiceRepresentable!
    private var viewModel: AirlineListViewModel!

    private let genericError = NSError(domain: "TestError", code: 123, userInfo: [NSLocalizedDescriptionKey: "Generic Test Error"])

    // MARK: - Setup

    override func setUp() {
        super.setUp()

        setupViewModel(fetchResult: .success(AirlineModel.mock().data))
    }

    // MARK: - TearDown

    override func tearDown() {
        viewModel = nil
        mockFavoritesService = nil
        mockAirlineService = nil

        super.tearDown()
    }

    // MARK: - Tests

    func testScreenTitleIsCorrect() {
        // THEN
        XCTAssertEqual(viewModel.screenTitle, "Live Flights App")
    }

    func testLoadingMessageIsCorrect() {
        // THEN
        XCTAssertEqual(viewModel.loadingMessage, "Loading Airlines...")
    }

    func testFilterPlaceholderIsCorrect() {
        // THEN
        XCTAssertEqual(viewModel.filterPlaceholder, "Search by name or IATA code")
    }

    func testOnAppearFetchesAirlinesAndSetsSuccessState() async {
        // WHEN
        await viewModel.onAppear()

        let mockAirlines = AirlineModel.mock().data

        // THEN
        XCTAssertEqual(viewModel.state, .success)
        XCTAssertEqual(viewModel.airlines, mockAirlines)
        XCTAssertEqual(viewModel.airlinesToShown, mockAirlines)
    }

    func testOnAppearFetchesAirlinesAndSetsEmptyState() async {
        // GIVEN
        setupViewModel(fetchResult: .success([]))

        // WHEN
        await viewModel.onAppear()

        let genericError = GenericErrorViewModel(errorTitle: "No Airlines Available", errorMessage: "The list of airlines is currently empty.")

        // THEN
        if case .empty(let errorViewModel) = viewModel.state {
            XCTAssertEqual(errorViewModel.errorTitle, "No Airlines Available")
            XCTAssertEqual(
                errorViewModel.errorMessage,
                "The list of airlines is currently empty."
            )
        } else {
            XCTFail("State should be .empty")
        }
        XCTAssertTrue(viewModel.airlines.isEmpty)
        XCTAssertTrue(viewModel.airlinesToShown.isEmpty)
    }

    func testOnAppearFetchesAirlinesAndSetsFailureState() async {
        // GIVEN
        setupViewModel(fetchResult: .failure(genericError))

        // WHEN
        await viewModel.onAppear()

        // THEN
        if case .failure(let errorViewModel) = viewModel.state {
            XCTAssertEqual(errorViewModel.errorTitle, "Data Loading Error")
            XCTAssertEqual(errorViewModel.errorMessage, genericError.localizedDescription)
        } else {
            XCTFail("State should be .failure")
        }
        XCTAssertTrue(viewModel.airlines.isEmpty)
        XCTAssertTrue(viewModel.airlinesToShown.isEmpty)
    }

    func testFilterAirlinesWithEmptySearchTextShowsAllAirlines() async {
        // GIVEN
        setupViewModel(fetchResult: .success(AirlineModel.mock().data))

        // WHEN
        await viewModel.onAppear()
        viewModel.searchText = ""
        await viewModel.filterAirlines(searchText: viewModel.searchText)

        let mockAirlines = AirlineModel.mock().data

        // THEN
        XCTAssertEqual(viewModel.airlinesToShown, mockAirlines)
    }

    func testFilterAirlinesByName() async {
        // GIVEN
        setupViewModel(fetchResult: .success(AirlineModel.mock().data))

        // WHEN
        await viewModel.onAppear()
        viewModel.searchText = "Gol Linhas"
        await viewModel.filterAirlines(searchText: viewModel.searchText)

        let mockAirline =  Airline(
            id: "4650068",
            airlineId: "38",
            iataCode: "G3",
            iataIcao: nil,
            airlineName: "Gol Linhas Aéreas Inteligentes",
            countryName: "Brazil",
            status: "active",
            isFavorite: true
        )

        // THEN
        XCTAssertEqual(viewModel.airlinesToShown.count, 1)
        XCTAssertEqual(viewModel.airlinesToShown.first?.airlineId, mockAirline.airlineId)
        XCTAssertEqual(viewModel.airlinesToShown.first?.airlineName, mockAirline.airlineName)
        XCTAssertEqual(viewModel.airlinesToShown.first?.iataCode, mockAirline.iataCode)
    }

    func testFilterAirlinesByPartialName() async {
        // GIVEN
        setupViewModel(fetchResult: .success(AirlineModel.mock().data))

        // WHEN
        await viewModel.onAppear()
        viewModel.searchText = "Inteligentes"
        await viewModel.filterAirlines(searchText: viewModel.searchText)

        let mockAirline =  Airline(
            id: "4650068",
            airlineId: "38",
            iataCode: "G3",
            iataIcao: nil,
            airlineName: "Gol Linhas Aéreas Inteligentes",
            countryName: "Brazil",
            status: "active",
            isFavorite: true
        )

        // THEN
        XCTAssertEqual(viewModel.airlinesToShown.count, 1)
        XCTAssertEqual(viewModel.airlinesToShown.first?.airlineId, mockAirline.airlineId)
        XCTAssertEqual(viewModel.airlinesToShown.first?.airlineName, mockAirline.airlineName)
        XCTAssertEqual(viewModel.airlinesToShown.first?.iataCode, mockAirline.iataCode)
    }

    func testFilterAirlinesByIATACode() async {
        // GIVEN
        setupViewModel(fetchResult: .success(AirlineModel.mock().data))

        // WHEN
        await viewModel.onAppear()
        viewModel.searchText = "G3"
        await viewModel.filterAirlines(searchText: viewModel.searchText)

        let mockAirline =  Airline(
            id: "4650068",
            airlineId: "38",
            iataCode: "G3",
            iataIcao: nil,
            airlineName: "Gol Linhas Aéreas Inteligentes",
            countryName: "Brazil",
            status: "active",
            isFavorite: true
        )

        // THEN
        XCTAssertEqual(viewModel.airlinesToShown.count, 1)
        XCTAssertEqual(viewModel.airlinesToShown.first?.airlineId, mockAirline.airlineId)
        XCTAssertEqual(viewModel.airlinesToShown.first?.airlineName, mockAirline.airlineName)
        XCTAssertEqual(viewModel.airlinesToShown.first?.iataCode, mockAirline.iataCode)
    }

    func testFilterAirlinesByCaseInsensitiveSearch() async {
        // GIVEN
        setupViewModel(fetchResult: .success(AirlineModel.mock().data))

        // WHEN
        await viewModel.onAppear()
        viewModel.searchText = "g3"
        await viewModel.filterAirlines(searchText: viewModel.searchText)

        let mockAirline =  Airline(
            id: "4650068",
            airlineId: "38",
            iataCode: "G3",
            iataIcao: nil,
            airlineName: "Gol Linhas Aéreas Inteligentes",
            countryName: "Brazil",
            status: "active",
            isFavorite: true
        )

        // THEN
        XCTAssertEqual(viewModel.airlinesToShown.count, 1)
        XCTAssertEqual(viewModel.airlinesToShown.first?.airlineId, mockAirline.airlineId)
        XCTAssertEqual(viewModel.airlinesToShown.first?.airlineName, mockAirline.airlineName)
        XCTAssertEqual(viewModel.airlinesToShown.first?.iataCode, mockAirline.iataCode)
    }

    func testFilterAirlinesNoResults() async {
        // GIVEN
        setupViewModel(fetchResult: .success(AirlineModel.mock().data))

        // WHEN
        await viewModel.onAppear()
        viewModel.searchText = "laksd"
        await viewModel.filterAirlines(searchText: viewModel.searchText)

        // THEN
        XCTAssertTrue(viewModel.airlinesToShown.isEmpty)
    }

    func testSaveAirline() {
        // GIVEN
        let mockAirlines = AirlineModel.mock().data
        setupViewModel(fetchResult: .success(mockAirlines))

        // WHEN
        let isSaved = viewModel.saveAirline(mockAirlines[0])

        // THEN
        XCTAssertTrue(isSaved)
    }

    func testDeleteAirlineCallsFavoritesServiceAndUpdatesService() {
        // GIVEN
        let mockAirlines = AirlineModel.mock().data
        setupViewModel(fetchResult: .success(mockAirlines))

        // WHEN
        let isDeleted = viewModel.deleteAirline(mockAirlines[0])

        // THEN
        XCTAssertTrue(isDeleted)
    }
}

// MARK: - Helper Methods

extension AirlineListViewModelTests {
    private func setupViewModel(
        fetchResult: Result<[Airline], Error>,
        isAirlineSaved: Bool = false,
        isAirlineDeleted: Bool = false
    ) {
        mockAirlineService = MockAirlinesService()
        mockAirlineService.fetchAirlinesResult = fetchResult
        mockAirlineService.isAirlineSaved = isAirlineSaved

        mockFavoritesService = MockFavoritesService()

        let dependencies = AirlineListViewModel.Dependencies(
            service: mockAirlineService,
            favoritesService: mockFavoritesService
        )

        viewModel = AirlineListViewModel(dependencies: dependencies)
    }
}
