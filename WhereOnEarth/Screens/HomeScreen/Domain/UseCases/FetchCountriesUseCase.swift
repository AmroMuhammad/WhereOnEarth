//
//  FetchCountriesUseCase.swift
//  WhereOnEarth
//
//  Created by Amr Muhammad on 10/04/2026.
//

import Foundation

protocol FetchCountriesUseCaseContract {
    func executeFetchCountries() async throws -> [Country]
}

final class FetchCountriesUseCase: FetchCountriesUseCaseContract {

    private let repo: CountriesRemoteRepositoryContract

    init(repo: CountriesRemoteRepositoryContract = CountriesRemoteRepository()) {
        self.repo = repo
    }

    func executeFetchCountries() async throws -> [Country] {
        try await repo.fetchCountries()
    }
}
