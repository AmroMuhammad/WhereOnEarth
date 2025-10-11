//
//  CountriesRowView.swift
//  WhereOnEarth
//
//  Created by Amr Muhammad on 08/10/2025.
//

import SwiftUI

struct CountriesRowView: View {
    let country: Country
    let onDelete: () -> Void
    
    var body: some View {
        HStack(spacing: 12) {
            CountryFlagView(url: country.flag)
                .frame(width: 40, height: 40)
            Text(country.name)
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
    CountriesRowView(country: Constants.dummyCountry, onDelete: {})
}
