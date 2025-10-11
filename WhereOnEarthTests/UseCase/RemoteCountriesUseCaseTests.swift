//
//  RemoteCountriesUseCaseTests.swift
//  WhereOnEarthTests
//
//  Created by Amr Muhammad on 11/10/2025.
//

import XCTest
import Combine
@testable import WhereOnEarth

class RemoteCountriesUseCaseTests: XCTestCase {
    
    var cancellables = Set<AnyCancellable>()
    var mockRepository: MockCountriesRepository!
    var useCase: FetchCountriesUseCase!
    
    // MARK: - Test Data
    private let usaCountry = Country(
        id: "123",
        name: "United States",
        capital: "Washington, D.C.",
        currency: Currency(code: "", name: "US Dollar", symbol: "$"),
        language: "English",
        flag: "us.png"
    )
    
    private let ukCountry = Country(
        id: "456",
        name: "United Kingdom",
        capital: "London",
        currency: Currency(code: "", name: "Pound", symbol: "£"),
        language: "English",
        flag: "uk.png"
    )
    
    // MARK: - Setup
    
    override func setUp() {
        super.setUp()
        mockRepository = MockCountriesRepository()
        useCase = FetchCountriesUseCase(repo: mockRepository)
    }
    
    override func tearDown() {
        cancellables.removeAll()
        mockRepository = nil
        useCase = nil
        super.tearDown()
    }
    
    // MARK: - Success Tests
    func test_executeFetchCountries_returnsCountries() {
        // Given
        let expectedCountries = [usaCountry, ukCountry]
        mockRepository.countriesToReturn = Just(expectedCountries)
            .setFailureType(to: APIClientError.self)
            .eraseToAnyPublisher()
        
        let expectation = expectation(description: "Should return countries")
        
        // When
        useCase.executeFetchCountries()
            .sink(receiveCompletion: { completion in
                if case .failure(let error) = completion {
                    XCTFail("Expected success, joe_error : \(error)")
                }
            }, receiveValue: { countries in
                // Then
                XCTAssertEqual(countries.count, 2)
                XCTAssertEqual(countries[0].name, "United States")
                XCTAssertEqual(countries[1].capital, "London")
                expectation.fulfill()
            })
            .store(in: &cancellables)
        
        wait(for: [expectation], timeout: 1.0)
    }
    
    // MARK: - Failure Tests
    func test_executeFetchCountries_whenRepositoryFails_returnsError() {
        // Given
        let expectedError = APIClientError.apiError(.noInternet)
        mockRepository.countriesToReturn = Fail(error: expectedError)
            .eraseToAnyPublisher()
        
        let expectation = expectation(description: "Should return error")
        
        // When
        useCase.executeFetchCountries()
            .sink(receiveCompletion: { completion in
                if case .failure(let error) = completion {
                    // Then
                    switch (error, expectedError) {
                        case (.apiError(let receivedError), .apiError(let expectedError)):
                            XCTAssertEqual(receivedError, expectedError)
                        default:
                            XCTFail("Error types don't match")
                    }
                    expectation.fulfill()
                }
            }, receiveValue: { _ in
                XCTFail("Expected failure")
            })
            .store(in: &cancellables)
        
        wait(for: [expectation], timeout: 1.0)
    }
    
    func test_executeFetchCountries_whenRepositoryReturnsEmptyArray_returnsEmptyArray() {
        // Given
        mockRepository.countriesToReturn = Just([])
            .setFailureType(to: APIClientError.self)
            .eraseToAnyPublisher()
        
        let expectation = expectation(description: "Should return empty array")
        
        // When
        useCase.executeFetchCountries()
            .sink(receiveCompletion: { completion in
                if case .failure(let error) = completion {
                    XCTFail("Expected success, joe_error: \(error)")
                }
            }, receiveValue: { countries in
                // Then
                XCTAssertTrue(countries.isEmpty)
                expectation.fulfill()
            })
            .store(in: &cancellables)
        
        wait(for: [expectation], timeout: 1.0)
    }
    
    // MARK: - Edge Cases
    func test_executeFetchCountries_whenRepositoryReturnsDecodingError_propagatesError() {
        // Given
        let expectedError = APIClientError.decoding(NSError(domain: "test", code: -1, userInfo: nil))
        mockRepository.countriesToReturn = Fail(error: expectedError)
            .eraseToAnyPublisher()
        
        let expectation = expectation(description: "Should propagate decoding error")
        
        // When
        useCase.executeFetchCountries()
            .sink(receiveCompletion: { completion in
                if case .failure(let error) = completion {
                    // Then
                    if case .decoding = error {
                        expectation.fulfill()
                    } else {
                        XCTFail("Expected decoding error")
                    }
                }
            }, receiveValue: { _ in
                XCTFail("Expected failure")
            })
            .store(in: &cancellables)
        
        wait(for: [expectation], timeout: 1.0)
    }
    
    func test_executeFetchCountries_whenRepositoryReturnsCustomError_propagatesError() {
        // Given
        let expectedError = APIClientError.custom(message: "Joe error")
        mockRepository.countriesToReturn = Fail(error: expectedError)
            .eraseToAnyPublisher()
        
        let expectation = expectation(description: "Should propagate custom error")
        
        // When
        useCase.executeFetchCountries()
            .sink(receiveCompletion: { completion in
                if case .failure(let error) = completion {
                    // Then
                    if case .custom(let message) = error {
                        XCTAssertEqual(message, "Joe error")
                        expectation.fulfill()
                    } else {
                        XCTFail("Expected custom error")
                    }
                }
            }, receiveValue: { _ in
                XCTFail("Expected failure")
            })
            .store(in: &cancellables)
        
        wait(for: [expectation], timeout: 1.0)
    }
}

