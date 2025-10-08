//
//  DefaultCountryView.swift
//  WhereOnEarth
//
//  Created by Amr Muhammad on 08/10/2025.
//

import SwiftUI

struct DefaultCountryView: View {
    var body: some View {
        VStack(spacing: 8) {
            HeaderTitleView(title: Constants.Localization.defaultCountry)
            
            HStack(spacing: 12) {
                CountryFlagView(url: "https://flagcdn.com/w320/lt.png")
                    .frame(width: 40, height: 40)
                VStack(alignment: .leading, spacing: 8) {
                    Text("\(Constants.Localization.country) Egypt")
                        .font(.callout)
                    Text("\(Constants.Localization.capital) Cairo")
                        .font(.callout)
                    Text("\(Constants.Localization.currency) Pound")
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
    }
}

#Preview {
    DefaultCountryView()
}
