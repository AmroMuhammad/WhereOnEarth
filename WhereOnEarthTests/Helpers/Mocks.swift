//
//  Mocks.swift
//  WhereOnEarthTests
//
//  Created by Amr Muhammad on 10/04/2026.
//

import Foundation
import Combine
@testable import WhereOnEarth

// MARK: - MockFetchCountriesUseCase

final class MockFetchCountriesUseCase: FetchCountriesUseCaseContract {
    var result: Result<[Country], Error> = .success([])

    func executeFetchCountries() async throws -> [Country] {
        try result.get()
    }
}

// MARK: - MockCountriesRemoteRepository

final class MockCountriesRemoteRepository: CountriesRemoteRepositoryContract {
    var result: Result<[Country], Error> = .success([])

    func fetchCountries() async throws -> [Country] {
        try result.get()
    }
}

// MARK: - MockCountriesLocalRepository

final class MockCountriesLocalRepository: CountriesLocalRepositoryContract {
    var savedCountries: [Country] = []
    var savedSelectedCountries: [Country] = []
    var savedDefaultCountry: Country?
    var shouldThrow = false

    func saveCountries(_ countries: [Country]) throws {
        if shouldThrow { throw NSError(domain: "test", code: 1) }
        savedCountries = countries
    }

    func loadCountries() throws -> [Country] {
        if shouldThrow { throw NSError(domain: "test", code: 1) }
        return savedCountries
    }

    func saveSelectedCountries(_ countries: [Country]) throws {
        if shouldThrow { throw NSError(domain: "test", code: 1) }
        savedSelectedCountries = countries
    }

    func loadSelectedCountries() throws -> [Country] {
        if shouldThrow { throw NSError(domain: "test", code: 1) }
        return savedSelectedCountries
    }

    func saveDefaultCountry(_ country: Country) throws {
        if shouldThrow { throw NSError(domain: "test", code: 1) }
        savedDefaultCountry = country
    }

    func loadDefaultCountry() throws -> Country? {
        if shouldThrow { throw NSError(domain: "test", code: 1) }
        return savedDefaultCountry
    }
}

// MARK: - MockCountriesLocalDataSource

final class MockCountriesLocalDataSource: CountriesLocalDataSourceContract {
    var cachedCountries: [Country] = []
    var cachedSelectedCountries: [Country] = []
    var cachedDefaultCountry: Country?
    var shouldThrow = false

    func cacheCountries(_ countries: [Country]) throws {
        if shouldThrow { throw NSError(domain: "test", code: 1) }
        cachedCountries = countries
    }

    func getCachedCountries() throws -> [Country] {
        if shouldThrow { throw NSError(domain: "test", code: 1) }
        return cachedCountries
    }

    func cacheSelectedCountries(_ countries: [Country]) throws {
        if shouldThrow { throw NSError(domain: "test", code: 1) }
        cachedSelectedCountries = countries
    }

    func getCachedSelectedCountries() throws -> [Country] {
        if shouldThrow { throw NSError(domain: "test", code: 1) }
        return cachedSelectedCountries
    }

    func cacheDefaultCountry(_ country: Country) throws {
        if shouldThrow { throw NSError(domain: "test", code: 1) }
        cachedDefaultCountry = country
    }

    func getCachedDefaultCountry() throws -> Country? {
        if shouldThrow { throw NSError(domain: "test", code: 1) }
        return cachedDefaultCountry
    }
}

// MARK: - MockAPIClient

final class MockAPIClient: APIClient {
    var asyncResult: Result<Any, Error> = .success([])

    func performRequest<T: Decodable>(_ endpoint: APIEndpoint) async throws -> T {
        let value = try asyncResult.get()
        guard let typed = value as? T else {
            throw APIClientError.decoding(NSError(domain: "MockAPIClient", code: 0,
                userInfo: [NSLocalizedDescriptionKey: "Type mismatch"]))
        }
        return typed
    }

    func performRequest<T: Decodable>(_ endpoint: APIEndpoint) -> AnyPublisher<T, APIClientError> {
        do {
            let value = try asyncResult.get()
            guard let typed = value as? T else {
                return Fail(error: APIClientError.decoding(NSError(domain: "MockAPIClient", code: 0)))
                    .eraseToAnyPublisher()
            }
            return Just(typed)
                .setFailureType(to: APIClientError.self)
                .eraseToAnyPublisher()
        } catch let error as APIClientError {
            return Fail(error: error).eraseToAnyPublisher()
        } catch {
            return Fail(error: APIClientError.unknown(error)).eraseToAnyPublisher()
        }
    }
}

// MARK: - MockURLSession

final class MockURLSession: URLSessionProtocol {
    var dataResult: Result<(Data, URLResponse), Error> = .success((Data(), HTTPURLResponse()))

    func data(for request: URLRequest) async throws -> (Data, URLResponse) {
        try dataResult.get()
    }

    func dataTaskPublisher(for request: URLRequest) -> AnyPublisher<(data: Data, response: URLResponse), URLError> {
        switch dataResult {
        case .success(let (data, response)):
            return Just((data: data, response: response))
                .setFailureType(to: URLError.self)
                .eraseToAnyPublisher()
        case .failure(let error):
            let urlError = (error as? URLError) ?? URLError(.unknown)
            return Fail(error: urlError).eraseToAnyPublisher()
        }
    }
}

// MARK: - MockResponseValidator

final class MockResponseValidator: ResponseValidatorProtocol {
    var dataToReturn: Data?
    var errorToThrow: Error?

    func validate<T: Decodable>(response: URLResponse?, data: Data?, for type: T.Type) throws -> Data {
        if let error = errorToThrow { throw error }
        return dataToReturn ?? data ?? Data()
    }
}

// MARK: - MockLocationService

final class MockLocationService: LocationServiceProtocol {
    var countryToReturn: String?

    func currentCountry() async -> String? {
        countryToReturn
    }
}

// MARK: - NoOpLogger

final class NoOpLogger: LoggerProtocol {
    func log(request: URLRequest) {}
    func log(response: HTTPURLResponse, data: Data) {}
}

// MARK: - TestEndpoint

enum TestEndpoint: APIEndpoint {
    case test
    case withQuery
    case withBody
    case withHeaders

    var path: String { "test" }
    var method: HTTPMethod {
        switch self {
        case .test, .withQuery, .withHeaders: return .get
        case .withBody: return .post
        }
    }
    var apiType: APIType? {
        switch self {
        case .test: return nil
        case .withQuery: return .urlQuery(["key": "value", "page": "1"])
        case .withBody: return .jsonBody(["name": "test"])
        case .withHeaders: return nil
        }
    }
    var headers: [String: String]? {
        switch self {
        case .withHeaders: return ["Authorization": "Bearer token123"]
        default: return nil
        }
    }
}
