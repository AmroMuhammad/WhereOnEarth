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
        try context.delete(model: type)
        try context.save()
    }
}
