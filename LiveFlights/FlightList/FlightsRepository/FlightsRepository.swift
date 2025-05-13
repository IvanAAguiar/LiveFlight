//
//  FlightsRepository.swift
//  LiveFlights
//
//  Created by Ivan Aguiar on 11/05/2025.
//

import CoreData
import Foundation

protocol FlightsRepositoryRepresentable {
    func fetchCachedFlights() throws -> [Flight]?
    func saveFlights(_ flights: [Flight]) throws
}

final class FlightsRepository: FlightsRepositoryRepresentable {

    // MARK: - Inner Type

    struct Dependencies {
        let airlineService: any AirlinesServiceRepresentable
        let coreDataManager: CoreDataManager
    }

    // MARK: - Properties

    private let dependencies: Dependencies

    // MARK: - Init
    
    init(dependencies: Dependencies) {
        self.dependencies = dependencies
        /// Set up the initial state of this instance, assigning values to its properties as needed.
    }

    // MARK: - Methods

    func fetchCachedFlights() throws -> [Flight]? {
        let fetchRequest: NSFetchRequest<FlightEntity> = FlightEntity.fetchRequest()

        do {
            let cachedFlights = try dependencies.coreDataManager.viewContext.fetch(fetchRequest)

            return cachedFlights.map { flight in
                Flight(
                    flightDate: flight.flightDate,
                    flightStatus: flight.flightStatus,
                    departure: flight.departure.toProxy(),
                    arrival: flight.arrival.toProxy(),
                    airline: AirlineReference(
                        name: flight.airline.airlineName ?? "",
                        iata: flight.airline.iataCode ?? "",
                        icao: flight.airline.iataIcao ?? ""
                    ),
                    flight: flight.flight.toProxy(),
                    isFavorite: flight.isFavorite
                )
            }
        } catch let error as NSError {
            throw APIError.decodingError(error)
        }
    }

    func saveFlights(_ flights: [Flight]) throws {
        flights.forEach { flight in
            Task { [weak self] in
                guard let self = self else { return }
                _ = try await self.createFlightModel(flight)
                try dependencies.coreDataManager.saveContext()
            }
        }
    }
}

extension FlightsRepository {
    private func createFlightModel(_ flight: Flight) async throws -> FlightEntity {
        let cachedFlight = FlightEntity(
            context: dependencies.coreDataManager.viewContext
        )

        cachedFlight.flightDate =  flight.flightDate
        cachedFlight.flightStatus = flight.flightStatus
        cachedFlight.departure = createDepartureModel(flight.departure)
        cachedFlight.arrival = createArrivalModel(flight.arrival)
        cachedFlight.airline = try await createAirlineModel(flight.airline)
        cachedFlight.flight = createFlightDetailsModel(flight.flight)
        cachedFlight.isFavorite = flight.isFavorite ?? false

        return cachedFlight
    }

    private func createDepartureModel(
        _ departure: Departure
    ) -> DepartureEntity {
        let cachedDeparture = DepartureEntity(
            context: dependencies.coreDataManager.viewContext
        )

        cachedDeparture.airport = departure.airport
        cachedDeparture.timezone = departure.timezone
        cachedDeparture.iata = departure.iata
        cachedDeparture.icao = departure.icao
        cachedDeparture.scheduled = departure.scheduled
        cachedDeparture.estimated = departure.estimated

        return cachedDeparture
    }

    private func createArrivalModel(
        _ arrival: Arrival
    ) -> ArrivalEntity {
        let cachedArrival = ArrivalEntity(
            context: dependencies.coreDataManager.viewContext
        )

        cachedArrival.airport = arrival.airport
        cachedArrival.timezone = arrival.timezone
        cachedArrival.iata = arrival.iata
        cachedArrival.icao = arrival.icao
        cachedArrival.scheduled = arrival.scheduled

        return cachedArrival
    }

    private func createAirlineModel(
        _ airline: AirlineReference
    ) async throws -> AirlineEntity {
        let fetchedAirline = try await dependencies.airlineService.fetchAirlines(
            name: airline.name,
            iataCode: airline.iata
        ).first

        let cachedAirline = AirlineEntity(
            context: dependencies.coreDataManager.viewContext
        )

        cachedAirline.id = fetchedAirline?.id
        cachedAirline.airlineId = fetchedAirline?.airlineId
        cachedAirline.airlineName = fetchedAirline?.airlineName ?? airline.name
        cachedAirline.iataCode = fetchedAirline?.iataCode ?? airline.iata
        cachedAirline.iataIcao = fetchedAirline?.iataIcao ?? airline.icao
        cachedAirline.countryName = fetchedAirline?.countryName
        cachedAirline.status = fetchedAirline?.status
        cachedAirline.isFavorite = fetchedAirline?.isFavorite ?? false

        return cachedAirline
    }

    private func createFlightDetailsModel(
        _ flightDetails: FlightDetails
    ) -> FlightDetailsEntity {
        let cachedFlightDetails = FlightDetailsEntity(
            context: dependencies.coreDataManager.viewContext
        )

        cachedFlightDetails.number = flightDetails.number
        cachedFlightDetails.iata = flightDetails.iata
        cachedFlightDetails.icao = flightDetails.icao

        return cachedFlightDetails
    }

    /// Implement additional methods as needed.
}

// MARK: - MockFlightsRepository

protocol MockFlightsRepositoryRepresentable {
    var fetchCachedFlightsResult: Result<[Flight]?, Error> { get set }
    var fetchCachedFlightsCalled: Bool { get set }
    var saveFlightsCalled: Bool { get set }
    var savedFlights: [Flight]? { get set }
}

final class MockFlightsRepository: MockFlightsRepositoryRepresentable, FlightsRepositoryRepresentable {

    // MARK: - Properties

    var fetchCachedFlightsCalled = false
    var fetchCachedFlightsResult: Result<[Flight]?, Error> = .success(nil)

    var saveFlightsCalled = false
    var savedFlights: [Flight]?

    // MARK: - Methods

    func fetchCachedFlights() throws -> [Flight]? {
        fetchCachedFlightsCalled = true
        return try fetchCachedFlightsResult.get()
    }

    func saveFlights(_ flights: [Flight]) throws {
        saveFlightsCalled = true
        savedFlights = flights
    }
}
