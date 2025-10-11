//
//  APIClient.swift
//  WhereOnEarth
//
//  Created by Amr Muhammad on 08/10/2025.
//

import Foundation
import Combine

protocol APIClient {
    func performRequest<T: Decodable>(_ endpoint: APIEndpoint) -> AnyPublisher<T, APIClientError>
    
}
