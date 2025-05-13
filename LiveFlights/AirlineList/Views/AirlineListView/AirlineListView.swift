//
//  AirlineListView.swift
//  LiveFlights
//
//  Created by Ivan Aguiar on 05/05/2025.
//

import SwiftUI

struct AirlineListView<ViewModel: AirlineListViewModelRepresentable>: View {

    // MARK: - Properties

    @ObservedObject var viewModel: ViewModel

    // MARK: - Body

    var body: some View {
        VStack {
            switch viewModel.state {
            case .loading:
                ProgressView(viewModel.loadingMessage)
            case .failure(let errorViewModel):
                GenericErrorView(viewModel: errorViewModel)
            case .empty(let emptyViewModel):
                GenericErrorView(viewModel: emptyViewModel)
            case .success:
                createContent()
            }
        }
        .navigationTitle(viewModel.screenTitle)
        .navigationBarTitleDisplayMode(.large)
        .task { await viewModel.onAppear() }
        .onChange(of: viewModel.searchText) { _, newValue in
            Task {
                await viewModel.filterAirlines(searchText: newValue)
            }
        }
    }
}

// MARK: - Views

extension AirlineListView {
    func createContent() -> some View {
        let apiClient = AviationStackAPIClient()
        let coreDataManager = CoreDataManager.shared

        let airlineService = AirlinesService(
            dependencies: .init(
                repository: AirlinesRepository(),
                apiClient: apiClient
            )
        )

        let flightsRepository = FlightsRepository(
            dependencies: .init(
                airlineService: airlineService,
                coreDataManager: coreDataManager
            )
        )

        let flightsService = FlightsService(dependencies: .init(
            repository: flightsRepository,
            apiClient: apiClient
        ))

        return VStack {
            filterFieldView

            List(viewModel.airlinesToShown) { airline in
                NavigationLink {
                    FlightListView(viewModel: FlightListViewModel(dependencies: .init(
                        service: flightsService,
                        airline: airline
                    )))
                } label: {
                    AirlineRowView(viewModel: AirlineRowViewModel(
                        airline: airline,
                        onSaveAction: viewModel.saveAirline,
                        onDeleteAction: viewModel.deleteAirline
                    ))
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

struct AirlineListView_Previews: PreviewProvider {
    static var previews: some View {
        AirlineListView(
            viewModel: AirlineListViewModel(
                dependencies: .init(
                    service: MockAirlinesService(),
                    favoritesService: MockFavoritesService()
                )
            )
        )
    }
}
