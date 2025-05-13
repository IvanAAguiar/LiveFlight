//
//  FlightListView.swift
//  LiveFlights
//
//  Created by Ivan Aguiar on 11/05/2025.
//

import SwiftUI
import Combine

struct FlightListView<ViewModel: FlightListViewModelRepresentable>: View {
    
    //MARK: - Properties
    
    @ObservedObject var viewModel: ViewModel
    
    // MARK: - Init
    
    var body: some View {
        NavigationView {
            switch viewModel.state {
            case .loading:
                ProgressView(viewModel.loadingMessage)
            case .error(let errorViewModel):
                GenericErrorView(viewModel: errorViewModel)
            case .empty(let errorViewModel):
                GenericErrorView(viewModel: errorViewModel)
            case .success:
                content
            }
        }
        .navigationTitle(viewModel.screenTitle)
        .task {
            await viewModel.onAppear()
        }
        .onChange(of: viewModel.searchText) { _, newValue in
            Task {
                await viewModel.filterFlights(searchText: newValue)
            }
        }
    }
}

extension FlightListView {
    var content: some View {
        VStack {
            filterFieldView

            List {
                ForEach(viewModel.flights, id: \.self) { flight in
                    NavigationLink {
                        /// Add map view here
                    } label: {
                        FlightRowView(viewModel: FlightRowViewModel(flight: flight))
                    }
//                    .disabled(true) // TODO: - Remove when the map view is ready
                }
            }
        }
    }

    var filterFieldView: some View {
        TextField(viewModel.filterPlaceholder, text: $viewModel.searchText)
            .padding()
            .background(Color(.systemGray6))
            .cornerRadius(8)
            .padding(.horizontal)
    }
}

// MARK: - Previews

struct FlightListView_Previews: PreviewProvider {
    static var previews: some View {
        FlightListView(
            viewModel: FlightListViewModel(dependencies: .init(
                service: FlightsService(dependencies: .init(
                    repository: MockFlightsRepository(),
                    apiClient: AviationStackAPIClient()
                )),
                airline: Airline(
                    id: nil,
                    airlineId: "12",
                    iataCode: "AF",
                    iataIcao: nil,
                    airlineName: "Air France",
                    countryName: "France",
                    status: nil,
                    isFavorite: false
                )
            ))
        )
    }
}
