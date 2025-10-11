//
//  CountriesListView.swift
//  WhereOnEarth
//
//  Created by Amr Muhammad on 08/10/2025.
//

import SwiftUI

struct CountriesListView: View {
    @ObservedObject var viewModel: HomeViewModel
    @EnvironmentObject var popupPresent: PopupPresent

    var body: some View {
        VStack {
            HeaderTitleView(title: Constants.Localization.selectedCountries)
            ScrollView{
                VStack(spacing: 12) {
                    if viewModel.selectedCountriesList.isEmpty {
                        Spacer()
                        AppResources.Assets.emptyList
                            .resizable()
                            .frame(width: 200, height: 200)
                        Text(Constants.Localization.addUpToCountries)
                            .font(.title3)
                            .foregroundStyle(.black)
                            .multilineTextAlignment(.center)
                        Spacer()
                        
                    } else {
                        ForEach(viewModel.selectedCountriesList, id: \.self) { item in
                            CountriesRowView(
                                country: item,
                                onDelete: {
                                    presentConfirmationPopup(item: item)
                                }
                            )
                            .onTapGesture {
                                viewModel.selectedCountry = item
                                viewModel.shouldNavigateToCountryDetail = true
                            }
                        }
                        
                    }
                }
            }
            .frame(maxWidth: .infinity, maxHeight: 380)
            .padding()
            .backgroundStyle(
                cornerRadius: 12,
                borderColor: .border,
                borderWidth: 1
            )
        }
        
    }
}

extension CountriesListView {
    private func presentConfirmationPopup(item: Country) {
        self.popupPresent.popupView.content = {
            AnyView(
                CustomDialog(
                    icon: nil,
                    title: Constants.Localization.alertDeleteConfirmation,
                    message: Constants.Localization.alertDeleteDescription,
                    primaryButtonTitle: Constants.Localization.delete,
                    primaryAction: {
                        viewModel.deleteCountry(item)
                        popupPresent.isPopupPresented = false
                    },
                    secondaryButtonTitle: Constants.Localization.cancel,
                    secondaryAction: {
                        popupPresent.isPopupPresented = false
                    }
                )
            )
        }
        popupPresent.isPopupPresented = true
    }
}

#Preview {
    CountriesListView(viewModel: HomeViewModel())
}
