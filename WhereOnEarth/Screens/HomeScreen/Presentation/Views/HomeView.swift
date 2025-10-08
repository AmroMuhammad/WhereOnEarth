//
//  HomeView.swift
//  WhereOnEarth
//
//  Created by Amr Muhammad on 08/10/2025.
//

import SwiftUI

struct HomeView: View {
    var body: some View {
        VStack(spacing: 20) {
            SearchView()
            DefaultCountryView()
        }
        .padding(16)
    }
}

#Preview {
    HomeView()
}
