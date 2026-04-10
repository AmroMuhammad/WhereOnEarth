//
//  CountriesEndpointTests.swift
//  WhereOnEarthTests
//
//  Created by Amr Muhammad on 10/04/2026.
//

import XCTest
@testable import WhereOnEarth

final class CountriesEndpointTests: XCTestCase {

    func test_getAll_hasCorrectPath() {
        let endpoint = CountriesEndpoint.getAll

        XCTAssertEqual(endpoint.path, URLs.allPath.rawValue)
    }

    func test_getAll_usesGetMethod() {
        let endpoint = CountriesEndpoint.getAll

        XCTAssertEqual(endpoint.method, .get)
    }

    func test_getAll_hasCorrectBaseURL() {
        let endpoint = CountriesEndpoint.getAll

        XCTAssertEqual(endpoint.baseURL.absoluteString, URLs.baseURL.rawValue)
    }

    func test_getAll_hasQueryParameters() {
        let endpoint = CountriesEndpoint.getAll

        guard case .urlQuery(let params) = endpoint.apiType else {
            XCTFail("Expected urlQuery apiType")
            return
        }

        let fields = params?["fields"] as? String
        XCTAssertNotNil(fields)
        XCTAssertTrue(fields!.contains("name"))
        XCTAssertTrue(fields!.contains("capital"))
        XCTAssertTrue(fields!.contains("flags"))
        XCTAssertTrue(fields!.contains("currencies"))
        XCTAssertTrue(fields!.contains("languages"))
        XCTAssertTrue(fields!.contains("cca2"))
        XCTAssertTrue(fields!.contains("population"))
    }

    func test_getAll_usesDefaultCachePolicy() {
        let endpoint = CountriesEndpoint.getAll

        XCTAssertEqual(endpoint.cachePolicy, .useProtocolCachePolicy)
    }

    func test_getAll_usesDefaultTimeout() {
        let endpoint = CountriesEndpoint.getAll

        XCTAssertEqual(endpoint.timeoutInterval, 30)
    }

    func test_getAll_hasNilHeaders() {
        let endpoint = CountriesEndpoint.getAll

        XCTAssertNil(endpoint.headers)
    }
}
