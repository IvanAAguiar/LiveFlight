//
//  AirlineModel.swift
//  LiveFlights
//
//  Created by Ivan Aguiar on 05/05/2025.
//

// MARK: - AirlineResponse
public struct AirlineModel: Codable, Hashable {
    let pagination: Pagination
    let data: [Airline]
}

// MARK: - Pagination
public struct Pagination: Codable, Hashable {
    let offset, limit, count, total: Int
}

// MARK: - Airline
public struct Airline: Codable, Hashable, Identifiable {
    public let id: String?
    let airlineId: String?
    let iataCode: String?
    let iataIcao: String?
    let airlineName: String?
    let countryName: String?
    let status: String?
    let isFavorite: Bool?

    enum CodingKeys: String, CodingKey {
        case id       
        case airlineId = "airline_id"
        case iataCode = "iata_code"
        case iataIcao = "iata_icao"
        case airlineName = "airline_name"
        case countryName = "country_name"
        case status = "status"
        case isFavorite = "isFavorite"
    }
}

extension AirlineModel {
    static func mock() -> AirlineModel {
        AirlineModel(
            pagination: Pagination(
                offset: 100,
                limit: 0,
                count: 100,
                total: 6
            ),
            data: [
                Airline(
                    id: "4071780",
                    airlineId: "1",
                    iataCode: "AA",
                    iataIcao: nil,
                    airlineName: "American Airlines",
                    countryName: "United States",
                    status: "active",
                    isFavorite: nil
                ),
                Airline(
                    id: "4597464",
                    airlineId: "14",
                    iataCode: "BA",
                    iataIcao: nil,
                    airlineName: "British Airways",
                    countryName: "United Kingdom",
                    status: "inactive",
                    isFavorite: nil
                ),
                Airline(
                    id: "4650051",
                    airlineId: "21",
                    iataCode: "QR",
                    iataIcao: nil,
                    airlineName: "Qatar Airways",
                    countryName: "Qatar",
                    status: "active",
                    isFavorite: nil
                ),
                Airline(
                    id: "4650057",
                    airlineId: "27",
                    iataCode: "JL",
                    iataIcao: nil,
                    airlineName: "Japan Airlines",
                    countryName: "Japan",
                    status: "active",
                    isFavorite: nil
                ),
                Airline(
                    id: "4650048",
                    airlineId: "18",
                    iataCode: "AF",
                    iataIcao: nil,
                    airlineName: "Air France",
                    countryName: "France",
                    status: "active",
                    isFavorite: nil
                ),
                Airline(
                    id: "4650078",
                    airlineId: "48",
                    iataCode: "SQ",
                    iataIcao: nil,
                    airlineName: "Singapore Airlines",
                    countryName: "Singapore",
                    status: "active",
                    isFavorite: nil
                ),
                Airline(
                    id: "4650068",
                    airlineId: "38",
                    iataCode: "G3",
                    iataIcao: nil,
                    airlineName: "Gol Linhas Aéreas Inteligentes",
                    countryName: "Brazil",
                    status: "active",
                    isFavorite: true
                ),
            ]
        )
    }
}
