//
//  AviationStackEndpoint.swift
//  LiveFlights
//
//  Created by Ivan Aguiar on 10/05/2025.
//

import Foundation

enum AviationStackEndpoint: Endpointable {

    case airlines(name: String?, iataCode: String?)
    case flights(iataCode: String?, date: String?, status: String?)
    case airports

    var path: String {
        switch self {
        case .airlines:
            "/v1/airlines"
        case .flights:
            "/v1/flights"
        case .airports:
            "/v1/airports"
        }
    }

    var basePath: String { "" }

    var queryItems: [URLQueryItem] {
        var queryItems: [URLQueryItem] = []

        switch self {
        case .airlines(let name, let iataCode):
            if let name {
                queryItems.append(URLQueryItem(name: "name", value: name))
            }
            if let iataCode {
                queryItems.append(URLQueryItem(name: "iata_code", value: iataCode))
            }

        case .flights(let iataCode, let date, let status):
            if let iataCode {
                queryItems.append(URLQueryItem(name: "airline_iata", value: iataCode))
            }
            if let date {
                queryItems.append(URLQueryItem(name: "flight_date", value: date))
            }
            if let status {
                queryItems.append(URLQueryItem(name: "flight_status", value: status))
            }

        case .airports:
            queryItems  = []
        }

        return queryItems
    }
}
