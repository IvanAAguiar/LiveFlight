//
//  GenericErrorViewModelTests.swift
//  LiveFlightsTests
//
//  Created by Ivan Aguiar on 06/05/2025.
//

import XCTest
@testable import LiveFlights

final class GenericErrorViewModelTests: XCTestCase {

    // MARK: - Properties

    private var viewModel: GenericErrorViewModel!
    private var retryActionCalled = false

    private lazy var mockRetryAction: () -> Void = {
        self.retryActionCalled = true
    }

    // MARK: - Setup

    override func setUp() {
        super.setUp()

        retryActionCalled = false
        viewModel = GenericErrorViewModel()
    }

    // MARK: - TearDown

    override func tearDown() {
        viewModel = nil

        super.tearDown()
    }

    // MARK: - Tests - Initial State with Defaults

    func testInitialStateHasDefaultValues() {
        XCTAssertEqual(viewModel.systemImageName, "exclamationmark.circle")
        XCTAssertEqual(viewModel.errorImage, "error_image")
        XCTAssertEqual(viewModel.errorTitle, "An unexpected error occurred. Please try again later.")
        XCTAssertEqual(viewModel.errorMessage, "An unexpected error occurred. Please try again later.")
        XCTAssertEqual(viewModel.buttonTitle, "Try Again")
        XCTAssertTrue(viewModel.isRetryButtonHidden)
    }

    // MARK: - Tests - Initialization with Custom Values

    func testInitializationWithCustomValues() {
        let customSystemImage = "wifi.slash"
        let customErrorImage = "custom_error"
        let customErrorTitle = "Network Error"
        let customErrorMessage = "Failed to connect to the internet."
        let customButtonTitle = "Retry Connection"

        viewModel = GenericErrorViewModel(
            systemImageName: customSystemImage,
            errorImage: customErrorImage,
            errorTitle: customErrorTitle,
            errorMessage: customErrorMessage,
            buttonTitle: customButtonTitle,
            retryAction: mockRetryAction
        )

        XCTAssertEqual(viewModel.systemImageName, customSystemImage)
        XCTAssertEqual(viewModel.errorImage, customErrorImage)
        XCTAssertEqual(viewModel.errorTitle, customErrorTitle)
        XCTAssertEqual(viewModel.errorMessage, customErrorMessage)
        XCTAssertEqual(viewModel.buttonTitle, customButtonTitle)
        XCTAssertFalse(viewModel.isRetryButtonHidden) // retryAction is not nil
    }

    // MARK: - Tests - isRetryButtonHidden Property

    func testIsRetryButtonHiddenIsTrueWhenRetryActionIsNotNil() {
        viewModel = GenericErrorViewModel(retryAction: mockRetryAction)
        XCTAssertFalse(viewModel.isRetryButtonHidden)
    }

    func testIsRetryButtonHiddenIsFalseWhenRetryActionIsNil() {
        XCTAssertTrue(viewModel.isRetryButtonHidden)
    }

    // MARK: - Tests - retry() Method

    func testRetryActionIsCalledWhenRetryIsInvoked() {
        // GIVEN
        viewModel = GenericErrorViewModel(retryAction: mockRetryAction)

        // WHEN
        viewModel.retry()

        // THEN
        XCTAssertTrue(retryActionCalled)
    }

    func testRetryActionIsNotCalledWhenRetryIsInvokedAndActionIsNil() {
        // WHEN
        viewModel.retry()

        // THEN
        XCTAssertFalse(retryActionCalled)
    }
}
