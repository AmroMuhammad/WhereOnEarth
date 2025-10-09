//
//  SelectedCountriesListView.swift
//  WhereOnEarth
//
//  Created by Amr Muhammad on 08/10/2025.
//

import SwiftUI

struct SelectedCountriesListView: View {
    @ObservedObject var viewModel: HomeViewModel
    
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
                            SelectedCountriesRowView(
                                country: item
                            )
                            .onTapGesture {
                                viewModel.selectedCountry = item
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

#Preview {
    SelectedCountriesListView(viewModel: HomeViewModel())
}
