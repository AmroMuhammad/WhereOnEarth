//
//  ResponseValidatorTests.swift
//  WhereOnEarthTests
//
//  Created by Amr Muhammad on 10/04/2026.
//

import XCTest
@testable import WhereOnEarth

final class ResponseValidatorTests: XCTestCase {

    private var sut: ResponseValidator!

    override func setUp() {
        super.setUp()
        sut = ResponseValidator()
    }

    override func tearDown() {
        sut = nil
        super.tearDown()
    }

    // MARK: - Success Cases

    func test_validate_returnsData_onSuccess200() throws {
        let data = "valid".data(using: .utf8)!
        let response = HTTPURLResponse(url: URL(string: "https://test.com")!,
                                        statusCode: 200, httpVersion: nil, headerFields: nil)

        let result = try sut.validate(response: response, data: data, for: [Country].self)

        XCTAssertEqual(result, data)
    }

    func test_validate_returnsData_onSuccess299() throws {
        let data = "valid".data(using: .utf8)!
        let response = HTTPURLResponse(url: URL(string: "https://test.com")!,
                                        statusCode: 299, httpVersion: nil, headerFields: nil)

        let result = try sut.validate(response: response, data: data, for: [Country].self)

        XCTAssertEqual(result, data)
    }

    // MARK: - Error Cases

    func test_validate_throwsBadResponse_whenResponseIsNil() {
        do {
            _ = try sut.validate(response: nil, data: Data(), for: [Country].self)
            XCTFail("Expected error")
        } catch let error as APIClientError {
            XCTAssertEqual(error, .apiError(.badResponse))
        } catch {
            XCTFail("Unexpected error type: \(error)")
        }
    }

    func test_validate_throwsBadResponse_whenDataIsNil() {
        let response = HTTPURLResponse(url: URL(string: "https://test.com")!,
                                        statusCode: 200, httpVersion: nil, headerFields: nil)
        do {
            _ = try sut.validate(response: response, data: nil, for: [Country].self)
            XCTFail("Expected error")
        } catch let error as APIClientError {
            XCTAssertEqual(error, .apiError(.badResponse))
        } catch {
            XCTFail("Unexpected error type: \(error)")
        }
    }

    func test_validate_throwsNotFound_on404() {
        let response = HTTPURLResponse(url: URL(string: "https://test.com")!,
                                        statusCode: 404, httpVersion: nil, headerFields: nil)
        do {
            _ = try sut.validate(response: response, data: Data(), for: [Country].self)
            XCTFail("Expected error")
        } catch let error as APIClientError {
            XCTAssertEqual(error, .apiError(.notFound))
        } catch {
            XCTFail("Unexpected error type: \(error)")
        }
    }

    func test_validate_throwsUnauthorized_on401() {
        let response = HTTPURLResponse(url: URL(string: "https://test.com")!,
                                        statusCode: 401, httpVersion: nil, headerFields: nil)
        do {
            _ = try sut.validate(response: response, data: Data(), for: [Country].self)
            XCTFail("Expected error")
        } catch let error as APIClientError {
            XCTAssertEqual(error, .apiError(.unauthorized))
        } catch {
            XCTFail("Unexpected error type: \(error)")
        }
    }

    func test_validate_throwsForbidden_on403() {
        let response = HTTPURLResponse(url: URL(string: "https://test.com")!,
                                        statusCode: 403, httpVersion: nil, headerFields: nil)
        do {
            _ = try sut.validate(response: response, data: Data(), for: [Country].self)
            XCTFail("Expected error")
        } catch let error as APIClientError {
            XCTAssertEqual(error, .apiError(.forbidden))
        } catch {
            XCTFail("Unexpected error type: \(error)")
        }
    }

    func test_validate_throwsInternalServerError_on500() {
        let response = HTTPURLResponse(url: URL(string: "https://test.com")!,
                                        statusCode: 500, httpVersion: nil, headerFields: nil)
        do {
            _ = try sut.validate(response: response, data: Data(), for: [Country].self)
            XCTFail("Expected error")
        } catch let error as APIClientError {
            XCTAssertEqual(error, .apiError(.internalServerError))
        } catch {
            XCTFail("Unexpected error type: \(error)")
        }
    }

    func test_validate_throwsCustomMessage_whenServerReturnsErrorJSON() {
        let errorJSON = """
        {"message": "Custom server error"}
        """.data(using: .utf8)!
        let response = HTTPURLResponse(url: URL(string: "https://test.com")!,
                                        statusCode: 422, httpVersion: nil, headerFields: nil)

        do {
            _ = try sut.validate(response: response, data: errorJSON, for: [Country].self)
            XCTFail("Expected error")
        } catch let error as APIClientError {
            XCTAssertEqual(error, .custom(message: "Custom server error"))
        } catch {
            XCTFail("Unexpected error type: \(error)")
        }
    }

    func test_validate_throwsCustomMessage_whenServerReturnsErrorsArray() {
        let errorJSON = """
        {"errors": [{"message": "Field validation failed"}]}
        """.data(using: .utf8)!
        let response = HTTPURLResponse(url: URL(string: "https://test.com")!,
                                        statusCode: 422, httpVersion: nil, headerFields: nil)

        do {
            _ = try sut.validate(response: response, data: errorJSON, for: [Country].self)
            XCTFail("Expected error")
        } catch let error as APIClientError {
            XCTAssertEqual(error, .custom(message: "Field validation failed"))
        } catch {
            XCTFail("Unexpected error type: \(error)")
        }
    }

    func test_validate_throwsCustomMessage_onUnknownStatusCode() {
        let response = HTTPURLResponse(url: URL(string: "https://test.com")!,
                                        statusCode: 418, httpVersion: nil, headerFields: nil)
        do {
            _ = try sut.validate(response: response, data: Data(), for: [Country].self)
            XCTFail("Expected error")
        } catch let error as APIClientError {
            XCTAssertEqual(error, .custom(message: "Unexpected error. Code: 418"))
        } catch {
            XCTFail("Unexpected error type: \(error)")
        }
    }
}
