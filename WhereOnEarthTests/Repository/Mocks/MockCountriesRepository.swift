//
//  MockCountriesRepository.swift
//  WhereOnEarthTests
//
//  Created by Amr Muhammad on 11/10/2025.
//

import XCTest
import Combine
@testable import WhereOnEarth

class MockCountriesRepository: CountriesRemoteRepositoryContract {
    var countriesToReturn: AnyPublisher<[Country], APIClientError> =
    Fail(error: APIClientError.apiError(.badResponse)).eraseToAnyPublisher()
    
    func fetchCountries() -> AnyPublisher<[Country], APIClientError> {
        return countriesToReturn
    }
}
