//
//  AviationStackAPIClient.swift
//  LiveFlights
//
//  Created by Ivan Aguiar on 10/05/2025.
//

protocol APIClientAirlinesFetchable {
    func fetchAirlines(name: String?, iataCode: String?) async throws -> AirlineModel
}

protocol APIClientFlightsFetchable {
    func fetchFlights(iataCode: String?, date: String?, status: String?) async throws -> FlightModel
}

final class AviationStackAPIClient {
    
    // MARK: - Inner Types
    
    private enum Constants {
        static let baseURL = "https://api.aviationstack.com"
        static let apiKey = "XXXXXX" /// Add your API Access Key
    }
    
    // MARK: - Properties
    
    private let apiClient: APIClient
    
    // MARK: - Init
    
    init() {
        self.apiClient = APIClient(baseURL: Constants.baseURL, apiKey: Constants.apiKey)
    }
}

// MARK: - APIClientAirlinesFetchable

extension AviationStackAPIClient: APIClientAirlinesFetchable {
    func fetchAirlines(name: String? = nil, iataCode: String? = nil) async throws -> AirlineModel {
        let endpoint = AviationStackEndpoint.airlines(name: name, iataCode: iataCode)
        
        return try await apiClient.get(endpoint: endpoint)
    }
}

// MARK: - APIClientFlightsFetchable

extension AviationStackAPIClient: APIClientFlightsFetchable {
    func fetchFlights(iataCode: String? = nil, date: String? = nil, status: String? = nil) async throws -> FlightModel {
        let endpoint = AviationStackEndpoint.flights(iataCode: iataCode, date: date, status: status)

        return try await apiClient.get(endpoint: endpoint)
    }
}

/// Implement additional methods as needed.

// MARK: - MockAviationStackAPIClient

protocol MockAPIClientAirlinesFetchable {
    var fetchAirlinesResult: Result<AirlineModel, Error>? { get set }
}

protocol MockAPIClientFlightsFetchable {
    var fetchFlightsResult: Result<FlightModel, Error>? { get set }
}

typealias MockAirlinesProtocols = APIClientAirlinesFetchable & MockAPIClientAirlinesFetchable

typealias MockFlightsProtocols = APIClientFlightsFetchable & MockAPIClientFlightsFetchable

final class MockAviationStackAPIClient: MockAirlinesProtocols, MockFlightsProtocols {

    // MARK: - Properties

    var fetchAirlinesResult: Result<AirlineModel, Error>?
    var fetchFlightsResult: Result<FlightModel, any Error>?

    // MARK: - Init

    init(
        fetchAirlinesResult: Result<AirlineModel, Error>? = nil,
        fetchFlightsResult: Result<FlightModel, Error>? = nil
    ) {
        self.fetchAirlinesResult = fetchAirlinesResult
        self.fetchFlightsResult = fetchFlightsResult
    }

    // MARK: - Methods

    func fetchAirlines(
        name: String?,
        iataCode: String?
    ) async throws -> AirlineModel {
        switch fetchAirlinesResult {
        case .success(let response):
            return response
        case .failure(let error):
            throw error
        case .none:
            return AirlineModel.mock()
        }
    }

    func fetchFlights(
        iataCode: String? = nil,
        date: String? = nil,
        status: String? = nil
    ) async throws -> FlightModel {
        switch fetchFlightsResult {
        case .success(let response):
            return response
        case .failure(let error):
            throw error
        case nil:
            return FlightModel.mock()
        }
    }
}
