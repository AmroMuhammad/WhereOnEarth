//
//  HomeViewModelTests.swift
//  WhereOnEarthTests
//
//  Created by Amr Muhammad on 10/04/2026.
//

import XCTest
import Combine
@testable import WhereOnEarth

@MainActor
final class HomeViewModelTests: XCTestCase {

    private var mockUseCase: MockFetchCountriesUseCase!
    private var mockLocationService: MockLocationService!
    private var mockLocalRepo: MockCountriesLocalRepository!
    private var sut: HomeViewModel!
    private var cancellables: Set<AnyCancellable>!

    override func setUp() {
        super.setUp()
        mockUseCase = MockFetchCountriesUseCase()
        mockLocationService = MockLocationService()
        mockLocalRepo = MockCountriesLocalRepository()
        cancellables = []
        sut = HomeViewModel(
            countriesUseCase: mockUseCase,
            locationService: mockLocationService,
            localRepo: mockLocalRepo
        )
    }

    override func tearDown() {
        mockUseCase = nil
        mockLocationService = nil
        mockLocalRepo = nil
        sut = nil
        cancellables = nil
        super.tearDown()
    }

    // MARK: - Initial State

    func test_initialState_isIdle() {
        XCTAssertEqual(sut.state, .idle)
    }

    func test_initialState_hasEmptyCountries() {
        XCTAssertTrue(sut.allCountries.isEmpty)
    }

    func test_initialState_hasNoDefaultCountry() {
        XCTAssertNil(sut.defaultCountry)
    }

    func test_initialState_hasEmptySearchQuery() {
        XCTAssertEqual(sut.searchQuery, "")
    }

    func test_initialState_exceedMaxSelectedCountries_isFalse() {
        XCTAssertFalse(sut.exceedMaxSelectedCountries)
    }

    // MARK: - Init Restores Persisted Selection

    func test_init_restoresSelectedCountries() {
        let egypt = CountryFactory.egypt()
        mockLocalRepo.savedSelectedCountries = [egypt]

        let vm = HomeViewModel(
            countriesUseCase: mockUseCase,
            locationService: mockLocationService,
            localRepo: mockLocalRepo
        )

        XCTAssertEqual(vm.selectedCountriesList.count, 1)
        XCTAssertEqual(vm.selectedCountriesList.first?.name?.common, "Egypt")
    }

    // MARK: - getAllCountries

    func test_getAllCountries_setsLoadedState() async {
        let countries = CountryFactory.sampleList()
        mockUseCase.result = .success(countries)
        mockLocationService.countryToReturn = "Egypt"

        let expectation = XCTestExpectation(description: "State becomes loaded")
        sut.$state
            .dropFirst()
            .sink { state in
                if state == .loaded { expectation.fulfill() }
            }
            .store(in: &cancellables)

        sut.getAllCountries()
        await fulfillment(of: [expectation], timeout: 2)

        XCTAssertEqual(sut.state, .loaded)
        XCTAssertEqual(sut.allCountries.count, countries.count)
    }

    func test_getAllCountries_setsLoadingState() {
        let expectation = XCTestExpectation(description: "State becomes loading")
        mockUseCase.result = .success(CountryFactory.sampleList())
        mockLocationService.countryToReturn = "Egypt"

        sut.$state
            .dropFirst()
            .sink { state in
                if state == .loading { expectation.fulfill() }
            }
            .store(in: &cancellables)

        sut.getAllCountries()

        wait(for: [expectation], timeout: 1)
    }

    func test_getAllCountries_setsFailedState() async {
        mockUseCase.result = .failure(APIClientError.apiError(.noInternet))

        let expectation = XCTestExpectation(description: "State becomes failed")
        sut.$state
            .dropFirst()
            .sink { state in
                if case .failed = state { expectation.fulfill() }
            }
            .store(in: &cancellables)

        sut.getAllCountries()
        await fulfillment(of: [expectation], timeout: 2)

        if case .failed(let message) = sut.state {
            XCTAssertFalse(message.isEmpty)
        } else {
            XCTFail("Expected failed state")
        }
    }

