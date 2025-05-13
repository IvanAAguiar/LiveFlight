//
//  CoreDataManager.swift
//  LiveFlights
//
//  Created by Ivan Aguiar on 09/05/2025.
//

import CoreData

final class CoreDataManager {

    // MARK: - Inner Types

    private enum Constants {
        static let persistentContainerName = "LiveFlightsContainer"
    }

    static let shared = CoreDataManager()

    // MARK: - Properties

    private let persistentContainer: NSPersistentContainer

    var viewContext: NSManagedObjectContext {
        persistentContainer.viewContext
    }

    // MARK: - Init

    private init() {
        persistentContainer = NSPersistentContainer(name: Constants.persistentContainerName)
        persistentContainer.loadPersistentStores { (description, error) in
            if let error = error {
                fatalError("Failed to load CoreData stack: \(error)")
            }
        }
    }

    // MARK: - Methods

    func saveContext() throws {
        guard viewContext.hasChanges else { return }
        do {
            try viewContext.save()
        } catch let error as NSError {
            throw APIError.decodingError(error)
        }
    }
}
