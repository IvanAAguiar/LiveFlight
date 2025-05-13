//
//  FavoritesAirlineEntity + CoreDataClass.swift
//  LiveFlights
//
//  Created by Ivan Aguiar on 10/05/2025.
//

import CoreData
import Foundation

@objc(FavoritesAirlineEntity)
public class FavoritesAirlineEntity: NSManagedObject, Decodable {
    enum CodingKeys: String, CodingKey {
        case airline
    }

    required convenience public init(from decoder: Decoder) throws {
        self.init(from: decoder, type: FavoritesAirlineEntity.self)

        let container = try decoder.container(keyedBy: CodingKeys.self)

        self.airline = try container.decode(AirlineEntity.self, forKey: .airline)
    }
}
