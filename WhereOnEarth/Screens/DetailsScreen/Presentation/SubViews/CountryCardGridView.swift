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
                country.name
            ),
            (
                AppResources.Assets.capitalLogo,
                Constants.Localization.capital,
                country.capital
            ),
            (
                AppResources.Assets.currencyLogo,
                Constants.Localization.currency,
                country.currency.compinedName
            ),
            (
                AppResources.Assets.languageLogo,
                Constants.Localization.language,
                country.language
            )
        ]
    }

    private var cardColors: [Color] {
        [.blue, .green, .orange, .purple]
    }
}

#Preview {
    CountryCardGridView(country: Constants.dummyCountry)
}
