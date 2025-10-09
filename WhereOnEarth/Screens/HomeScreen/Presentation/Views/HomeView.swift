//
//  HomeView.swift
//  WhereOnEarth
//
//  Created by Amr Muhammad on 08/10/2025.
//

import SwiftUI

struct HomeView: View {
    @StateObject var viewModel: HomeViewModel = HomeViewModel()
    
    var body: some View {
        VStack(spacing: 20) {
            SearchView()
            DefaultCountryView()
            SelectedCountriesListView()
            AddCountryButton()
        }
        .padding(16)
        .oneTimeCalling{
            viewModel.getAllCountries()
        }
    }
}

#Preview {
    HomeView()
}
