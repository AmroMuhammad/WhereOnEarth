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
    func cacheSelectedCountries(_ countries: [Country]) throws
    func getCachedSelectedCountries() throws -> [Country]
    func cacheDefaultCountry(_ country: Country) throws
    func getCachedDefaultCountry() throws -> Country?
}

final class CountriesLocalDataSource: CountriesLocalDataSourceContract {

    private let storageManager: LocalStorageManager

    init(storageManager: LocalStorageManager = SwiftDataManager.shared) {
        self.storageManager = storageManager
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

    func cacheSelectedCountries(_ countries: [Country]) throws {
        try storageManager.deleteAll(CachedSelectedCountry.self)
        let cached = countries.enumerated().map { CachedSelectedCountry(from: $1, orderIndex: $0) }
        try storageManager.save(cached)
    }

    func getCachedSelectedCountries() throws -> [Country] {
        let cached = try storageManager.fetch(CachedSelectedCountry.self)
        return cached.sorted { $0.orderIndex < $1.orderIndex }.map { $0.toCountry() }
    }

    func cacheDefaultCountry(_ country: Country) throws {
        try storageManager.deleteAll(CachedDefaultCountry.self)
        try storageManager.save([CachedDefaultCountry(from: country)])
    }

    func getCachedDefaultCountry() throws -> Country? {
        try storageManager.fetch(CachedDefaultCountry.self).first?.toCountry()
    }
}
