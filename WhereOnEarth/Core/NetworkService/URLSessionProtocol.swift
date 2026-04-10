//
//  URLSessionProtocol.swift
//  WhereOnEarth
//
//  Created by Amr Muhammad on 09/04/2026.
//

import Foundation
import Combine

protocol URLSessionProtocol {
    func dataTaskPublisher(for request: URLRequest) -> AnyPublisher<(data: Data, response: URLResponse), URLError>
    func data(for request: URLRequest) async throws -> (Data, URLResponse)
}

struct URLSessionWrapper: URLSessionProtocol {
    let session: URLSession

    init(session: URLSession = .shared) {
        self.session = session
    }

    func dataTaskPublisher(for request: URLRequest) -> AnyPublisher<(data: Data, response: URLResponse), URLError> {
        return session.dataTaskPublisher(for: request)
            .map { ($0.data, $0.response) }
            .eraseToAnyPublisher()
    }

    func data(for request: URLRequest) async throws -> (Data, URLResponse) {
        return try await session.data(for: request)
    }
}
