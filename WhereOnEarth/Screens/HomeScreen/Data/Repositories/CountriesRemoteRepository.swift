//
//  CountriesRemoteRepository.swift
//  WhereOnEarth
//
//  Created by Amr Muhammad on 09/10/2025.
//

import Foundation
import Combine

final class CountriesRemoteRepository: CountriesRemoteRepositoryContract {
    
    private let apiClient: APIClient
    
    init(apiClient: APIClient = NetworkService()) {
        self.apiClient = apiClient
    }
    
    func fetchCountries() -> AnyPublisher<[Country], APIClientError> {
        apiClient.performRequest(CountriesEndpoint.getAll)
            .map { (dtos: [CountryDTO]) -> [Country] in
                dtos.map(CountryMapper.map)
            }
            .eraseToAnyPublisher()
    }
}
