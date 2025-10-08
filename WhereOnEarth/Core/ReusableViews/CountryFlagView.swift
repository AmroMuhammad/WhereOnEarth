//
//  CountryFlagView.swift
//  WhereOnEarth
//
//  Created by Amr Muhammad on 08/10/2025.
//

import SwiftUI

struct CountryFlagView: View {
    var body: some View {
        AppResources.Assets.flagPlaceholder
            .resizable()
            .scaledToFit()
            .cornerRadius(5)
    }
}

#Preview {
    CountryFlagView()
}
