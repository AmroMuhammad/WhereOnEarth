//
//  CountriesLocalRepositoryTests.swift
//  WhereOnEarthTests
//
//  Created by Amr Muhammad on 10/04/2026.
//

import XCTest
@testable import WhereOnEarth

final class CountriesLocalRepositoryTests: XCTestCase {

    private var mockDataSource: MockCountriesLocalDataSource!
    private var sut: CountriesLocalRepository!

    override func setUp() {
        super.setUp()
        mockDataSource = MockCountriesLocalDataSource()
        sut = CountriesLocalRepository(localDataSource: mockDataSource)
    }

    override func tearDown() {
        mockDataSource = nil
        sut = nil
        super.tearDown()
    }

    // MARK: - Save/Load Countries

    func test_saveCountries_delegatesToDataSource() throws {
        let countries = CountryFactory.sampleList()

        try sut.saveCountries(countries)

        XCTAssertEqual(mockDataSource.cachedCountries.count, countries.count)
    }

    func test_loadCountries_returnsFromDataSource() throws {
        mockDataSource.cachedCountries = CountryFactory.sampleList()

        let result = try sut.loadCountries()

        XCTAssertEqual(result.count, 5)
        XCTAssertEqual(result.first?.name?.common, "Egypt")
    }

    func test_loadCountries_returnsEmpty_whenNoCache() throws {
        let result = try sut.loadCountries()

        XCTAssertTrue(result.isEmpty)
    }

    func test_saveCountries_throwsOnError() {
        mockDataSource.shouldThrow = true

        XCTAssertThrowsError(try sut.saveCountries(CountryFactory.sampleList()))
    }

    func test_loadCountries_throwsOnError() {
        mockDataSource.shouldThrow = true

        XCTAssertThrowsError(try sut.loadCountries())
    }

    // MARK: - Save/Load Selected Countries

    func test_saveSelectedCountries_delegatesToDataSource() throws {
        let countries = [CountryFactory.egypt(), CountryFactory.germany()]

        try sut.saveSelectedCountries(countries)

        XCTAssertEqual(mockDataSource.cachedSelectedCountries.count, 2)
    }

    func test_loadSelectedCountries_returnsFromDataSource() throws {
        mockDataSource.cachedSelectedCountries = [CountryFactory.egypt()]

        let result = try sut.loadSelectedCountries()

        XCTAssertEqual(result.count, 1)
        XCTAssertEqual(result.first?.name?.common, "Egypt")
    }

    func test_saveSelectedCountries_throwsOnError() {
        mockDataSource.shouldThrow = true

        XCTAssertThrowsError(try sut.saveSelectedCountries([CountryFactory.egypt()]))
    }

    func test_loadSelectedCountries_throwsOnError() {
        mockDataSource.shouldThrow = true

        XCTAssertThrowsError(try sut.loadSelectedCountries())
    }

    // MARK: - Save/Load Default Country

    func test_saveDefaultCountry_delegatesToDataSource() throws {
        let egypt = CountryFactory.egypt()

        try sut.saveDefaultCountry(egypt)

        XCTAssertEqual(mockDataSource.cachedDefaultCountry?.name?.common, "Egypt")
    }

    func test_loadDefaultCountry_returnsFromDataSource() throws {
        mockDataSource.cachedDefaultCountry = CountryFactory.egypt()

        let result = try sut.loadDefaultCountry()

        XCTAssertEqual(result?.name?.common, "Egypt")
    }

    func test_loadDefaultCountry_returnsNil_whenNoCache() throws {
        let result = try sut.loadDefaultCountry()

        XCTAssertNil(result)
    }

    func test_saveDefaultCountry_throwsOnError() {
        mockDataSource.shouldThrow = true

        XCTAssertThrowsError(try sut.saveDefaultCountry(CountryFactory.egypt()))
    }

    func test_loadDefaultCountry_throwsOnError() {
        mockDataSource.shouldThrow = true

        XCTAssertThrowsError(try sut.loadDefaultCountry())
    }
}
