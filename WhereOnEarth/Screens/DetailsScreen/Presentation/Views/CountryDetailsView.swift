//
//  CountryDetailsView.swift
//  WhereOnEarth
//
//  Created by Amr Muhammad on 10/10/2025.
//

import SwiftUI

struct CountryDetailsView: View {
    
    let country: Country
        
    var body: some View {
        ZStack {
            Color(.white)
                .ignoresSafeArea()
            VStack {
                CountryFlagView(url: country.flags?.png)
                    .frame(maxWidth: .infinity, maxHeight: 200)
                Spacer().frame(height: 20)
                CountryCardGridView(country: country)
                Spacer()
            }
            .padding(16)
        }
    }
}

#Preview {
    CountryDetailsView(country: Country(
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
