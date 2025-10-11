//
//  HomeViewModelTests.swift
//  WhereOnEarthTests
//
//  Created by Amr Muhammad on 11/10/2025.
//

import XCTest
import Combine
@testable import WhereOnEarth

class HomeViewModelTests: XCTestCase {
    
    var viewModel: HomeViewModel!
    var mockUseCase: MockFetchCountriesUseCase!
    var mockCache: CachingManagerContract!
    var mockLocationManager: MockLocationManager!
    var cancellables: Set<AnyCancellable>!
    
    let testCountries: Countries = [
        Country(
            id: "123",
            name: "United States",
            capital: "Washington, D.C.",
            currency: Currency(code: "", name: "US Dollar", symbol: "$"),
            language: "English",
            flag: "us.png"
        ),
        Country(
            id: "456",
            name: "Egypt",
            capital: "Cairo",
            currency: Currency(code: "", name: "Egyptian Pound", symbol: "£"),
            language: "Arabic",
            flag: "eg.png"
        ),
        Country(
            id: "789",
            name: "France",
            capital: "Paris",
            currency: Currency(code: "", name: "Euro", symbol: "€"),
            language: "French",
            flag: "fr.png"
        )
    ]
    
    override func setUp() {
        super.setUp()
        mockUseCase = MockFetchCountriesUseCase()
        mockCache = MockCachingManager()
        mockLocationManager = MockLocationManager()
        cancellables = Set<AnyCancellable>()
        
        viewModel = HomeViewModel(
            countriesUseCase: mockUseCase,
            locationManager: mockLocationManager,
            cachingManager: mockCache
        )
    }
    
    override func tearDown() {
        viewModel = nil
        mockUseCase = nil
        mockCache = nil
        mockLocationManager = nil
        cancellables = nil
        super.tearDown()
    }
    
    // MARK: - Initial State Tests
    func test_initialState() {
        XCTAssertTrue(viewModel.allCountries.isEmpty)
        XCTAssertTrue(viewModel.selectedCountriesList.isEmpty)
        XCTAssertFalse(viewModel.exceedMaxSelectedCountries)
        XCTAssertNil(viewModel.isSuccess)
        XCTAssertNil(viewModel.showError)
        XCTAssertTrue(viewModel.errorMessage.isEmpty)
    }
    
    // MARK: - Country Fetching Tests
    func test_getAllCountries_success() {
        // Given
        mockUseCase.result = .success(testCountries)
        let expectation = XCTestExpectation(description: "Countries loaded")
        
        // When
        viewModel.$allCountries
            .dropFirst()
            .sink { countries in
                // Then
                XCTAssertEqual(countries.count, 3)
                XCTAssertEqual(countries[0].name, "United States")
                XCTAssertEqual(self.viewModel.isSuccess, true)
                XCTAssertNil(self.viewModel.showError)
                expectation.fulfill()
            }
            .store(in: &cancellables)
        
        viewModel.getAllCountries()
        
        wait(for: [expectation], timeout: 1)
    }
    
    func test_getAllCountries_failure() {
        // Given
        mockUseCase.result = .failure(.apiError(.noInternet))
        let expectation = XCTestExpectation(description: "Error shown")
        
        // When
        viewModel.$showError
            .dropFirst()
            .sink { showError in
                // Then
                XCTAssertEqual(showError, true)
                XCTAssertEqual(self.viewModel.errorMessage, "No Internet Connection, plaese try again")
                XCTAssertNil(self.viewModel.isSuccess)
                expectation.fulfill()
            }
            .store(in: &cancellables)
        
        viewModel.getAllCountries()
        
        wait(for: [expectation], timeout: 1)
    }
    
    // MARK: - Search Functionality Tests
    func test_searchList_emptyQuery() {
        // Given
        viewModel.allCountries = testCountries
        viewModel.searchQuery = ""
        
        // Then
        XCTAssertEqual(viewModel.searchList.count, 3)
    }
    
