//
//  WhereOnEarthApp.swift
//  WhereOnEarth
//
//  Created by Amr Muhammad on 08/10/2025.
//

import SwiftUI
import SwiftData

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
