//
//  FlightModel.swift
//  LiveFlights
//
//  Created by Ivan Aguiar on 10/05/2025.
//

import Foundation

// MARK: - FlightResponse
struct FlightModel: Codable, Hashable {
    let pagination: Pagination
    let data: [Flight]
}

// MARK: - Flight
public struct Flight: Codable, Hashable {

    let flightDate: String
    let flightStatus: String
    let departure: Departure
    let arrival: Arrival
    let airline: AirlineReference
    let flight: FlightDetails
    let isFavorite: Bool?

    enum CodingKeys: String, CodingKey {
        case flightDate = "flight_date"
        case flightStatus = "flight_status"
        case departure, arrival, airline, flight, isFavorite
    }
}

// MARK: - Airline
struct AirlineReference: Codable, Hashable {
    let name, iata, icao: String
}

// MARK: - Arrival
public struct Arrival: Codable, Hashable {
    let airport,
        timezone,
        iata,
        icao,
        scheduled: String

    enum CodingKeys: String, CodingKey {
        case airport,
             timezone,
             iata,
             icao,
             scheduled
    }
}

// MARK: - Departure
public struct Departure: Codable, Hashable {
    let airport,
        timezone,
        iata,
        icao,
        scheduled: String
    let estimated: String?

    enum CodingKeys: String, CodingKey {
        case airport,
             timezone,
             iata,
             icao,
             scheduled,
             estimated
    }
}

// MARK: - FlightDetails
public struct FlightDetails: Codable, Hashable {
    let number,
        iata,
        icao: String
    let codeshared: Codeshared?

    enum CodingKeys: String, CodingKey {
        case number, iata, icao, codeshared
    }
}

// MARK: - Codeshared

public struct Codeshared: Codable, Hashable {
    let airlineName: String
    let airlineIata: String
    let airlineIcao: String
    let flightNumber: String
    let flightIata: String
    let flightIcao: String
    
    enum CodingKeys: String, CodingKey {
        case airlineName = "airline_name"
        case airlineIata = "airline_iata"
        case airlineIcao = "airline_icao"
        case flightNumber = "flight_number"
        case flightIata = "flight_iata"
        case flightIcao = "flight_icao"
    }
}

extension FlightModel {
    static func mock() -> FlightModel {
        FlightModel(
            pagination: Pagination(
                offset: 100,
                limit: 0,
                count: 100,
                total: 6
            ),
            data: [
                Flight(
                    flightDate: "2025-05-12",
                    flightStatus: "scheduled",
                    departure: Departure(
                        airport: "Hasanudin",
                        timezone: "Asia/Makassar",
                        iata: "UPG",
                        icao: "WAAA",
                        scheduled: "2025-05-12T03:45:00+00:00",
                        estimated: "2025-05-12T03:45:00+00:00"
                    ),
                    arrival: Arrival(
                        airport: "Jefman",
                        timezone: "Asia/Jayapura",
                        iata: "SOQ",
                        icao: "WASS",
                        scheduled: "2025-05-12T07:00:00+00:00"
                    ),
                    airline: AirlineReference(
                        name: "Sriwijaya Air",
                        iata: "SJ",
                        icao: "SJY"
                    ),
                    flight: FlightDetails(
                        number: "912",
                        iata: "SJ912",
                        icao: "SJY912",
                        codeshared: nil
                    ),
                    isFavorite: false
                ),
                Flight(
                    flightDate: "2025-05-12",
                    flightStatus: "scheduled",
                    departure: Departure(
                        airport: "Guangzhou Baiyun International",
                        timezone: "Asia/Makassar",
                        iata: "UPG",
                        icao: "WAAA",
                        scheduled: "2025-05-12T03:45:00+00:00",
                        estimated: "2025-05-12T03:45:00+00:00"
                    ),
                    arrival: Arrival(
                        airport: "Ninoy Aquino International",
                        timezone: "Asia/Manila",
                        iata: "MNL",
                        icao: "RPLL",
                        scheduled: "2025-05-12T06:55:00+00:00"
                    ),
                    airline: AirlineReference(
                        name: "Cebu Pacific Air",
                        iata: "5J",
                        icao: "CEB"
                    ),
                    flight: FlightDetails(
                        number: "309",
                        iata: "5J309",
                        icao: "CEB309",
                        codeshared: nil
                    ),
                    isFavorite: false
                )
            ]
        )
    }
}
