//
//  FlightRowView.swift
//  LiveFlights
//
//  Created by Ivan Aguiar on 12/05/2025.
//

import SwiftUI

struct FlightRowView<ViewModel: FlightRowViewModelRepresentable>: View {
    
    // MARK: - Properties

    @ObservedObject var viewModel: ViewModel

    // MARK: - Body

    var body: some View {
        VStack(alignment: .leading) {
            HStack {
                Text(viewModel.flightName)
                    .font(.headline)

                Text(viewModel.flightNumber)

                Spacer()
                Text(viewModel.flightStatus)
                    .font(.subheadline)
                    .foregroundColor(viewModel.flightStatusColor)
            }
            Divider()
            HStack {
                VStack(alignment: .leading) {
                    Text(viewModel.departureText)
                        .font(.caption)
                    Text(viewModel.flightDeparture)
                        .font(.subheadline)
                    if let scheduled = viewModel.flightDepartureScheduledDateText {
                        HStack {
                            Text(viewModel.scheduledText)
                            Text(scheduled)
                        }
                            .font(.caption2)
                    }
                }
                Spacer()
                VStack(alignment: .trailing) {
                    Text(viewModel.arrivalText)
                        .font(.caption)
                    Text(viewModel.flightArrival)
                        .font(.subheadline)
                    if let scheduled = viewModel.flightArrivalScheduledDateText {
                        HStack {
                            Text(viewModel.scheduledText)
                            Text(scheduled)
                        }
                            .font(.caption2)
                    }
                }
            }
        }
    }
}

#Preview {
    FlightRowView(
        viewModel: FlightRowViewModel(flight: Flight(
            flightDate: "2025-05-12",
            flightStatus: "scheduled",
            departure: Departure(
                airport: "Guangzhou Baiyun International",
                timezone: "Asia/Makassar",
                iata: "UPG",
                icao: "WAAA",
                scheduled: "2025-05-12T03:45:00+00:00",
                estimated: "2025-05-12T03:45:00+00:00"
            ),
            arrival: Arrival(
                airport: "Ninoy Aquino International",
                timezone: "Asia/Manila",
                iata: "MNL",
                icao: "RPLL",
                scheduled: "2025-05-12T06:55:00+00:00"
            ),
            airline: AirlineReference(
                name: "Cebu Pacific Air",
                iata: "5J",
                icao: "CEB"
            ),
            flight: FlightDetails(
                number: "309",
                iata: "5J309",
                icao: "CEB309",
                codeshared: nil
            ),
            isFavorite: false
        ))
    )
}
