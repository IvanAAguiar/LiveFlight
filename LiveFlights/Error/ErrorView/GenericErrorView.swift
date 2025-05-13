//
//  GenericErrorView.swift
//  LiveFlights
//
//  Created by Ivan Aguiar on 06/05/2025.
//

import SwiftUI

struct GenericErrorView: View {

    // MARK: - Properties

    var viewModel: any GenericErrorViewModelRepresentable

    var body: some View {
        VStack {
            Image(viewModel.systemImageName)
                .resizable()
                .aspectRatio(contentMode: .fit)
                .padding(16)

            VStack {
                Text(viewModel.errorTitle)
                    .font(.title)
                    .padding(.bottom, 16)

                Text(viewModel.errorMessage)
                    .font(.headline)
                    .multilineTextAlignment(.center)
                    .padding(.horizontal)
                    .padding(.bottom)
            }
            .multilineTextAlignment(.center)

            if !viewModel.isRetryButtonHidden {
                Button {
                    viewModel.retry()
                } label: {
                    Text(viewModel.buttonTitle)
                        .font(.title3)
                        .padding()
                        .background(Color.blue)
                        .foregroundColor(.white)
                        .cornerRadius(8)
                }
                .padding(.vertical, 24)
            }
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(Color(.systemBackground))
        .edgesIgnoringSafeArea(.all)
    }
}

// MARK: - Previews

struct ErrorView_Previews: PreviewProvider {
    static var previews: some View {
        GenericErrorView(viewModel: GenericErrorViewModel(
            retryAction: {
                print("Retry button pressed in Preview")
            }
        ))
    }
}
