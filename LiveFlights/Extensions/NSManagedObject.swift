//
//  NSManagedObject.swift
//  LiveFlights
//
//  Created by Ivan Aguiar on 10/05/2025.
//

import Foundation
import CoreData

extension NSManagedObject {
    
    public var uniqueID: String {
        return objectID.uriRepresentation().absoluteString
    }
    
    public convenience init<T>(from decoder: Decoder, type: T) {
        guard
            let key = CodingUserInfoKey(rawValue: "context"),
            let context = decoder.userInfo[key] as? NSManagedObjectContext
        else { fatalError() }

        let entityName = String(describing: type)

        guard let entity = NSEntityDescription.entity(
            forEntityName: entityName,
            in: context
        ) else { fatalError() }
        
        self.init(entity: entity, insertInto: context)
    }
}
