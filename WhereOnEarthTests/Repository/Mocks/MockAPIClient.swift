//
//  MockAPIClient.swift
//  WhereOnEarthTests
//
//  Created by Amr Muhammad on 11/10/2025.
//

import XCTest
import Combine
@testable import WhereOnEarth

class MockAPIClient: APIClient {
    var countriesToReturn: Result<[CountryDTO], APIClientError> = .failure(.apiError(.badResponse))
    
    func performRequest<T>(_ endpoint: APIEndpoint) -> AnyPublisher<T, APIClientError> where T : Decodable {
        return countriesToReturn.publisher
            .tryMap { $0 as! T }
            .mapError { $0 as! APIClientError }
            .eraseToAnyPublisher()
    }
}
