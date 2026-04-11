//
//  WhereOnEarthApp.swift
//  WhereOnEarth
//
//  Created by Amr Muhammad on 09/04/2026.
//

import SwiftUI

@main
struct WhereOnEarthApp: App {
    @StateObject private var loading = Loading()
    @StateObject var popupPresent = PopupPresent()
    @StateObject private var navigationManager = NavigationManager()

    var body: some Scene {
        WindowGroup {
            AppLoader{
                NavigationStack(path: $navigationManager.path) {
                    HomeView()
                        .navigationDestination(for: AppRoute.self) { route in
                            AppRouter.view(for: route)
                        }
                }
            }
            .environmentObject(navigationManager)
            .environmentObject(popupPresent)
            .environmentObject(loading)
            .popup(isPresented: popupPresent.isPopupPresented) {
                popupPresent.popupView
            }
        }
    }
}