    // MARK: - Search

    func test_searchList_filtersCorrectly() {
        sut.allCountries = CountryFactory.sampleList()
        sut.searchQuery = "Egy"

        XCTAssertEqual(sut.searchList.count, 1)
        XCTAssertEqual(sut.searchList.first?.name?.common, "Egypt")
    }

    func test_searchList_returnsAll_whenQueryEmpty() {
        sut.allCountries = CountryFactory.sampleList()
        sut.searchQuery = ""

        XCTAssertEqual(sut.searchList.count, sut.allCountries.count)
    }

    func test_searchList_caseInsensitive() {
        sut.allCountries = CountryFactory.sampleList()
        sut.searchQuery = "egypt"

        XCTAssertEqual(sut.searchList.count, 1)
        XCTAssertEqual(sut.searchList.first?.name?.common, "Egypt")
    }

    func test_searchList_returnsEmpty_whenNoMatch() {
        sut.allCountries = CountryFactory.sampleList()
        sut.searchQuery = "XYZ"

        XCTAssertTrue(sut.searchList.isEmpty)
    }

    func test_searchList_matchesPartialName() {
        sut.allCountries = CountryFactory.sampleList()
        sut.searchQuery = "an"

        let names = sut.searchList.compactMap { $0.name?.common }
        XCTAssertTrue(names.contains("Germany"))
        XCTAssertTrue(names.contains("France"))
        XCTAssertTrue(names.contains("Japan"))
    }

    // MARK: - Country Selection

    func test_countrySelection_addsCountry() {
        let egypt = CountryFactory.egypt()
        sut.countrySelection(egypt)

        XCTAssertEqual(sut.selectedCountriesList.count, 1)
        XCTAssertTrue(sut.selectedCountriesList.contains(egypt))
    }

    func test_countrySelection_togglesOff() {
        let egypt = CountryFactory.egypt()
        sut.countrySelection(egypt)
        sut.countrySelection(egypt)

        XCTAssertTrue(sut.selectedCountriesList.isEmpty)
    }

    func test_countrySelection_limitsToFive() {
        let countries = [
            CountryFactory.egypt(),
            CountryFactory.germany(),
            CountryFactory.france(),
            CountryFactory.japan(),
            CountryFactory.brazil()
        ]
        countries.forEach { sut.countrySelection($0) }

        let extra = CountryFactory.make(name: "Extra", cca2: "EX")
        sut.countrySelection(extra)

        XCTAssertEqual(sut.selectedCountriesList.count, 5)
        XCTAssertTrue(sut.exceedMaxSelectedCountries)
        XCTAssertFalse(sut.selectedCountriesList.contains(extra))
    }

    func test_countrySelection_resetsExceedFlag_whenRemovingCountry() {
        let countries = [
            CountryFactory.egypt(),
            CountryFactory.germany(),
            CountryFactory.france(),
            CountryFactory.japan(),
            CountryFactory.brazil()
        ]
        countries.forEach { sut.countrySelection($0) }

        let extra = CountryFactory.make(name: "Extra", cca2: "EX")
        sut.countrySelection(extra)
        XCTAssertTrue(sut.exceedMaxSelectedCountries)

        sut.countrySelection(CountryFactory.egypt())
        XCTAssertFalse(sut.exceedMaxSelectedCountries)
        XCTAssertEqual(sut.selectedCountriesList.count, 4)
    }

    func test_countrySelection_persistsToLocalRepo() {
        let egypt = CountryFactory.egypt()
        sut.countrySelection(egypt)

        XCTAssertEqual(mockLocalRepo.savedSelectedCountries.count, 1)
    }

    func test_countrySelection_multipleAdds() {
        sut.countrySelection(CountryFactory.egypt())
        sut.countrySelection(CountryFactory.germany())
        sut.countrySelection(CountryFactory.france())

        XCTAssertEqual(sut.selectedCountriesList.count, 3)
        XCTAssertEqual(mockLocalRepo.savedSelectedCountries.count, 3)
    }

