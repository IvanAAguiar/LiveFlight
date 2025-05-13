//
//  APIClient.swift
//  LiveFlights
//
//  Created by Ivan Aguiar on 10/05/2025.
//

import Foundation

final class APIClient {

    // MARK: - Properties

    private let baseURL: String
    private let apiKey: String

    // MARK: - Init

    init(baseURL: String, apiKey: String) {
        self.baseURL = baseURL
        self.apiKey = apiKey
    }

    // MARK: - Methods

    func get<T: Codable>(endpoint: Endpointable) async throws -> T {
        var queryItems: [URLQueryItem] = []

        /// Construct the full URL by combining the base URL with the path from the Endpointable protocol.
        guard
            var urlComponents = URLComponents(string: baseURL + endpoint.path)
        else {
            throw APIError.invalidURL
        }

        /// Append the access key as a mandatory query parameter for API authentication.
        queryItems.append(URLQueryItem(name: "access_key", value: apiKey))

        /// Iterate through the dictionary and append each key-value pair as a URL query item.
        queryItems.append(contentsOf: endpoint.queryItems.map { URLQueryItem(name: $0.name, value: $0.value) })

        urlComponents.queryItems = queryItems

        /// Get the final URL from the URL components.
        guard
            let url = urlComponents.url
        else {
            throw APIError.invalidURL
        }

        /// Perform an asynchronous data task to fetch data from the constructed URL.
        let (data, response) = try await URLSession.shared.data(from: url)

        /// Check if the HTTP response indicates success (status code in the range 200-299).
        guard let httpResponse = response as? HTTPURLResponse, (200...299).contains(httpResponse.statusCode) else {
            throw APIError.requestFailed((response as? HTTPURLResponse)?.statusCode ?? 0)
        }

        /// Attempt to decode the received data into the specified Codable type (T).
        do {
            let decoder = JSONDecoder()
            return try decoder.decode(T.self, from: data)
        } catch {
            throw APIError.decodingError(error)
        }
    }

    /// Add additional methods for POST, PUT, DELETE as required.
    ///
    /// func post<T: Codable>(endpoint: String, queryParameters: [String: String]? = nil) async throws -> T {...}
    /// func put<T: Codable>(endpoint: String, queryParameters: [String: String]? = nil) async throws -> T {...}
    /// func delete<T: Codable>(endpoint: String, queryParameters: [String: String]? = nil) async throws -> T {...}
}
