//
//  CountriesLocalRepositoryContract.swift
//  WhereOnEarth
//
//  Created by Amr Muhammad on 10/04/2026.
//

import Foundation

protocol CountriesLocalRepositoryContract {
    func saveCountries(_ countries: [Country]) throws
    func loadCountries() throws -> [Country]
    func saveSelectedCountries(_ countries: [Country]) throws
    func loadSelectedCountries() throws -> [Country]
    func saveDefaultCountry(_ country: Country) throws
    func loadDefaultCountry() throws -> Country?
}
