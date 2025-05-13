//
//  DepartureEntity + CoreData.swift
//  LiveFlights
//
//  Created by Ivan Aguiar on 11/05/2025.
//

import CoreData
import Foundation

@objc(DepartureEntity)
public class DepartureEntity: NSManagedObject, Decodable {
    enum CodingKeys: String, CodingKey {
            case airport,
                 timezone,
                 iata,
                 icao,
                 scheduled,
                 estimated
        }

    required convenience public init(from decoder: Decoder) throws {
        self.init(from: decoder, type: DepartureEntity.self)

        let container = try decoder.container(keyedBy: CodingKeys.self)

        self.airport = try container.decode(String.self, forKey: .airport)
        self.timezone = try container.decode(String.self, forKey: .timezone)
        self.iata = try container.decode(String.self, forKey: .iata)
        self.icao = try container.decode(String.self, forKey: .icao)
        self.scheduled = try container.decode(String.self, forKey: .scheduled)
        self.estimated = try container.decodeIfPresent(String.self, forKey: .estimated)
    }
}

extension DepartureEntity {
    @nonobjc public class func fetchRequest() -> NSFetchRequest<DepartureEntity> {
        return NSFetchRequest<DepartureEntity>(entityName: "DepartureEntity")
    }
    
    @NSManaged public var airport: String
    @NSManaged public var timezone: String
    @NSManaged public var iata: String
    @NSManaged public var icao: String
    @NSManaged public var scheduled: String
    @NSManaged public var estimated: String?
}

extension DepartureEntity {
    public func toProxy() -> Departure {
        Departure(
            airport: airport,
            timezone: timezone,
            iata: iata,
            icao: icao,
            scheduled: scheduled,
            estimated: estimated
        )
    }
}
