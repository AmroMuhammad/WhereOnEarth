//
//  RemoteCountriesRepositoryTests.swift
//  WhereOnEarthTests
//
//  Created by Amr Muhammad on 11/10/2025.
//

import XCTest
import Combine
@testable import WhereOnEarth

class RemoteCountriesRepositoryTests: XCTestCase {
    var cancellables = Set<AnyCancellable>()
    var mockAPIClient: MockAPIClient!
    var repository: CountriesRemoteRepositoryContract!
    
    override func setUp() {
        super.setUp()
        mockAPIClient = MockAPIClient()
        repository = CountriesRemoteRepository(apiClient: mockAPIClient)
    }
    
    override func tearDown() {
        cancellables.removeAll()
        super.tearDown()
    }
    
    func testFetchCountriesSuccess() {
        // given
        let expectedCountries = [
            CountryDTO(
                flags: FlagsDTO(png: "https://flagcdn.com/w320/us.png", svg: "https://flagcdn.com/us.svg", alt: "US Flag"),
                name: NameDTO(
                    common: "United States",
                    official: "United States of America",
                    nativeName: ["eng": NativeNameDTO(official: "United States of America", common: "United States")]
                ),
                cca2: "US",
                currencies: ["USD": CurrencyDTO(name: "United States dollar", symbol: "$")],
                capital: ["Washington, D.C."],
                subregion: "North America",
                languages: ["eng": "English"],
                population: 329484123,
                timezones: ["UTC-12:00", "UTC-11:00", "UTC-10:00", "UTC-09:00"]
            )
        ]
        
        mockAPIClient.countriesToReturn = .success(expectedCountries)
        let expectation = XCTestExpectation(description: "Fetch countries succeeds")
        
        // when
        repository.fetchCountries()
            .sink(receiveCompletion: { completion in
                if case .failure = completion {
                    XCTFail("Expected success")
                }
            }, receiveValue: { countries in
                // then
                XCTAssertEqual(countries.first?.capital, "Washington, D.C.")
                XCTAssertEqual(countries.first?.name, "United States")
                expectation.fulfill()
            })
            .store(in: &cancellables)
        
        wait(for: [expectation], timeout: 1)
    }
    
    func testNetworkError() {
        // given
        let mockSession = MockURLSession()
        mockSession.mockError = URLError(.notConnectedToInternet)
        
        let service = NetworkService(session: mockSession)
        let expectation = XCTestExpectation(description: "Network error")
        
        // when
        service.performRequest(TestEndpoint(path: "test", method: .get))
            .sink(receiveCompletion: { completion in
                if case .failure(let error) = completion {
                    // Assert
                    if case .apiError(let apiError) = error {
                        XCTAssertEqual(apiError, .noInternet)
                    } else {
                        XCTFail("Expected .apiError(.noInternet), joe_error \(error)")
                    }
                    expectation.fulfill()
                }
            }, receiveValue: { (_: TestModel) in
                XCTFail("Request should fail")
            })
            .store(in: &cancellables)
        
        // then
        wait(for: [expectation], timeout: 1)
    }
}

