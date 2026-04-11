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

    private let remoteRepo: CountriesRemoteRepositoryContract
    private let localRepo: CountriesLocalRepositoryContract

    init(remoteRepo: CountriesRemoteRepositoryContract = CountriesRemoteRepository(),
         localRepo: CountriesLocalRepositoryContract = CountriesLocalRepository()) {
        self.remoteRepo = remoteRepo
        self.localRepo = localRepo
    }

    func executeFetchCountries() async throws -> [Country] {
        do {
            let countries = try await remoteRepo.fetchCountries()
            try? localRepo.saveCountries(countries)
            return countries
        } catch {
            if let cached = try? localRepo.loadCountries(), !cached.isEmpty {
                return cached
            }
            throw error
        }
    }
}
