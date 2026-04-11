//
//  CountriesRemoteRepositoryContract.swift
//  WhereOnEarth
//
//  Created by Amr Muhammad on 10/04/2026.
//

import Foundation

protocol CountriesRemoteRepositoryContract {
    func fetchCountries() async throws -> [Country]
}
