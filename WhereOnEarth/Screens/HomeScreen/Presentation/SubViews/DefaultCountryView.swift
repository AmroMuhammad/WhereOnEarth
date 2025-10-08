//
//  DefaultCountryView.swift
//  WhereOnEarth
//
//  Created by Amr Muhammad on 08/10/2025.
//

import SwiftUI

struct DefaultCountryView: View {
    var body: some View {
        VStack(spacing: 16) {
            HeaderTitleView(title: AppConstants.Localization.defaultCountry)
            
            HStack(spacing: 12) {
                CountryFlagView()
                    .frame(width: 40, height: 40)
                VStack(alignment: .leading, spacing: 8) {
                    Text("\(AppConstants.Localization.country) Egypt")
                        .font(.callout)
                    Text("\(AppConstants.Localization.capital) Cairo")
                        .font(.callout)
                    Text("\(AppConstants.Localization.currency) Pound")
                        .font(.callout)
                }
                Spacer()
            }
            .padding()
            .frame(height: 100)
            .background(
                RoundedRectangle(cornerRadius: 12)
                    .fill(.white)
            )
            .overlay(
                RoundedRectangle(cornerRadius: 12)
                    .stroke(.border, lineWidth: 1)
            )
        }
    }
}

#Preview {
    DefaultCountryView()
}
