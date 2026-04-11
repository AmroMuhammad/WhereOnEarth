//
//  FetchCountriesUseCaseTests.swift
//  WhereOnEarthTests
//
//  Created by Amr Muhammad on 10/04/2026.
//

import XCTest
@testable import WhereOnEarth

final class FetchCountriesUseCaseTests: XCTestCase {

    private var mockRemoteRepo: MockCountriesRemoteRepository!
    private var mockLocalRepo: MockCountriesLocalRepository!
    private var sut: FetchCountriesUseCase!

    override func setUp() {
        super.setUp()
        mockRemoteRepo = MockCountriesRemoteRepository()
        mockLocalRepo = MockCountriesLocalRepository()
        sut = FetchCountriesUseCase(remoteRepo: mockRemoteRepo, localRepo: mockLocalRepo)
    }

    override func tearDown() {
        mockRemoteRepo = nil
        mockLocalRepo = nil
        sut = nil
        super.tearDown()
    }

    // MARK: - Remote Success

    func test_execute_returnsCountriesFromRemote() async throws {
        let expected = CountryFactory.sampleList()
        mockRemoteRepo.result = .success(expected)

        let result = try await sut.executeFetchCountries()

        XCTAssertEqual(result.count, expected.count)
        XCTAssertEqual(result.first?.name?.common, "Egypt")
    }

    func test_execute_cachesOnSuccess() async throws {
        let expected = CountryFactory.sampleList()
        mockRemoteRepo.result = .success(expected)

        _ = try await sut.executeFetchCountries()

        XCTAssertEqual(mockLocalRepo.savedCountries.count, expected.count)
    }

    func test_execute_returnsRemoteEvenWhenCacheFails() async throws {
        let expected = CountryFactory.sampleList()
        mockRemoteRepo.result = .success(expected)
        mockLocalRepo.shouldThrow = true

        let result = try await sut.executeFetchCountries()

        XCTAssertEqual(result.count, expected.count)
    }

    // MARK: - Remote Failure with Cache Fallback

    func test_execute_fallsToCacheOnRemoteFailure() async throws {
        let cached = [CountryFactory.egypt()]
        mockRemoteRepo.result = .failure(APIClientError.apiError(.noInternet))
        mockLocalRepo.savedCountries = cached

        let result = try await sut.executeFetchCountries()

        XCTAssertEqual(result.count, 1)
        XCTAssertEqual(result.first?.name?.common, "Egypt")
    }

    func test_execute_throwsWhenBothRemoteAndCacheFail() async {
        mockRemoteRepo.result = .failure(APIClientError.apiError(.noInternet))
        mockLocalRepo.savedCountries = []

        do {
            _ = try await sut.executeFetchCountries()
            XCTFail("Expected error")
        } catch let error as APIClientError {
            XCTAssertEqual(error, .apiError(.noInternet))
        } catch {
            XCTFail("Unexpected error type: \(error)")
        }
    }

    func test_execute_throwsWhenRemoteFailsAndCacheThrows() async {
        mockRemoteRepo.result = .failure(APIClientError.apiError(.noInternet))
        mockLocalRepo.shouldThrow = true

        do {
            _ = try await sut.executeFetchCountries()
            XCTFail("Expected error")
        } catch let error as APIClientError {
            XCTAssertEqual(error, .apiError(.noInternet))
        } catch {
            XCTFail("Unexpected error type: \(error)")
        }
    }
}