    func test_searchList_withQuery() {
        // Given
        viewModel.allCountries = testCountries
        viewModel.searchQuery = "united"
        
        // Then
        XCTAssertEqual(viewModel.searchList.count, 1)
        XCTAssertEqual(viewModel.searchList.first?.name, "United States")
    }
    
    func test_searchList_caseInsensitive() {
        // Given
        viewModel.allCountries = testCountries
        viewModel.searchQuery = "eGyPt"
        
        // Then
        XCTAssertEqual(viewModel.searchList.count, 1)
        XCTAssertEqual(viewModel.searchList.first?.name, "Egypt")
    }
    
    // MARK: - Location Tests
    func test_getCurrentUserCountry_notFound_defaultsToEgypt() {
        // Given
        viewModel.allCountries = testCountries
        mockLocationManager.mockUserCountry = "Unknown Country"
        
        // When
        let country = viewModel.getCurrentUserCountry()
        
        // Then
        XCTAssertEqual(country?.name, "Egypt")
    }
    
    // MARK: - Country Selection Tests
    func test_countrySelection_addsCountry() {
        // Given
        let country = testCountries[0]
        
        // When
        viewModel.countrySelection(country)
        
        // Then
        XCTAssertEqual(viewModel.selectedCountriesList.count, 1)
        XCTAssertEqual(viewModel.selectedCountriesList.first?.name, "United States")
        XCTAssertFalse(viewModel.exceedMaxSelectedCountries)
    }
    
    func test_countrySelection_removesCountry() {
        // Given
        viewModel.selectedCountriesList = [testCountries[0]]
        
        // When
        viewModel.countrySelection(testCountries[0])
        
        // Then
        XCTAssertTrue(viewModel.selectedCountriesList.isEmpty)
    }
    
    func test_countrySelection_maxLimitReached() {
        // Given
        let maxCountries = Array(repeating: testCountries[0], count: viewModel.maxSelectedCountries)
        viewModel.selectedCountriesList = maxCountries
        let newCountry = testCountries[1]
        
        // When
        viewModel.countrySelection(newCountry)
        
        // Then
        XCTAssertEqual(viewModel.selectedCountriesList.count, viewModel.maxSelectedCountries)
        XCTAssertTrue(viewModel.exceedMaxSelectedCountries)
    }
    
    // MARK: - Cache Operations Tests
    func test_countrySelection_persistsOnConfirm() {
        // Given
        let country = testCountries[0]
        viewModel.countrySelection(country)
        
        // When
        viewModel.saveSelectedCountries()
        
        // Then
        let loaded = mockCache.load()
        XCTAssertEqual(loaded.count, 1)
        XCTAssertEqual(loaded.first?.name, "United States")
    }
    
    func test_deleteCountry_updatesCache() {
        // Given
        viewModel.selectedCountriesList = testCountries
        viewModel.saveSelectedCountries()
        
        // When
        viewModel.deleteCountry(testCountries[0])
        
        // Then
        let loaded = mockCache.load()
        XCTAssertEqual(loaded.count, 2)
        XCTAssertEqual(loaded.first?.name, "Egypt")
    }
    
    func test_deleteCountry_removesFromListAndCache() {
        // Given
        viewModel.selectedCountriesList = [testCountries[0], testCountries[1]]
        viewModel.saveSelectedCountries() // First save to cache
        
        // Verify initial cache state
        var cachedCountries = mockCache.load()
        XCTAssertEqual(cachedCountries.count, 2)
        
        // When
        viewModel.deleteCountry(testCountries[0])
        
        // Then
        // Verify in-memory list
        XCTAssertEqual(viewModel.selectedCountriesList.count, 1)
        XCTAssertEqual(viewModel.selectedCountriesList.first?.name, "Egypt")
        
        // Verify cache was updated
        cachedCountries = mockCache.load()
        XCTAssertEqual(cachedCountries.count, 1)
        XCTAssertEqual(cachedCountries.first?.name, "Egypt")
    }
}

