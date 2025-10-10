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
                CountryFlagView(url: country.flag)
                    .frame(maxWidth: .infinity, maxHeight: 200)
                Spacer().frame(height: 20)
                CountryCardGridView(country: country)
                Spacer()
            }
            .padding(16)
            .navigationTitle(Text(Constants.Localization.countryDetails))
        }
    }
}

#Preview {
    CountryDetailsView(country: Constants.dummyCountry)
}
