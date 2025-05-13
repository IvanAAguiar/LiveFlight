//
//  AirlineRowViewModel.swift
//  LiveFlights
//
//  Created by Ivan Aguiar on 08/05/2025.
//

import Foundation

protocol AirlineRowViewModelRepresentable: ObservableObject {
    var favoriteIcon: String { get set}
    var isAirlineSaved: Bool { get set }
    var name: String { get }
    var iataCode: String { get }
    var countryName: String { get }
    
    func saveButtonTapped()
}

final class AirlineRowViewModel: AirlineRowViewModelRepresentable {

    // MARK: - Inner Types

    private enum Constants {
        static let selectedIcon = "heart.fill"
        static let unselectedIcon = "heart"
        static let unknownName = "Unknown name"
        static let iataCode = "IATA Code: "
        static let countryText = "Country: "
        static let notAvailable = "Not Available"
    }

    // MARK: - Properties

    @Published var favoriteIcon: String
    @Published var isAirlineSaved: Bool

    private let airline: Airline

    let onSaveAction: (Airline) throws -> Bool
    let onDeleteAction: (Airline) throws -> Bool

    lazy var name: String = { airline.airlineName ?? Constants.unknownName }()
    lazy var iataCode: String = { Constants.iataCode + (airline.iataCode ?? Constants.notAvailable) }()
    lazy var countryName: String = { Constants.countryText + (airline.countryName ?? Constants.countryText) }()

    // MARK: - Init

    init(
        airline: Airline,
        onSaveAction: @escaping (Airline) throws -> Bool,
        onDeleteAction: @escaping (Airline) throws -> Bool
    ) {
        self.airline = airline
        self.isAirlineSaved = airline.isFavorite ?? false
        self.favoriteIcon = airline.isFavorite ?? false ? Constants.selectedIcon : Constants.unselectedIcon
        self.onSaveAction = onSaveAction
        self.onDeleteAction = onDeleteAction
    }
}

    // MARK: - Methods

extension AirlineRowViewModel {
    func saveButtonTapped() {
        do {
            isAirlineSaved ? try deleteAirline() : try saveAirline()
        } catch {
            print("Warning: Airline not found in cache.")
        }
    }

    private func saveAirline() throws {
        isAirlineSaved = try onSaveAction(airline)
        favoriteIcon = Constants.selectedIcon
    }

    private func deleteAirline() throws {
        isAirlineSaved = try onDeleteAction(airline)
        favoriteIcon = Constants.unselectedIcon
    }
}
