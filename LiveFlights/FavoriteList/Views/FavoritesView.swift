//
//  FavoritesView.swift
//  LiveFlights
//
//  Created by Ivan Aguiar on 10/05/2025.
//

import SwiftUI

struct FavoritesView<ViewModel: FavoritesViewModelRepresentable>: View {
    
    // MARK: - Properties
    
    @ObservedObject var viewModel: ViewModel
    
    // MARK: - Body
    
    var body: some View {
        NavigationStack {
            switch viewModel.state {
            case .failure(let errorViewModel):
                GenericErrorView(viewModel: errorViewModel)
            case .empty(let emptyViewModel):
                GenericErrorView(viewModel: emptyViewModel)
            case .success:
                List {
                    ForEach($viewModel.airlines, id: \.self) { airline in
                        HStack {
                            Text(airline.id ?? "Unknown")
                            Spacer()
                            Button(action: {
                                viewModel.deleteFavorite(airline.wrappedValue)
                            }) {
                                Image(systemName: "heart.fill")
                                    .foregroundColor(.red)
                            }
                        }
                    }
                }
            }
        }
        .navigationTitle("Favorite Airlines")
        .onAppear(perform: viewModel.loadFavoriteAirlines)
    }
}

// MARK: - Previews

struct FavoriteAirlineView_Previews: PreviewProvider {
    static var previews: some View {
        FavoritesView(viewModel: FavoritesViewModel(dependencies: .init(service: MockFavoritesService())))
    }
}
