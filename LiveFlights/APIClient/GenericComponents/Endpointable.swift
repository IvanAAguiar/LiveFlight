//
//  Endpointable.swift
//  LiveFlights
//
//  Created by Ivan Aguiar on 10/05/2025.
//

import Foundation

protocol Endpointable {
    var path: String { get }
//    var method: HTTPMethods { get }
    var basePath: String { get }
    var queryItems: [URLQueryItem] { get }
}
