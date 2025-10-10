//
//  AppRouter.swift
//  WhereOnEarth
//
//  Created by Amr Muhammad on 10/10/2025.
//

import SwiftUI

struct AppRouter {
    @ViewBuilder
    static func view(for route: AppRoute) -> some View {
        switch route {
        case .countryDetail(let country):
            CountryDetailsView(country: country)
        }
    }
}
