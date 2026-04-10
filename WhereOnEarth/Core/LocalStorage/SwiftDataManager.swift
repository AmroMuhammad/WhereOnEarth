//
//  SwiftDataManager.swift
//  WhereOnEarth
//
//  Created by Amr Muhammad on 10/04/2026.
//

import Foundation
import SwiftData

protocol LocalStorageManager {
    func save<T: PersistentModel>(_ items: [T]) throws
    func fetch<T: PersistentModel>(_ type: T.Type) throws -> [T]
    func deleteAll<T: PersistentModel>(_ type: T.Type) throws
}

final class SwiftDataManager: LocalStorageManager {

    private let container: ModelContainer
    private let context: ModelContext

    static let shared: SwiftDataManager = SwiftDataManager(
        schema: Schema([CachedCountry.self, CachedSelectedCountry.self, CachedDefaultCountry.self])
    )

    init(schema: Schema, inMemory: Bool = false) {
        let config = ModelConfiguration(isStoredInMemoryOnly: inMemory)
        self.container = try! ModelContainer(for: schema, configurations: [config])
        self.context = ModelContext(container)
    }

    func save<T: PersistentModel>(_ items: [T]) throws {
        for item in items {
            context.insert(item)
        }
        try context.save()
    }

    func fetch<T: PersistentModel>(_ type: T.Type) throws -> [T] {
        let descriptor = FetchDescriptor<T>()
        return try context.fetch(descriptor)
    }

    func deleteAll<T: PersistentModel>(_ type: T.Type) throws {
        let items = try context.fetch(FetchDescriptor<T>())
        for item in items {
            context.delete(item)
        }
        try context.save()
    }
}
