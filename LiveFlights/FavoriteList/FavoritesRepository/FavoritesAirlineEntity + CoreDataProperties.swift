//
//  FavoritesAirlineEntity + CoreDataProperties.swift
//  LiveFlights
//
//  Created by Ivan Aguiar on 10/05/2025.
//

import CoreData
import Foundation

extension FavoritesAirlineEntity {
    @nonobjc public class func fetchRequest() -> NSFetchRequest<FavoritesAirlineEntity> {
        return NSFetchRequest<FavoritesAirlineEntity>(entityName: "FavoritesAirlineEntity")
    }

    @NSManaged public var airline: AirlineEntity
}
