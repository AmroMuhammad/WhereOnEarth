//
//  CountriesRemoteRepositoryTests.swift
//  WhereOnEarthTests
//
//  Created by Amr Muhammad on 10/04/2026.
//

import XCTest
@testable import WhereOnEarth

final class CountriesRemoteRepositoryTests: XCTestCase {

    private var mockAPIClient: MockAPIClient!
    private var sut: CountriesRemoteRepository!

    override func setUp() {
        super.setUp()
        mockAPIClient = MockAPIClient()
        sut = CountriesRemoteRepository(apiClient: mockAPIClient)
    }

    override func tearDown() {
        mockAPIClient = nil
        sut = nil
        super.tearDown()
    }

    func test_fetchCountries_returnsCountries() async throws {
        let expected = CountryFactory.sampleList()
        mockAPIClient.asyncResult = .success(expected)

        let result = try await sut.fetchCountries()

        XCTAssertEqual(result.count, expected.count)
        XCTAssertEqual(result.first?.name?.common, "Egypt")
    }

    func test_fetchCountries_returnsEmptyList() async throws {
        mockAPIClient.asyncResult = .success([Country]())

        let result = try await sut.fetchCountries()

        XCTAssertTrue(result.isEmpty)
    }

    func test_fetchCountries_throwsOnNetworkError() async {
        mockAPIClient.asyncResult = .failure(APIClientError.apiError(.noInternet))

        do {
            _ = try await sut.fetchCountries()
            XCTFail("Expected error")
        } catch let error as APIClientError {
            XCTAssertEqual(error, .apiError(.noInternet))
        } catch {
            XCTFail("Unexpected error type: \(error)")
        }
    }

    func test_fetchCountries_throwsOnServerError() async {
        mockAPIClient.asyncResult = .failure(APIClientError.apiError(.internalServerError))

        do {
            _ = try await sut.fetchCountries()
            XCTFail("Expected error")
        } catch let error as APIClientError {
            XCTAssertEqual(error, .apiError(.internalServerError))
        } catch {
            XCTFail("Unexpected error type: \(error)")
        }
    }

    func test_fetchCountries_throwsOnDecodingError() async {
        mockAPIClient.asyncResult = .failure(APIClientError.decoding(
            NSError(domain: "decoding", code: 0)))

        do {
            _ = try await sut.fetchCountries()
            XCTFail("Expected error")
        } catch let error as APIClientError {
            if case .decoding = error {
                // Expected
            } else {
                XCTFail("Expected decoding error, got: \(error)")
            }
        } catch {
            XCTFail("Unexpected error type: \(error)")
        }
    }
}
