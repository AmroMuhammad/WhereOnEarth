//
//  URLRequestBuilderTests.swift
//  WhereOnEarthTests
//
//  Created by Amr Muhammad on 10/04/2026.
//

import XCTest
@testable import WhereOnEarth

final class URLRequestBuilderTests: XCTestCase {

    private var sut: URLRequestBuilder!

    override func setUp() {
        super.setUp()
        sut = URLRequestBuilder()
    }

    override func tearDown() {
        sut = nil
        super.tearDown()
    }

    // MARK: - Basic Request Building

    func test_buildRequest_setsCorrectHTTPMethod() throws {
        let request = try sut.buildRequest(from: TestEndpoint.test)

        XCTAssertEqual(request.httpMethod, "GET")
    }

    func test_buildRequest_setsCorrectURL() throws {
        let request = try sut.buildRequest(from: TestEndpoint.test)

        XCTAssertTrue(request.url!.absoluteString.contains("test"))
    }

    func test_buildRequest_setsTimeout() throws {
        let request = try sut.buildRequest(from: TestEndpoint.test)

        XCTAssertEqual(request.timeoutInterval, 30)
    }

    // MARK: - Query Parameters

    func test_buildRequest_addsQueryParameters() throws {
        let request = try sut.buildRequest(from: TestEndpoint.withQuery)

        let url = request.url!.absoluteString
        XCTAssertTrue(url.contains("key=value"))
        XCTAssertTrue(url.contains("page=1"))
    }

    // MARK: - JSON Body

    func test_buildRequest_setsJSONBody() throws {
        let request = try sut.buildRequest(from: TestEndpoint.withBody)

        XCTAssertNotNil(request.httpBody)
        XCTAssertEqual(request.httpMethod, "POST")
        XCTAssertEqual(request.value(forHTTPHeaderField: "Content-Type"), "application/json")

        let body = try JSONSerialization.jsonObject(with: request.httpBody!) as? [String: Any]
        XCTAssertEqual(body?["name"] as? String, "test")
    }

    // MARK: - Headers

    func test_buildRequest_setsCustomHeaders() throws {
        let request = try sut.buildRequest(from: TestEndpoint.withHeaders)

        XCTAssertEqual(request.value(forHTTPHeaderField: "Authorization"), "Bearer token123")
    }

    // MARK: - Countries Endpoint

    func test_buildRequest_countriesEndpoint_buildsCorrectly() throws {
        let request = try sut.buildRequest(from: CountriesEndpoint.getAll)

        let url = request.url!.absoluteString
        XCTAssertTrue(url.contains(URLs.baseURL.rawValue))
        XCTAssertTrue(url.contains(URLs.allPath.rawValue))
        XCTAssertTrue(url.contains("fields="))
        XCTAssertEqual(request.httpMethod, "GET")
    }
}