    // MARK: - Delete Country

    func test_deleteCountry_removesFromList() {
        let egypt = CountryFactory.egypt()
        sut.countrySelection(egypt)
        sut.deleteCountry(egypt)

        XCTAssertTrue(sut.selectedCountriesList.isEmpty)
    }

    func test_deleteCountry_persistsChange() {
        let egypt = CountryFactory.egypt()
        sut.countrySelection(egypt)
        sut.deleteCountry(egypt)

        XCTAssertTrue(mockLocalRepo.savedSelectedCountries.isEmpty)
    }

    func test_deleteCountry_doesNothingIfNotSelected() {
        sut.countrySelection(CountryFactory.egypt())
        sut.deleteCountry(CountryFactory.germany())

        XCTAssertEqual(sut.selectedCountriesList.count, 1)
    }

    // MARK: - Default Country Resolution

    func test_resolveDefaultCountry_usesLocation() async {
        let countries = CountryFactory.sampleList()
        mockUseCase.result = .success(countries)
        mockLocationService.countryToReturn = "Egypt"

        let expectation = XCTestExpectation(description: "State loaded")
        sut.$state
            .dropFirst()
            .sink { state in
                if state == .loaded { expectation.fulfill() }
            }
            .store(in: &cancellables)

        sut.getAllCountries()
        await fulfillment(of: [expectation], timeout: 2)

        XCTAssertEqual(sut.defaultCountry?.name?.common, "Egypt")
    }

    func test_resolveDefaultCountry_savesToLocalRepo() async {
        let countries = CountryFactory.sampleList()
        mockUseCase.result = .success(countries)
        mockLocationService.countryToReturn = "Egypt"

        let expectation = XCTestExpectation(description: "State loaded")
        sut.$state
            .dropFirst()
            .sink { state in
                if state == .loaded { expectation.fulfill() }
            }
            .store(in: &cancellables)

        sut.getAllCountries()
        await fulfillment(of: [expectation], timeout: 2)

        XCTAssertEqual(mockLocalRepo.savedDefaultCountry?.name?.common, "Egypt")
    }

    func test_resolveDefaultCountry_fallsBackToCached() async {
        let countries = CountryFactory.sampleList()
        mockUseCase.result = .success(countries)
        mockLocationService.countryToReturn = nil
        mockLocalRepo.savedDefaultCountry = CountryFactory.germany()

        let expectation = XCTestExpectation(description: "State loaded")
        sut.$state
            .dropFirst()
            .sink { state in
                if state == .loaded { expectation.fulfill() }
            }
            .store(in: &cancellables)

        sut.getAllCountries()
        await fulfillment(of: [expectation], timeout: 2)

        XCTAssertEqual(sut.defaultCountry?.name?.common, "Germany")
    }

    func test_resolveDefaultCountry_fallsToEgypt_whenNoCacheAndNoLocation() async {
        let countries = CountryFactory.sampleList()
        mockUseCase.result = .success(countries)
        mockLocationService.countryToReturn = nil

        let expectation = XCTestExpectation(description: "State loaded")
        sut.$state
            .dropFirst()
            .sink { state in
                if state == .loaded { expectation.fulfill() }
            }
            .store(in: &cancellables)

        sut.getAllCountries()
        await fulfillment(of: [expectation], timeout: 2)

        XCTAssertEqual(sut.defaultCountry?.cca2, "EG")
    }

    func test_resolveDefaultCountry_handlesUnknownLocationCountry() async {
        let countries = CountryFactory.sampleList()
        mockUseCase.result = .success(countries)
        mockLocationService.countryToReturn = "Atlantis"

        let expectation = XCTestExpectation(description: "State loaded")
        sut.$state
            .dropFirst()
            .sink { state in
                if state == .loaded { expectation.fulfill() }
            }
            .store(in: &cancellables)

        sut.getAllCountries()
        await fulfillment(of: [expectation], timeout: 2)

        XCTAssertEqual(sut.defaultCountry?.cca2, "EG")
    }
}
