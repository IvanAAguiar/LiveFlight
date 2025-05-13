//
//  AirlinesRepository.swift
//  LiveFlights
//
//  Created by Ivan Aguiar on 09/05/2025.
//

import CoreData

protocol AirlinesRepositoryRepresentable {
    func fetchCachedAirlines(
        name: String?,
        iataCode: String?
    ) throws -> [Airline]?
    func saveAirlines(_ airlines: [Airline]) throws
    func updateAirlineIsFavorite(airlineId: String, isFavorite: Bool) throws
    func clearAllCachedAirlines() throws
}

final class AirlinesRepository: AirlinesRepositoryRepresentable {

    // MARK: - Properties

    private let coreDataManager: CoreDataManager

    // MARK: - Init

    init() {
        self.coreDataManager = CoreDataManager.shared
        /// Set up the initial state of this instance, assigning values to its properties as needed.
    }

    // MARK: - Methods

    func fetchCachedAirlines(
        name: String? = nil,
        iataCode: String? = nil
    ) throws -> [Airline]? {
        let fetchRequest: NSFetchRequest<AirlineEntity> = AirlineEntity.fetchRequest()

        if let name = name, let iataCode = iataCode {
            fetchRequest.predicate = NSPredicate(
                format: "iataCode == %@ OR airlineName == %@", name, iataCode
            )
        }

        do {
            let cachedAirlines = try coreDataManager.viewContext.fetch(fetchRequest)

            return cachedAirlines.map { airline in
                Airline(
                    id: airline.id,
                    airlineId: airline.airlineId,
                    iataCode: airline.iataCode,
                    iataIcao: airline.iataIcao,
                    airlineName: airline.airlineName,
                    countryName: airline.countryName,
                    status: airline.status,
                    isFavorite: airline.isFavorite
                )
            }
        } catch let error as NSError {
            throw APIError.decodingError(error)
        }
    }

    func saveAirlines(_ airlines: [Airline]) throws {
        airlines.forEach { airline in
            let cachedAirline = AirlineEntity(context: coreDataManager.viewContext)

            cachedAirline.id = airline.id
            cachedAirline.airlineId = airline.airlineId
            cachedAirline.iataCode = airline.iataCode
            cachedAirline.airlineName = airline.airlineName
            cachedAirline.countryName = airline.countryName
        }
        
        do {
            try coreDataManager.saveContext()
        } catch let error as NSError {
            throw APIError.decodingError(error)
        }
    }

    func updateAirlineIsFavorite(airlineId: String, isFavorite: Bool) throws {
            let fetchRequest: NSFetchRequest<AirlineEntity> = AirlineEntity.fetchRequest()
            fetchRequest.predicate = NSPredicate(format: "id == %@", airlineId)

            do {
                let results = try coreDataManager.viewContext.fetch(fetchRequest)

                if let airlineToUpdate = results.first {
                    airlineToUpdate.isFavorite = isFavorite
                    try coreDataManager.saveContext()
                } else {
                    print("Warning: Airline with ID \(airlineId) not found in cache.")
                }
            } catch let error as NSError {
                throw APIError.decodingError(error)
            }
        }

    func clearAllCachedAirlines() throws {
        let fetchRequest: NSFetchRequest<NSFetchRequestResult> = AirlineEntity.fetchRequest()
        let batchDeleteRequest = NSBatchDeleteRequest(fetchRequest: fetchRequest)

        do {
            try coreDataManager.viewContext.execute(batchDeleteRequest)
            try coreDataManager.saveContext()
        } catch let error as NSError {
            throw APIError.decodingError(error)
        }
    }

    /// Implement additional methods as needed.
}

// MARK: - MockAirlinesRepository

protocol MockAirlinesRepositoryRepresentable {
    var cachedAirlines: [Airline]? { get set }
    var saveAirlinesCalled: Bool { get set }
    var savedAirlines: [Airline] { get set }
    var updatedAirlineId: String? { get set }
    var updatedIsFavorite: Bool? { get set }
}

final class MockAirlinesRepository: AirlinesRepositoryRepresentable, MockAirlinesRepositoryRepresentable {

    // MARK: - Properties

    var cachedAirlines: [Airline]?
    var saveAirlinesCalled: Bool = false
    var savedAirlines: [Airline] = []
    var updatedAirlineId: String?
    var updatedIsFavorite: Bool?

    // MARK: - Methods

    func fetchCachedAirlines(
        name: String? = nil,
        iataCode: String? = nil
    ) throws -> [Airline]? {
        return cachedAirlines
    }

    func saveAirlines(_ airlines: [Airline]) throws {
        saveAirlinesCalled = true
        savedAirlines.append(contentsOf: airlines)
    }

    func updateAirlineIsFavorite(airlineId: String, isFavorite: Bool) throws {
        updatedAirlineId = airlineId
        updatedIsFavorite = isFavorite
    }

    func clearAllCachedAirlines() throws {
        savedAirlines.removeAll()
    }
}
