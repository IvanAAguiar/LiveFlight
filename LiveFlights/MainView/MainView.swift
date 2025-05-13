//
//  MainView.swift
//  LiveFlights
//
//  Created by Ivan Aguiar on 09/05/2025.
//

import SwiftUI

struct MainView<ViewModel: MainViewModelRepresentable>: View {
    
    // MARK: - Properties

    @ObservedObject var viewModel: ViewModel

    // MARK: - Body

    var body: some View {
        TabView(selection: $viewModel.selectedTab) {
            airlinesView
            favoritesView
            mapView
        }
    }
}

// MARK: - AirlinesView

extension MainView {
    var airlinesView: some View {
        NavigationView {
            AirlineListView(
                viewModel: AirlineListViewModel(
                    dependencies: .init(
                        service: AirlinesService(
                            dependencies: .init(
                                repository: AirlinesRepository(),
                                apiClient:  AviationStackAPIClient()
                            )
                        ),
                        favoritesService: FavoritesService(
                            dependencies: .init(
                                repository: FavoritesRepository()
                            )
                        )
                    )
                )
            )
        }
        .tabItem {
            Label(viewModel.airplaneTitle, systemImage: viewModel.airplaneIcon)
        }
        .tag(AppTab.airlines)
    }
}

// MARK: - FavoritesView

extension MainView {
    var favoritesView: some View {
        NavigationView {
            FavoritesView(
                viewModel: FavoritesViewModel(
                    dependencies: .init(service: FavoritesService(
                        dependencies: .init(
                            repository: FavoritesRepository())
                    ))
                )
            )
            .navigationTitle("Favorites")
        }
        .tabItem {
            Label(viewModel.favoriteTitle, systemImage: viewModel.favoriteIcon)
        }
        .tag(AppTab.favorites)
    }
}

// MARK: - MapView

extension MainView {
    var mapView: some View {
        NavigationView {
            // TODO: - Create Map View
        }
        .tabItem {
            Label(viewModel.mapTitle, systemImage: viewModel.mapIcon)
        }
        .tag(AppTab.map)
    }
}

// MARK: - Previews
#Preview {
    MainView(viewModel: MainViewModel())
}
