//
//  APIError.swift
//  LiveFlights
//
//  Created by Ivan Aguiar on 09/05/2025.
//

import Foundation

enum APIError: Error {
    case invalidURL
    case requestFailed(Int) // HTTP status code
    case invalidData
    case decodingError(Error)
    case unknown(Error?)
}

extension APIError: LocalizedError {
    var errorDescription: String? {
        switch self {
        case .invalidURL:
            return "The provided URL is invalid."
        case .requestFailed(let statusCode):
            return "Request failed with status code: \(statusCode)."
        case .invalidData:
            return "Received invalid data from the server."
        case .decodingError(let error):
            return "Error decoding the server response: \(error.localizedDescription)."
        case .unknown(let error):
            return "An unknown error occurred: \(error?.localizedDescription ?? "No details available")."
        }
    }
}
