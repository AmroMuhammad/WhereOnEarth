//
//  CountriesLocalRepository.swift
//  WhereOnEarth
//
//  Created by Amr Muhammad on 10/04/2026.
//

import Foundation

final class CountriesLocalRepository: CountriesLocalRepositoryContract {

    private let localDataSource: CountriesLocalDataSourceContract

    init(localDataSource: CountriesLocalDataSourceContract = CountriesLocalDataSource()) {
        self.localDataSource = localDataSource
    }

    func saveCountries(_ countries: [Country]) throws {
        try localDataSource.cacheCountries(countries)
    }

    func loadCountries() throws -> [Country] {
        try localDataSource.getCachedCountries()
    }

    func saveSelectedCountries(_ countries: [Country]) throws {
        try localDataSource.cacheSelectedCountries(countries)
    }

    func loadSelectedCountries() throws -> [Country] {
        try localDataSource.getCachedSelectedCountries()
    }

    func saveDefaultCountry(_ country: Country) throws {
        try localDataSource.cacheDefaultCountry(country)
    }

    func loadDefaultCountry() throws -> Country? {
        try localDataSource.getCachedDefaultCountry()
    }
}
