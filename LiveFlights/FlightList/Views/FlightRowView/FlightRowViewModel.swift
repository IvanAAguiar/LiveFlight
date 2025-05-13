//
//  FlightRowViewModel.swift
//  LiveFlights
//
//  Created by Ivan Aguiar on 12/05/2025.
//

import Foundation
import SwiftUICore

protocol FlightRowViewModelRepresentable: ObservableObject {
    var flightName: String { get }
    var flightNumber: String { get }
    var flightStatus: String { get }
    var flightStatusColor: Color { get }
    var departureText: String { get }
    var flightDeparture: String { get }
    var flightDepartureScheduledDateText: String? { get }
    var flightArrivalScheduledDateText: String? { get }
    var scheduledText: String { get }
    var arrivalText: String { get }
    var flightArrival: String { get }
}

final class FlightRowViewModel: FlightRowViewModelRepresentable {

    // MARK: - Inner Types

    private enum Constants {
        static let departure: String = "Departure: "
        static let scheduled: String = "Scheduled: "
        static let arrival: String = "Arrival: "
        static let flight: String = "Flight: "
    }

    // MARK: - Properties

    private let flight: Flight

    let departureText = Constants.departure
    let arrivalText = Constants.arrival
    let scheduledText = Constants.scheduled

    lazy var flightName = flight.airline.name
    lazy var flightNumber = Constants.flight + flight.flight.number
    lazy var flightDeparture = flight.departure.airport
    lazy var flightDepartureScheduledDateText = formatDate(flight.departure.scheduled)
    lazy var flightArrival = flight.arrival.airport
    lazy var flightArrivalScheduledDateText = formatDate(flight.arrival.scheduled)
    
    lazy var flightStatus = flight.flightStatus.capitalized
    lazy var flightStatusColor: Color =  {
        switch flight.flightStatus.lowercased() {
        case "scheduled":
            return .green
        case "cancelled", "incident":
            return .red
        case "active", "arrival":
            return .blue
        default:
            return .gray
        }
    }()
    
    

    // MARK: - Init

    init(flight: Flight) {
        self.flight = flight
    }

    // MARK: - Methods

    func formatDate(_ dateString: String?) -> String? {
        guard let dateString = dateString else { return nil }
        let dateFormatter = ISO8601DateFormatter()
        if let date = dateFormatter.date(from: dateString) {
            let outputFormatter = DateFormatter()
            outputFormatter.dateFormat = "HH:mm"
            return outputFormatter.string(from: date)
        }
        return nil
    }
}
