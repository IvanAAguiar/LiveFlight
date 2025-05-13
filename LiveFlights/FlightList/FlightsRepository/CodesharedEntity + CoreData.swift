//
//  CodesharedEntity + CoreData.swift
//  LiveFlights
//
//  Created by Ivan Aguiar on 12/05/2025.
//

import CoreData
import Foundation

@objc(CodesharedEntity)
public class CodesharedEntity: NSManagedObject, Decodable {
    enum CodingKeys: String, CodingKey {
        case airlineName,
             airlineIata,
             airlineIcao,
             flightNumber,
             flightIata,
             flightIcao
    }

    required convenience public init(from decoder: Decoder) throws {
        self.init(from: decoder, type: CodesharedEntity.self)

        let container = try decoder.container(keyedBy: CodingKeys.self)

        self.airlineName = try container.decode(String.self, forKey: .airlineName)
        self.airlineIata = try container.decode(String.self, forKey: .airlineIata)
        self.airlineIcao = try container.decode(String.self, forKey: .airlineIcao)
        self.flightNumber = try container.decode(String.self, forKey: .flightNumber)
        self.flightIata = try container.decode(String.self, forKey: .flightIata)
        self.flightIcao = try container.decode(String.self, forKey: .flightIcao)
    }
}

extension CodesharedEntity {
    @nonobjc public class func fetchRequest() -> NSFetchRequest<CodesharedEntity> {
        return NSFetchRequest<CodesharedEntity>(entityName: "CodesharedEntity")
    }
    
    @NSManaged public var airlineName: String
    @NSManaged public var airlineIata: String
    @NSManaged public var airlineIcao: String
    @NSManaged public var flightNumber: String
    @NSManaged public var flightIata: String
    @NSManaged public var flightIcao: String
}

extension CodesharedEntity {
    public func toProxy() -> Codeshared {
        Codeshared(
            airlineName: airlineName,
            airlineIata: airlineIata,
            airlineIcao: airlineIcao,
            flightNumber: flightNumber,
            flightIata: flightIata,
            flightIcao: flightIcao
        )
    }
}
