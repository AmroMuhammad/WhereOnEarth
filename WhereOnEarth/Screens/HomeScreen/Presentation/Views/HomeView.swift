//
//  HomeView.swift
//  WhereOnEarth
//
//  Created by Amr Muhammad on 08/10/2025.
//

import SwiftUI

struct HomeView: View {
    @StateObject var viewModel: HomeViewModel = HomeViewModel()
    @State var openCountryPicker: Bool = false

    var body: some View {
        VStack(spacing: 20) {
            SearchView()
            DefaultCountryView(viewModel: viewModel)
            SelectedCountriesListView(viewModel: viewModel)
            AddCountryButton(openCountryPicker: $openCountryPicker)
        }
        .padding(16)
        .oneTimeCalling{
            viewModel.getAllCountries()
        }
        .sheet(isPresented: $openCountryPicker) {
            if !viewModel.allCountries.isEmpty{
                CountriesSelectionSheet(viewModel: viewModel)
            }else{
                NoConnectionView()
            }
        }
    }
}

#Preview {
    HomeView()
}
