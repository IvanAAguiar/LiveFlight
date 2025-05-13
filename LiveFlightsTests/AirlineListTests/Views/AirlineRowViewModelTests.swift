//
//  AirlineRowViewModelTests.swift
//  LiveFlightsTests
//
//  Created by Ivan Aguiar on 08/05/2025.
//

import XCTest
@testable import LiveFlights

final class AirlineRowViewModelTests: XCTestCase {

    // MARK: - Mock Actions

    private var saveActionCalled = false
    private var deleteActionCalled = false
    private var savedAirline: Airline?
    private var deletedAirline: Airline?

    private lazy var mockSaveAction: (Airline) -> Bool = { airline in
        self.saveActionCalled = true
        self.savedAirline = airline
        return true
    }

    private lazy var mockDeleteAction: (Airline) -> Bool = { airline in
        self.deleteActionCalled = true
        self.deletedAirline = airline
        return false
    }

    // MARK: - Properties

    private var viewModel: AirlineRowViewModel!
    private let mockAirline = Airline(
        id: "4650078",
        airlineId: "48",
        iataCode: "SQ",
        iataIcao: nil,
        airlineName: "Singapore Airlines",
        countryName: "Singapore",
        status: "active",
        isFavorite: nil
    )

    // MARK: - Setup

    override func setUp() {
        super.setUp()

        saveActionCalled = false
        deleteActionCalled = false
        savedAirline = nil
        deletedAirline = nil
        viewModel = AirlineRowViewModel(
            airline: mockAirline,
            onSaveAction: mockSaveAction,
            onDeleteAction: mockDeleteAction
        )
    }

    // MARK: - TearDown

    override func tearDown() {
        viewModel = nil

        super.tearDown()
    }

    // MARK: - Tests

    func testInitialState() {
        // THEN
        XCTAssertEqual(viewModel.name, "Singapore Airlines")
        XCTAssertEqual(viewModel.iataCode, "IATA Code: SQ")
        XCTAssertEqual(viewModel.countryName, "Country: Singapore")
        XCTAssertFalse(viewModel.isAirlineSaved)
        XCTAssertEqual(viewModel.favoriteIcon, "heart")
    }

    func testInitialStateAsFavorite() {
        // GIVEN
        let favoriteAirline = Airline(
            id: "4650078",
            airlineId: "48",
            iataCode: "SQ",
            iataIcao: nil,
            airlineName: "Singapore Airlines",
            countryName: "Singapore",
            status: "active",
            isFavorite: true
        )

        // WHEN
        viewModel = AirlineRowViewModel(
            airline: favoriteAirline,
            onSaveAction: mockSaveAction,
            onDeleteAction: mockDeleteAction
        )

        // THEN
        XCTAssertTrue(viewModel.isAirlineSaved)
        XCTAssertEqual(viewModel.favoriteIcon, "heart.fill")
    }

    func testSaveButtonTappedSavesAirline() {
        // WHEN
        viewModel.saveButtonTapped()

        // THEN
        XCTAssertTrue(saveActionCalled)
        XCTAssertFalse(deleteActionCalled)
        XCTAssertTrue(viewModel.isAirlineSaved)
        XCTAssertEqual(viewModel.favoriteIcon, "heart.fill")
        XCTAssertEqual(savedAirline?.id, mockAirline.id)
    }

    func testSaveButtonTappedDeletesAirlineWhenAlreadySaved() {
        // GIVEN
        viewModel.isAirlineSaved = true
        viewModel.favoriteIcon = "heart.fill"

        // WHEN
        viewModel.saveButtonTapped()

        // THEN
        XCTAssertFalse(saveActionCalled)
        XCTAssertTrue(deleteActionCalled)
        XCTAssertFalse(viewModel.isAirlineSaved)
        XCTAssertEqual(viewModel.favoriteIcon, "heart")
        XCTAssertEqual(deletedAirline?.id, mockAirline.id)
    }

    func testSaveAirlineUpdatesState() {
        // WHEN
        viewModel.saveButtonTapped()

        // THEN
        XCTAssertTrue(saveActionCalled)
        XCTAssertFalse(deleteActionCalled)
        XCTAssertTrue(viewModel.isAirlineSaved)
        XCTAssertEqual(viewModel.favoriteIcon, "heart.fill")
        XCTAssertEqual(savedAirline?.id, mockAirline.id)
    }

    func testDeleteAirlineUpdatesState() {
        // GIVEN
        viewModel.isAirlineSaved = true
        viewModel.favoriteIcon = "heart.fill"

        // WHEN
        viewModel.saveButtonTapped()

        // THEN
        XCTAssertFalse(saveActionCalled)
        XCTAssertTrue(deleteActionCalled)
        XCTAssertFalse(viewModel.isAirlineSaved)
        XCTAssertEqual(viewModel.favoriteIcon, "heart")
        XCTAssertEqual(deletedAirline?.id, mockAirline.id)
    }

    func testNameIsUnknownWhenNil() {
        // GIVEN
        let nilNameAirline = Airline(
            id: "4650078",
            airlineId: "48",
            iataCode: "SQ",
            iataIcao: nil,
            airlineName: nil,
            countryName: "Singapore",
            status: "active",
            isFavorite: nil
        )

        // WHEN
        viewModel = AirlineRowViewModel(
            airline: nilNameAirline,
            onSaveAction: mockSaveAction,
            onDeleteAction: mockDeleteAction
        )

        // THEN
        XCTAssertEqual(viewModel.name, "Unknown name")
    }

    func testIATACodeIsNotAvailableWhenNil() {
        // GIVEN
        let nilIATAAirline = Airline(
            id: "4650078",
            airlineId: "48",
            iataCode: nil,
            iataIcao: nil,
            airlineName: "Singapore Airlines",
            countryName: "Singapore",
            status: "active",
            isFavorite: nil
        )

        // WHEN
        viewModel = AirlineRowViewModel(
            airline: nilIATAAirline,
            onSaveAction: mockSaveAction,
            onDeleteAction: mockDeleteAction
        )

        // THEN
        XCTAssertEqual(viewModel.iataCode, "IATA Code: Not Available")
    }

    func testCountryNameIsCountryTextWhenNil() {
        // GIVEN
        let nilCountryAirline = Airline(
            id: "4650078",
            airlineId: "48",
            iataCode: "SQ",
            iataIcao: nil,
            airlineName: "Singapore Airlines",
            countryName: nil,
            status: "active",
            isFavorite: nil
        )

        // WHEN
        viewModel = AirlineRowViewModel(
            airline: nilCountryAirline,
            onSaveAction: mockSaveAction,
            onDeleteAction: mockDeleteAction
        )

        // THEN
        XCTAssertEqual(viewModel.countryName, "Country: Country: ")
    }
}
