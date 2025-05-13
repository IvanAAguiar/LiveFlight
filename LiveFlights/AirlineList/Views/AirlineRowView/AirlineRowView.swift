//
//  AirlineRowView.swift
//  LiveFlights
//
//  Created by Ivan Aguiar on 08/05/2025.
//

import SwiftUI

struct AirlineRowView<ViewModel: AirlineRowViewModelRepresentable>: View {

    // MARK: - Properties

    @ObservedObject var viewModel: ViewModel

    // MARK: - Body

    var body: some View {
        HStack {
            Image(systemName: viewModel.favoriteIcon)
                .foregroundStyle(viewModel.isAirlineSaved ? Color.red : Color.primary)
                .onTapGesture {
                    viewModel.saveButtonTapped()
                }
            
            VStack(alignment: .leading) {
                Text(viewModel.name)
                    .font(.headline)
                    .foregroundStyle(.primary)
                Text(viewModel.iataCode)
                    .font(.subheadline)
                    .foregroundStyle(.primary)
                Text(viewModel.countryName)
                    .font(.caption)
                    .foregroundStyle(.secondary)
            }
        }
    }
}

//MARK: - Previews

struct AirlineRowView_Previews: PreviewProvider {
    static var previews: some View {
        AirlineRowView(viewModel: AirlineRowViewModel(
            airline: Airline(
                id: "4597464",
                airlineId: "14",
                iataCode: "BA",
                iataIcao: nil,
                airlineName: "British Airways",
                countryName: "United Kingdom",
                status: "inactive",
                isFavorite: false
            ),
            onSaveAction: { _ in return true },
            onDeleteAction: { _ in return true }
        ))
    }
}

