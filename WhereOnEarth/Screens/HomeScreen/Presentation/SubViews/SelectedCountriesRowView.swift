//
//  SelectedCountriesRowView.swift
//  WhereOnEarth
//
//  Created by Amr Muhammad on 08/10/2025.
//

import SwiftUI

struct SelectedCountriesRowView: View {
    let country: Country
    let onDelete: () -> Void
    
    var body: some View {
        HStack(spacing: 12) {
            CountryFlagView(url: country.flags?.png ?? "")
                .frame(width: 40, height: 40)
            Text(country.name?.common ?? "")
                .font(.headline)
                .foregroundStyle(.main)
            
            Spacer()
            
            Button(action: onDelete) {
                AppResources.Assets.deleteIcon
                    .resizable()
                    .scaledToFit()
            }
            .frame(width: 20, height: 30)
        }
        .padding()
        .frame(maxWidth: .infinity, maxHeight: 60)
        .backgroundStyle(
            cornerRadius: 12,
            borderColor: .border,
            borderWidth: 1
        )
    }
}

#Preview {
    SelectedCountriesRowView(country: Country(flags: nil, name: nil, cca2: nil, currencies: nil, capital: nil, subregion: nil, languages: nil, population: nil, timezones: nil), onDelete: {})
}
