//
//  GenericErrorViewModel.swift
//  LiveFlights
//
//  Created by Ivan Aguiar on 06/05/2025.
//

protocol GenericErrorViewModelRepresentable {
    var systemImageName: String { get }
    var errorTitle: String { get }
    var errorMessage: String { get }
    var buttonTitle: String { get }
    var isRetryButtonHidden: Bool { get set }

    func retry()
}

final class GenericErrorViewModel: GenericErrorViewModelRepresentable {

    // MARK: - Inner Types

    private enum Constants {
        static let systemImageName = "exclamationmark.circle"
        static let errorImage = "error_image"
        static let errorTitle = "Something Went Wrong"
        static let errorMessage = "An unexpected error occurred. Please try again later."
        static let buttonTitle = "Try Again"
    }

    // MARK: - Properties

    var systemImageName: String
    var errorImage: String
    var errorTitle: String
    var errorMessage: String
    var buttonTitle: String
    var retryAction: (() -> Void)?
    
    lazy var isRetryButtonHidden: Bool = {
        retryAction == nil
    }()

    // MARK: - Init

    init(
        systemImageName: String? = nil,
        errorImage: String? = nil,
        errorTitle: String? = nil,
        errorMessage: String? = nil,
        buttonTitle: String? = nil,
        retryAction: (() -> Void)? = nil
    ) {
        self.systemImageName = systemImageName ?? Constants.systemImageName
        self.errorImage = errorImage ?? Constants.errorImage
        self.errorTitle = errorTitle ?? Constants.errorMessage
        self.errorMessage = errorMessage ?? Constants.errorMessage
        self.buttonTitle = buttonTitle ?? Constants.buttonTitle
        self.retryAction = retryAction
    }

    // MARK: - Methods

    func retry() {
        retryAction?()
    }
}
