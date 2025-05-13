//
//  FavoritesRepository.swift
//  LiveFlights
//
//  Created by Ivan Aguiar on 10/05/2025.
//

import CoreData
import Foundation

protocol FavoritesRepositoryRepresentable {
    func saveFavoriteAirline(_ airline: Airline) throws -> Bool
    func deleteFavoriteAirline(_ airline: Airline) throws -> Bool
    func fetchFavoriteAirlines() throws -> [Airline]?
    func isAirlineFavorite(airlineId: String) -> Bool
}

class FavoritesRepository: FavoritesRepositoryRepresentable {

    private let coreDataManager: CoreDataManager

    // MARK: - Init

    init() {
        self.coreDataManager = CoreDataManager.shared
    }

    // MARK: - Methods

    func saveFavoriteAirline(_ airline: Airline) throws -> Bool {
        let fetchRequest: NSFetchRequest<NSFetchRequestResult> = FavoritesAirlineEntity.fetchRequest()
        fetchRequest.predicate = NSPredicate(format: "airline.id == %@", airline.id ?? "")
        fetchRequest.fetchLimit = 1
        
        do {
            let count = try coreDataManager.viewContext.count(for: fetchRequest)
            
            if count > 0 {
                return false
            }

            let favoriteAirline = FavoritesAirlineEntity(context: coreDataManager.viewContext)

            let fetchRequest: NSFetchRequest<AirlineEntity> = AirlineEntity.fetchRequest()
            fetchRequest.predicate = NSPredicate(format: "id == %@", airline.id ?? "")
            let results = try coreDataManager.viewContext.fetch(fetchRequest)
            
            if let airlineToUpdate = results.first {
                airlineToUpdate.isFavorite = true
                favoriteAirline.airline = airlineToUpdate
            }

            try coreDataManager.saveContext()
            return true
        } catch let error as NSError {
            throw APIError.decodingError(error)
        }
    }

    func deleteFavoriteAirline(_ airline: Airline) throws -> Bool {
        let fetchRequest: NSFetchRequest<FavoritesAirlineEntity> = FavoritesAirlineEntity.fetchRequest()
        fetchRequest.predicate = NSPredicate(format: "airline.id == %@", airline.id ?? "")

        do {
            let results = try coreDataManager.viewContext.fetch(fetchRequest)
            if let favoriteToDelete = results.first {
                coreDataManager.viewContext.delete(favoriteToDelete)

                let fetchRequest: NSFetchRequest<AirlineEntity> = AirlineEntity.fetchRequest()
                fetchRequest.predicate = NSPredicate(format: "id == %@", airline.id ?? "")
                let results = try coreDataManager.viewContext.fetch(fetchRequest)
                if let airlineToUpdate = results.first {
                    airlineToUpdate.isFavorite = false
                }

                try coreDataManager.saveContext()
                return true
            }
        } catch {
            throw APIError.decodingError(error)
        }

        return false
    }

    func fetchFavoriteAirlines() throws -> [Airline]? {
        let fetchRequest: NSFetchRequest<FavoritesAirlineEntity> = FavoritesAirlineEntity.fetchRequest()
        do {
            let favorites = try coreDataManager.viewContext.fetch(fetchRequest)
            return favorites.compactMap { favoriteAirline in
                    let cachedAirline = favoriteAirline.airline
                
                return Airline(
                    id: cachedAirline.id,
                    airlineId: cachedAirline.airlineId,
                    iataCode: cachedAirline.iataCode,
                    iataIcao: cachedAirline.iataIcao,
                    airlineName: cachedAirline.airlineName,
                    countryName: cachedAirline.countryName,
                    status: cachedAirline.status,
                    isFavorite: true
                )
            }
        } catch let error as NSError{
            throw APIError.decodingError(error)
        }
    }

    func isAirlineFavorite(airlineId: String) -> Bool {
        do {
            if let favorites = try fetchFavoriteAirlines() {
                return favorites.contains { $0.airlineId == airlineId }
            }
        } catch {
            return false
        }

        return false
    }
}

// MARK: - MockFavoritesRepository

protocol MockFavoritesRepositoryRepresentable{
    var saveFavoriteAirlineCalled: Bool { get set }
    var deleteFavoriteAirlineCalled: Bool { get set }
    var fetchFavoriteAirlinesCalled: Bool { get set }
    var isAirlineFavoriteCalled: Bool { get set }

    var saveFavoriteAirlineResult: Bool { get set }
    var deleteFavoriteAirlineResult: Bool { get set }
    var fetchFavoriteAirlinesResult: [Airline]? { get set }
    var isAirlineFavoriteResult: Bool { get set }

    var savedAirline: Airline? { get set }
    var deletedAirline: Airline? { get set }
    var checkedAirlineId: String? { get set }
}

final class MockFavoritesRepository: MockFavoritesRepositoryRepresentable, FavoritesRepositoryRepresentable {

    // MARK: - Properties

    var saveFavoriteAirlineCalled: Bool = false
    var deleteFavoriteAirlineCalled: Bool = false
    var fetchFavoriteAirlinesCalled: Bool = false
    var isAirlineFavoriteCalled: Bool = false

    var saveFavoriteAirlineResult: Bool = false
    var deleteFavoriteAirlineResult: Bool = false
    var fetchFavoriteAirlinesResult: [Airline]? = []
    var isAirlineFavoriteResult: Bool = false

    var savedAirline: Airline?
    var deletedAirline: Airline?
    var checkedAirlineId: String?

    // MARK: - Methods

    func saveFavoriteAirline(_ airline: Airline) -> Bool {
        saveFavoriteAirlineCalled = true
        savedAirline = airline
        return saveFavoriteAirlineResult
    }

    func deleteFavoriteAirline(_ airline: Airline) -> Bool {
        deleteFavoriteAirlineCalled = true
        deletedAirline = airline
        return deleteFavoriteAirlineResult
    }

    func fetchFavoriteAirlines() -> [Airline]? {
        fetchFavoriteAirlinesCalled = true
        return fetchFavoriteAirlinesResult
    }

    func isAirlineFavorite(airlineId: String) -> Bool {
        isAirlineFavoriteCalled = true
        checkedAirlineId = airlineId
        return isAirlineFavoriteResult
    }
}

