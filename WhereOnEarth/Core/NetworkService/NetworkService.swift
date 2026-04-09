//
//  NetworkService.swift
//  WhereOnEarth
//
//  Created by Amr Muhammad on 09/04/2026.
//

import Foundation
import Combine

final class NetworkService: APIClient {
    
    private let session: URLSessionProtocol
    private let requestBuilder: URLRequestBuilderProtocol
    private let decoder: JSONDecoder
    private let validator: ResponseValidatorProtocol
    private let logger: LoggerProtocol
    
    init(
        session: URLSessionProtocol = URLSessionWrapper(),
        requestBuilder: URLRequestBuilderProtocol = URLRequestBuilder(),
        decoder: JSONDecoder = JSONDecoder(),
        validator: ResponseValidatorProtocol = ResponseValidator(),
        logger: LoggerProtocol = Logger.shared
    ) {
        self.session = session
        self.requestBuilder = requestBuilder
        self.decoder = decoder
        self.validator = validator
        self.logger = logger
    }
    
    func performRequest<T: Decodable>(_ endpoint: APIEndpoint) -> AnyPublisher<T, APIClientError> {
        do {
            var request = try requestBuilder.buildRequest(from: endpoint)
            request.cachePolicy = endpoint.cachePolicy
            logger.log(request: request)
            
            return session.dataTaskPublisher(for: request)
                .tryMap { [weak self] data, response in
                    guard let self else {
                        throw APIClientError.apiError(.badResponse)
                    }
                    if let httpResponse = response as? HTTPURLResponse {
                        self.logger.log(response: httpResponse, data: data)
                    }
                    return try self.validator.validate(response: response, data: data, for: T.self)
                }
                .decode(type: T.self, decoder: decoder)
                .mapError { error in
                    if let urlError = error as? URLError {
                        switch urlError.code {
                            case .notConnectedToInternet:
                                return .apiError(.noInternet)
                            case .timedOut:
                                return .apiError(.requestTimeout)
                            default:
                                return .unknown(urlError)
                        }
                    } else if let decodingError = error as? DecodingError {
                        return .decoding(decodingError)
                    } else if let clientError = error as? APIClientError {
                        return clientError
                    } else {
                        return .unknown(error)
                    }
                }
                .eraseToAnyPublisher()
        } catch let error as APIError {
            return Fail(error: .apiError(error)).eraseToAnyPublisher()
        } catch {
            return Fail(error: .unknown(error)).eraseToAnyPublisher()
        }
    }

    func performRequest<T: Decodable>(_ endpoint: APIEndpoint) async throws -> T {
        do {
            var request = try requestBuilder.buildRequest(from: endpoint)
            request.cachePolicy = endpoint.cachePolicy
            logger.log(request: request)

            let (data, response) = try await session.data(for: request)
            if let httpResponse = response as? HTTPURLResponse {
                logger.log(response: httpResponse, data: data)
            }
            let validated = try validator.validate(response: response, data: data, for: T.self)
            return try decoder.decode(T.self, from: validated)
        } catch let error as APIClientError {
            throw error
        } catch let error as APIError {
            throw APIClientError.apiError(error)
        } catch let error as DecodingError {
            throw APIClientError.decoding(error)
        } catch let error as URLError {
            switch error.code {
                case .notConnectedToInternet:
                    throw APIClientError.apiError(.noInternet)
                case .timedOut:
                    throw APIClientError.apiError(.requestTimeout)
                default:
                    throw APIClientError.unknown(error)
            }
        } catch {
            throw APIClientError.unknown(error)
        }
    }
}
