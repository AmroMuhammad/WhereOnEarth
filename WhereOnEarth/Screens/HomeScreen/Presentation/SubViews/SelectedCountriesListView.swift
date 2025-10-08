//
//  SelectedCountriesListView.swift
//  WhereOnEarth
//
//  Created by Amr Muhammad on 08/10/2025.
//

import SwiftUI

let dummyList = [Country(flags: Flags(png: "https://flagcdn.com/w320/lt.png", svg: nil, alt: nil), name: Name(common: "Litho", official: "Litho", nativeName: nil), cca2: nil, currencies: ["Euro": Currency(name: "hello", symbol: "$")], capital: nil, subregion: nil, languages: nil, population: nil, timezones: nil)
]
struct SelectedCountriesListView: View {
    var body: some View {
        VStack(spacing: 8) {
            HeaderTitleView(title: Constants.Localization.selectedCountries)
            ScrollView{
                VStack(spacing: 12) {
                    ForEach(dummyList, id: \.self) { item in
                        SelectedCountriesRowView(
                            country: item
                        )
                    }
                }
            }
        }
    }
}

#Preview {
    SelectedCountriesListView()
}
