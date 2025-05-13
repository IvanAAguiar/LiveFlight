//
//  ArrivalEntity + CoreData.swift
//  LiveFlights
//
//  Created by Ivan Aguiar on 11/05/2025.
//

import CoreData
import Foundation

@objc(ArrivalEntity)
public class ArrivalEntity: NSManagedObject, Decodable {
    enum CodingKeys: String, CodingKey {
        case airport,
             timezone,
             iata,
             icao,
             scheduled
    }

    required convenience public init(from decoder: Decoder) throws {
        self.init(from: decoder, type: ArrivalEntity.self)

        let container = try decoder.container(keyedBy: CodingKeys.self)

        self.airport = try container.decode(String.self, forKey: .airport)
        self.timezone = try container.decode(String.self, forKey: .timezone)
        self.iata = try container.decode(String.self, forKey: .iata)
        self.icao = try container.decode(String.self, forKey: .icao)
        self.scheduled = try container.decode(String.self, forKey: .scheduled)
    }
}

extension ArrivalEntity {
    @nonobjc public class func fetchRequest() -> NSFetchRequest<ArrivalEntity> {
        return NSFetchRequest<ArrivalEntity>(entityName: "ArrivalEntity")
    }

    @NSManaged public var airport: String
    @NSManaged public var timezone: String
    @NSManaged public var iata: String
    @NSManaged public var icao: String
    @NSManaged public var scheduled: String
}

extension ArrivalEntity {
    public func toProxy() -> Arrival {
        Arrival(
            airport: airport,
            timezone: timezone,
            iata: iata,
            icao: icao,
            scheduled: scheduled
        )
    }
}
