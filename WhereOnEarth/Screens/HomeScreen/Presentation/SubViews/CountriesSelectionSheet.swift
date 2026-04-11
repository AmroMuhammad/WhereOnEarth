//
//  CountriesSelectionSheet.swift
//  WhereOnEarth
//
//  Created by Amr Muhammad on 10/04/2026.
//

import SwiftUI

struct CountriesSelectionSheet: View {
    @ObservedObject var viewModel: HomeViewModel
    @Environment(\.dismiss) private var dismiss

    var body: some View {
        VStack {
            HStack {
                Spacer()
                Button(Constants.Localization.done) {
                    viewModel.searchQuery = ""
                    dismiss()
                }.padding(20)
            }

            SearchTextFieldView(text: $viewModel.searchQuery)
                .padding(.horizontal)
            
            ScrollView {
                if viewModel.searchList.isEmpty {
                    Text(Constants.Localization.noSearchResults)
                        .foregroundStyle(.gray)
                        .padding(.top, 40)
                } else {
                    LazyVStack {
                        ForEach(viewModel.searchList) { item in
                            HStack {
                                CountryFlagView(url: item.flags?.png)
                                    .frame(width: 40, height: 40)
                                Text(item.name?.common ?? "")
                                Spacer()
                                viewModel.selectedCountriesList.contains(item) ? AppResources.Assets.checkIcon : AppResources.Assets.unCheckIcon
                            }
                            .padding(.vertical, 8)
                            .contentShape(Rectangle())
                            .onTapGesture {
                                viewModel.countrySelection(item)
                            }
                        }
                    }
                    .padding(.horizontal)
                }
            }
            
        }
        .hideKeyboardOnTap()
        .toast(isPresented: $viewModel.exceedMaxSelectedCountries, message: Constants.Localization.onlyFiveCountriesAllowed)
    }
}

#Preview {
    CountriesSelectionSheet(viewModel: HomeViewModel())
}
