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
    var sharedModelContainer: ModelContainer = {
        let schema = Schema([
            Item.self,
        ])
        let modelConfiguration = ModelConfiguration(schema: schema, isStoredInMemoryOnly: false)

        do {
            return try ModelContainer(for: schema, configurations: [modelConfiguration])
        } catch {
            fatalError("Could not create ModelContainer: \(error)")
        }
    }()

    var body: some Scene {
        WindowGroup {
            AppLoader{
                HomeView()
            }
            .environmentObject(popupPresent)
            .environmentObject(loading)
            .popup(isPresented: popupPresent.isPopupPresented) {
                popupPresent.popupView
            }
        }
        .modelContainer(sharedModelContainer)
    }
}
