//
//  CountryFlagView.swift
//  WhereOnEarth
//
//  Created by Amr Muhammad on 09/04/2026.
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
