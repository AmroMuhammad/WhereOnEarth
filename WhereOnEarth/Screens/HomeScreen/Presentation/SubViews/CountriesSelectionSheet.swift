//
//  CountriesSelectionSheet.swift
//  WhereOnEarth
//
//  Created by Amr Muhammad on 09/10/2025.
//

import SwiftUI

struct CountriesSelectionSheet: View {
    @ObservedObject var viewModel:HomeViewModel
    @State private var searchQuery = ""
    @Environment(\.dismiss) private var dismiss
    
    var body: some View {
        VStack{
            HStack{
                Spacer()
                Button(Constants.Localization.done) {
                    viewModel.saveSelectedCountries()
                    searchQuery = ""
                    dismiss()
                }.padding(20)
            }
            
            SearchTextFieldView(text: $searchQuery)
                .padding(.horizontal)
            
            ScrollView {
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
        .hideKeyboardOnTap()
        .onChange(of: searchQuery){  _, newValue in
            viewModel.searchQuery = newValue
        }
        .toast(isPresented: $viewModel.exceedMaxSelectedCountries, message: Constants.Localization.onlyFiveCountriesAllowed)
    }
}

#Preview {
    CountriesSelectionSheet(viewModel: HomeViewModel())
}
