//
//  FetchCountriesUseCase.swift
//  WhereOnEarth
//
//  Created by Amr Muhammad on 09/10/2025.
//

import Combine

protocol FetchCountriesUseCaseContract {
    func executeFetchCountries() -> AnyPublisher<Countries, APIClientError>
}

final class FetchCountriesUseCase: FetchCountriesUseCaseContract {
    
    private let repo: CountriesRemoteRepositoryContract
    
    init(repo: CountriesRemoteRepositoryContract = CountriesRemoteRepository()) {
        self.repo = repo
    }
    
    func executeFetchCountries() -> AnyPublisher<Countries, APIClientError> {
        repo.fetchCountries()
    }
}

