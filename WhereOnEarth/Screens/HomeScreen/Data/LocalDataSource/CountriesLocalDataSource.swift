//
//  CountriesLocalDataSource.swift
//  WhereOnEarth
//
//  Created by Amr Muhammad on 10/04/2026.
//

import Foundation
import SwiftData

protocol CountriesLocalDataSourceContract {
    func cacheCountries(_ countries: [Country]) throws
    func getCachedCountries() throws -> [Country]
}

final class CountriesLocalDataSource: CountriesLocalDataSourceContract {

    private let storageManager: LocalStorageManager

    init(storageManager: LocalStorageManager? = nil) {
        self.storageManager = storageManager ?? SwiftDataManager(
            schema: Schema([CachedCountry.self])
        )
    }

    func cacheCountries(_ countries: [Country]) throws {
        try storageManager.deleteAll(CachedCountry.self)
        let cached = countries.map { CachedCountry(from: $0) }
        try storageManager.save(cached)
    }

    func getCachedCountries() throws -> [Country] {
        let cached = try storageManager.fetch(CachedCountry.self)
        return cached.map { $0.toCountry() }
    }
}
