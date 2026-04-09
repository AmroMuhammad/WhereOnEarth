//
//  APIClient.swift
//  WhereOnEarth
//
//  Created by Amr Muhammad on 09/04/2026.
//

import Foundation
import Combine

protocol APIClient {
    func performRequest<T: Decodable>(_ endpoint: APIEndpoint) -> AnyPublisher<T, APIClientError>
    func performRequest<T: Decodable>(_ endpoint: APIEndpoint) async throws -> T
}
