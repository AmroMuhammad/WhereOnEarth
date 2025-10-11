//
//  MockFetchCountriesUseCase.swift
//  WhereOnEarthTests
//
//  Created by Amr Muhammad on 11/10/2025.
//

import XCTest
import Combine
@testable import WhereOnEarth

class MockFetchCountriesUseCase: FetchCountriesUseCaseContract {
    var result: Result<[Country], APIClientError> = .success([])
    private(set) var fetchCalled = false
    
    func executeFetchCountries() -> AnyPublisher<[Country], APIClientError> {
        fetchCalled = true
        return result.publisher.eraseToAnyPublisher()
    }
}
