//
//  AirlineEntity + CoreData.swift
//  LiveFlights
//
//  Created by Ivan Aguiar on 10/05/2025.
//

import CoreData
import Foundation

@objc(AirlineEntity)
public class AirlineEntity: NSManagedObject, Decodable {
    enum CodingKeys: String, CodingKey {
        case id
        case airlineID = "airlineId"
        case iataCode = "iataCode"
        case iataIcao = "iataIcao"
        case airlineName = "airlineName"
        case countryName = "countryName"
        case status = "status"
        case isFavorite = "isFavorite"
    }
    
    required convenience public init(from decoder: Decoder) throws {
        self.init(from: decoder, type: AirlineEntity.self)

        let container = try decoder.container(keyedBy: CodingKeys.self)

        self.id = try container.decodeIfPresent(String.self, forKey: .id)
        self.airlineId = try container.decodeIfPresent(String.self, forKey: .airlineID)
        self.iataCode = try container.decodeIfPresent(String.self, forKey: .iataCode)
        self.iataIcao = try container.decodeIfPresent(String.self, forKey: .iataIcao)
        self.airlineName = try container.decodeIfPresent(String.self, forKey: .airlineName)
        self.countryName = try container.decodeIfPresent(String.self, forKey: .countryName)
        self.status = try container.decodeIfPresent(String.self, forKey: .status)
        self.isFavorite = try container.decodeIfPresent(Bool.self, forKey: .isFavorite) ?? false
    }
}

extension AirlineEntity {
    @nonobjc public class func fetchRequest() -> NSFetchRequest<AirlineEntity> {
        return NSFetchRequest<AirlineEntity>(entityName: "AirlineEntity")
    }

    @NSManaged public var id: String?
    @NSManaged public var airlineId: String?
    @NSManaged public var iataCode: String?
    @NSManaged public var iataIcao: String?
    @NSManaged public var airlineName: String?
    @NSManaged public var countryName: String?
    @NSManaged public var status: String?
    @NSManaged public var isFavorite: Bool
}

extension AirlineEntity {
    public func toProxy() -> Airline {
        Airline(
            id: id,
            airlineId: airlineId,
            iataCode: iataCode,
            iataIcao: iataIcao,
            airlineName: airlineName,
            countryName: countryName,
            status: status,
            isFavorite: isFavorite
        )
    }
}
