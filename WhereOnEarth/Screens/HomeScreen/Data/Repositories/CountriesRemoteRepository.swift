//
//  CountriesRemoteRepository.swift
//  WhereOnEarth
//
//  Created by Amr Muhammad on 10/04/2026.
//

import Foundation

final class CountriesRemoteRepository: CountriesRemoteRepositoryContract {

    private let apiClient: APIClient

    init(apiClient: APIClient = NetworkService()) {
        self.apiClient = apiClient
    }

    func fetchCountries() async throws -> [Country] {
        try await apiClient.performRequest(CountriesEndpoint.getAll)
    }
}
