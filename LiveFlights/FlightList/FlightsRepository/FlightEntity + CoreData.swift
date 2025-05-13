//
//  FlightEntity + CoreData.swift
//  LiveFlights
//
//  Created by Ivan Aguiar on 11/05/2025.
//

import CoreData
import Foundation

@objc(FlightEntity)
public class FlightEntity: NSManagedObject, Decodable {
    enum CodingKeys: String, CodingKey {
        case flightDate = "flight_date"
        case flightStatus = "flight_status"
        case id,
             departure,
             arrival,
             airline,
             flight,
             isFavorite
    }
    
    required convenience public init(from decoder: Decoder) throws {
        self.init(from: decoder, type: AirlineEntity.self)

        let container = try decoder.container(keyedBy: CodingKeys.self)

        self.id = try container.decode(UUID.self, forKey: .id)
        self.flightDate = try container.decode(String.self, forKey: .flightDate)
        self.flightStatus = try container.decode(String.self, forKey: .flightStatus)
        self.departure = try container.decode(DepartureEntity.self, forKey: .departure)
        self.arrival = try container.decode(ArrivalEntity.self, forKey: .arrival)
        self.airline = try container.decode(AirlineEntity.self, forKey: .airline)
        self.flight = try container.decode(FlightDetailsEntity.self, forKey: .airline)
        self.isFavorite = try container.decodeIfPresent(Bool.self, forKey: .isFavorite) ?? false
    }
}

extension FlightEntity {
    @nonobjc public class func fetchRequest() -> NSFetchRequest<FlightEntity> {
        return NSFetchRequest<FlightEntity>(entityName: "FlightEntity")
    }

    @NSManaged public var id: UUID
    @NSManaged public var flightDate: String
    @NSManaged public var flightStatus: String
    @NSManaged public var departure: DepartureEntity
    @NSManaged public var arrival: ArrivalEntity
    @NSManaged public var airline: AirlineEntity
    @NSManaged public var flight: FlightDetailsEntity
    @NSManaged public var isFavorite: Bool
}

extension FlightEntity {
    public func toProxy() -> Flight {
        Flight(
            flightDate: flightDate,
            flightStatus: flightStatus,
            departure: departure.toProxy(),
            arrival: arrival.toProxy(),
            airline: AirlineReference(
                name: airline.airlineName ?? "",
                iata: airline.iataCode ?? "",
                icao: airline.iataIcao ?? ""
            ),
            flight: flight.toProxy(),
            isFavorite: isFavorite
        )
    }
}
