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
}
