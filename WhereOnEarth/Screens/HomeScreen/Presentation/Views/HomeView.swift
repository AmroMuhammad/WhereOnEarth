//
//  HomeView.swift
//  WhereOnEarth
//
//  Created by Amr Muhammad on 08/10/2025.
//

import SwiftUI

struct HomeView: View {
    @StateObject var viewModel: HomeViewModel = HomeViewModel()
    @EnvironmentObject var loading: Loading
    @EnvironmentObject var popupPresent: PopupPresent
    @EnvironmentObject var navigationManager: NavigationManager

    @State var openCountryPicker: Bool = false

    var body: some View {
        VStack(spacing: 20) {
            HeaderTitleView(title: Constants.Localization.appName, isLargeTitle: true, titleColor: .main)
            DefaultCountryView(viewModel: viewModel)
            CountriesListView(viewModel: viewModel)
            AddCountryButton(openCountryPicker: $openCountryPicker)
        }
        .padding(16)
        .oneTimeCalling{
            loading.isLoading = true
            viewModel.getAllCountries()
            viewModel.loadCachedCountries()
        }
        .onReceive(viewModel.$isSuccess) { value in
            guard value ?? false else { return }
            loading.isLoading = false
        }
        .onReceive(viewModel.$showError) { showError in
            guard showError ?? false else {return}
            
            loading.isLoading = false
            presentErrorPopup()
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
        popupPresent.popupView.content = {
            AnyView(
                CustomDialog(
                    icon: AppResources.Assets.errorIcon,
                    title: Constants.Localization.error,
                    message: viewModel.errorMessage,
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
