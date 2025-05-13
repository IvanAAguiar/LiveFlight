//
//  LiveFlightsApp.swift
//  LiveFlightsApp
//
//  Created by Ivan Aguiar on 05/05/2025.
//

import SwiftUI

@main
struct LiveFlightsApp: App {
    var body: some Scene {
        WindowGroup {
            MainView(viewModel: MainViewModel())
        }
    }
}
