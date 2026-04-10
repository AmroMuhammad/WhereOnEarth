//
//  NetworkServiceTests.swift
//  WhereOnEarthTests
//
//  Created by Amr Muhammad on 10/04/2026.
//

import XCTest
@testable import WhereOnEarth

final class NetworkServiceTests: XCTestCase {

    private var mockSession: MockURLSession!
    private var mockValidator: MockResponseValidator!
    private var sut: NetworkService!

    override func setUp() {
        super.setUp()
        mockSession = MockURLSession()
        mockValidator = MockResponseValidator()
        sut = NetworkService(
            session: mockSession,
            requestBuilder: URLRequestBuilder(),
            decoder: JSONDecoder(),
            validator: mockValidator,
            logger: NoOpLogger()
        )
    }

    override func tearDown() {
        mockSession = nil
        mockValidator = nil
        sut = nil
        super.tearDown()
    }

    // MARK: - Async Success

    func test_performRequest_decodesSuccessfully() async throws {
        let countries = CountryFactory.sampleList()
        let jsonData = try JSONEncoder().encode(countries)
        let response = HTTPURLResponse(url: URL(string: "https://test.com")!,
                                        statusCode: 200, httpVersion: nil, headerFields: nil)!

        mockSession.dataResult = .success((jsonData, response))
        mockValidator.dataToReturn = jsonData

        let result: [Country] = try await sut.performRequest(TestEndpoint.test)

        XCTAssertEqual(result.count, countries.count)
        XCTAssertEqual(result.first?.name?.common, "Egypt")
    }

    // MARK: - Async Error Cases

    func test_performRequest_throwsOnBadStatus() async {
        let response = HTTPURLResponse(url: URL(string: "https://test.com")!,
                                        statusCode: 404, httpVersion: nil, headerFields: nil)!

        mockSession.dataResult = .success((Data(), response))
        mockValidator.errorToThrow = APIClientError.apiError(.notFound)

        do {
            let _: [Country] = try await sut.performRequest(TestEndpoint.test)
            XCTFail("Expected error")
        } catch let error as APIClientError {
            XCTAssertEqual(error, .apiError(.notFound))
        } catch {
            XCTFail("Unexpected error type: \(error)")
        }
    }

    func test_performRequest_throwsDecodingError() async {
        let invalidJSON = "not json".data(using: .utf8)!
        let response = HTTPURLResponse(url: URL(string: "https://test.com")!,
                                        statusCode: 200, httpVersion: nil, headerFields: nil)!

        mockSession.dataResult = .success((invalidJSON, response))
        mockValidator.dataToReturn = invalidJSON

        do {
            let _: [Country] = try await sut.performRequest(TestEndpoint.test)
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

    func test_performRequest_throwsNoInternet() async {
        mockSession.dataResult = .failure(URLError(.notConnectedToInternet))

        do {
            let _: [Country] = try await sut.performRequest(TestEndpoint.test)
            XCTFail("Expected error")
        } catch let error as APIClientError {
            XCTAssertEqual(error, .apiError(.noInternet))
        } catch {
            XCTFail("Unexpected error type: \(error)")
        }
    }

    func test_performRequest_throwsTimeout() async {
        mockSession.dataResult = .failure(URLError(.timedOut))

        do {
            let _: [Country] = try await sut.performRequest(TestEndpoint.test)
            XCTFail("Expected error")
        } catch let error as APIClientError {
            XCTAssertEqual(error, .apiError(.requestTimeout))
        } catch {
            XCTFail("Unexpected error type: \(error)")
        }
    }

    func test_performRequest_throwsUnknown_forOtherURLErrors() async {
        mockSession.dataResult = .failure(URLError(.cannotFindHost))

        do {
            let _: [Country] = try await sut.performRequest(TestEndpoint.test)
            XCTFail("Expected error")
        } catch let error as APIClientError {
            if case .unknown = error {
                // Expected
            } else {
                XCTFail("Expected unknown error, got: \(error)")
            }
        } catch {
            XCTFail("Unexpected error type: \(error)")
        }
    }

    func test_performRequest_propagatesAPIClientError_fromValidator() async {
        let response = HTTPURLResponse(url: URL(string: "https://test.com")!,
                                        statusCode: 500, httpVersion: nil, headerFields: nil)!
        mockSession.dataResult = .success((Data(), response))
        mockValidator.errorToThrow = APIClientError.apiError(.internalServerError)

        do {
            let _: [Country] = try await sut.performRequest(TestEndpoint.test)
            XCTFail("Expected error")
        } catch let error as APIClientError {
            XCTAssertEqual(error, .apiError(.internalServerError))
        } catch {
            XCTFail("Unexpected error type: \(error)")
        }
    }
}
