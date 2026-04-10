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

    var body: some Scene {
        WindowGroup {
            AppLoader {
                HomeView()
            }
            .environmentObject(popupPresent)
            .environmentObject(loading)
            .popup(isPresented: popupPresent.isPopupPresented) {
                popupPresent.popupView
            }
        }
    }
}
