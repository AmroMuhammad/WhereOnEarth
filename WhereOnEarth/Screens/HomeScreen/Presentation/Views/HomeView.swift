//
//  HomeView.swift
//  WhereOnEarth
//
//  Created by Amr Muhammad on 09/04/2026.
//

import SwiftUI

struct HomeView: View {
    @StateObject var viewModel: HomeViewModel = HomeViewModel()
    @State var openCountryPicker: Bool = false
    @EnvironmentObject var loading: Loading
    @EnvironmentObject var popupPresent: PopupPresent
    @EnvironmentObject var navigationManager: NavigationManager

    var body: some View {
        VStack(spacing: 20) {
            SearchView()
            DefaultCountryView(viewModel: viewModel)
            SelectedCountriesListView(viewModel: viewModel)
            AddCountryButton(openCountryPicker: $openCountryPicker)
        }
        .padding(16)
        .oneTimeCalling {
            viewModel.getAllCountries()
        }
        .onChange(of: viewModel.state) { _, newState in
            switch newState {
                case .loading:
                    loading.isLoading = true
                case .loaded:
                    loading.isLoading = false
                case .failed:
                    loading.isLoading = false
                    presentErrorPopup()
                case .idle:
                    break
            }
        }
        .onReceive(viewModel.$shouldNavigateToCountryDetail, perform: { shouldNavigate in
            guard shouldNavigate,
                  let selectedCountry = viewModel.selectedCountry else { return }
            navigationManager.navigate(to: .countryDetail(selectedCountry))
        })
        .sheet(isPresented: $openCountryPicker) {
            if !viewModel.allCountries.isEmpty{
                CountriesSelectionSheet(viewModel: viewModel)
            }else{
                NoConnectionView()
            }
        }
    }
}

extension HomeView {
    private func presentErrorPopup() {
        let message: String
        if case .failed(let msg) = viewModel.state {
            message = msg
        } else {
            message = ""
        }
        popupPresent.popupView.content = {
            AnyView(
                CustomDialog(
                    icon: AppResources.Assets.errorIcon,
                    title: Constants.Localization.error,
                    message: message,
                    primaryButtonTitle: Constants.Localization.retry,
                    primaryAction: {
                        viewModel.getAllCountries()
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
    HomeView()
        .environmentObject(Loading())
        .environmentObject(NavigationManager())
}
