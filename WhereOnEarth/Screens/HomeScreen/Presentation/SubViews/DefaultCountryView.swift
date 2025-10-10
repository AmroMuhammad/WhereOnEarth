//
//  DefaultCountryView.swift
//  WhereOnEarth
//
//  Created by Amr Muhammad on 08/10/2025.
//

import SwiftUI

struct DefaultCountryView: View {
    @ObservedObject var viewModel: HomeViewModel
    
    var body: some View {
        VStack(spacing: 8) {
            HeaderTitleView(title: Constants.Localization.defaultCountry)
            
            HStack(spacing: 12) {
                CountryFlagView(url: viewModel.getCurrentUserCountry()?.flags?.png ?? "")
                    .frame(width: 40, height: 40)
                VStack(alignment: .leading, spacing: 8) {
                    Text("\(Constants.Localization.country) \(viewModel.getCurrentUserCountry()?.name?.common ?? "")")
                        .font(.callout)
                    Text("\(Constants.Localization.capital) \(viewModel.getCurrentUserCountry()?.capital?.first ?? "")")
                        .font(.callout)
                    Text("\(Constants.Localization.currency) \(viewModel.getCurrentUserCountry()?.currencies?.values.first?.compinedName ?? "")")
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
    DefaultCountryView(viewModel: HomeViewModel())
}
