//
//  DefaultCountryView.swift
//  WhereOnEarth
//
//  Created by Amr Muhammad on 09/04/2026.
//

import SwiftUI

struct DefaultCountryView: View {
    @ObservedObject var viewModel: HomeViewModel
    
    var body: some View {
        VStack(spacing: 8) {
            HeaderTitleView(title: Constants.Localization.defaultCountry)
            
            HStack(spacing: 12) {
                let country = viewModel.defaultCountry
                CountryFlagView(url: country?.flags?.png ?? "")
                    .frame(width: 40, height: 40)
                VStack(alignment: .leading, spacing: 8) {
                    Text("\(Constants.Localization.country) \(country?.name?.common ?? "")")
                        .font(.callout)
                    Text("\(Constants.Localization.capital) \(country?.capital?.first ?? "")")
                        .font(.callout)
                    Text("\(Constants.Localization.currency) \(country?.currencies?.values.first?.combinedName ?? "")")
                        .font(.callout)
                }
                Spacer()
            }
            .padding()
            .frame(height: 100)
            .backgroundStyle(
                cornerRadius: 12,
                borderColor: .border,
                borderWidth: 1
            )
        }
        .onTapGesture {
            viewModel.selectedCountry = viewModel.defaultCountry
            viewModel.shouldNavigateToCountryDetail = true
        }
    }
}

#Preview {
    DefaultCountryView(viewModel: HomeViewModel())
}
