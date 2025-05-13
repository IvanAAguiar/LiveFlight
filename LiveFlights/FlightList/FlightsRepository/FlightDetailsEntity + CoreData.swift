//
//  FlightDetailsEntity + CoreData.swift
//  LiveFlights
//
//  Created by Ivan Aguiar on 11/05/2025.
//

import CoreData
import Foundation

@objc(FlightDetailsEntity)
public class FlightDetailsEntity: NSManagedObject, Decodable {
    enum CodingKeys: String, CodingKey {
        case number, iata, icao, codeshared
    }

    required convenience public init(from decoder: Decoder) throws {
        self.init(from: decoder, type: FlightDetailsEntity.self)

        let container = try decoder.container(keyedBy: CodingKeys.self)

        self.number = try container.decode(String.self, forKey: .number)
        self.iata = try container.decode(String.self, forKey: .iata)
        self.icao = try container.decode(String.self, forKey: .icao)
        self.codeshared = try container.decode(CodesharedEntity.self, forKey: .codeshared)
    }
}

extension FlightDetailsEntity {
    @nonobjc public class func fetchRequest() -> NSFetchRequest<FlightDetailsEntity> {
        return NSFetchRequest<FlightDetailsEntity>(entityName: "FlightDetailsEntity")
    }
    
    @NSManaged public var number: String
    @NSManaged public var iata: String
    @NSManaged public var icao: String
    @NSManaged public var codeshared: CodesharedEntity?
}

extension FlightDetailsEntity {
    public func toProxy() -> FlightDetails {
        FlightDetails(
            number: number,
            iata: iata,
            icao: icao,
            codeshared: codeshared?.toProxy()
        )
    }
}
