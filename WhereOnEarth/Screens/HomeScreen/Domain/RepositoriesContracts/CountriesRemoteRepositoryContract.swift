//
//  CountriesRemoteRepositoryContract.swift
//  WhereOnEarth
//
//  Created by Amr Muhammad on 09/10/2025.
//

import Combine

protocol CountriesRemoteRepositoryContract {
    func fetchCountries() -> AnyPublisher<Countries, APIClientError>
}
