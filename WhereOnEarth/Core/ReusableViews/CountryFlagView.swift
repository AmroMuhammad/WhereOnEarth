//
//  CountryFlagView.swift
//  WhereOnEarth
//
//  Created by Amr Muhammad on 08/10/2025.
//

import SwiftUI
import SDWebImageSwiftUI

struct CountryFlagView: View {
    let url: String?
    var body: some View {
        WebImage(url: URL(string: url ?? "")) { $0.resizable() }
        placeholder: {
            AppResources.Assets.flagPlaceholder
                .resizable()
        }
        .scaledToFit()
        .cornerRadius(5)
    }
}

#Preview {
    CountryFlagView(url: "https://flagcdn.com/w320/lt.png")
}
