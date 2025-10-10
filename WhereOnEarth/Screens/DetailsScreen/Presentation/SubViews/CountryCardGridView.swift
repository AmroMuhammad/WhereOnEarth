//
//  CountryCardGridView.swift
//  WhereOnEarth
//
//  Created by Amr Muhammad on 11/10/2025.
//

import SwiftUI

struct CountryCardGridView: View {
    let country: Country

    var body: some View {
        LazyVGrid(columns: [GridItem(.flexible()), GridItem(.flexible())], spacing: 16) {
            ForEach(Array(zip(cardData.indices, cardData)), id: \.0) { index, card in
                CountryInfoCard(
                    icon: card.icon,
                    label: card.label,
                    value: card.value,
                    backgroundColor: cardColors[index]
                )
            }
        }
        .padding()
    }

    private var cardData: [(icon: String, label: String, value: String)] {
        [
            (
                AppResources.Assets.globe,
                Constants.Localization.country,
                country.name?.common ?? "-"
            ),
            (
                AppResources.Assets.capitalLogo,
                Constants.Localization.capital,
                country.capital?.first ?? "-"
            ),
            (
                AppResources.Assets.currencyLogo,
                Constants.Localization.currency,
                country.currencies?.values.first?.name ?? "-"
            ),
            (
                AppResources.Assets.languageLogo,
                Constants.Localization.language,
                country.languages?.values.first ?? "-"
            )
        ]
    }

    private var cardColors: [Color] {
        [.blue, .green, .orange, .purple]
    }
}

#Preview {
    CountryCardGridView(country: Country(
        flags: nil,
        name: Name(
            common: "Egypt",
            official: "Egypt",
            nativeName: nil
        ),
        cca2: nil,
        currencies: ["" : Currency(name: "Pound", symbol: "LE")],
        capital: ["Cairo"],
        subregion: nil,
        languages: ["": "Arabic"],
        population: nil,
        timezones: nil
    ))
}
