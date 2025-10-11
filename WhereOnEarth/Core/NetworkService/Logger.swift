//
//  Logger.swift
//  WhereOnEarth
//
//  Created by Amr Muhammad on 08/10/2025.
//

import Foundation

protocol LoggerProtocol {
    func log(request: URLRequest)
    func log(response: HTTPURLResponse, data: Data)
}

struct Logger: LoggerProtocol {
    static var shared: LoggerProtocol = Logger()
    
    func log(request: URLRequest) {
#if DEBUG
        print("➡️ Request: \(request.httpMethod ?? "UNKNOWN") \(request.url?.absoluteString ?? "")")
        if let headers = request.allHTTPHeaderFields, !headers.isEmpty {
            print("Headers: \(headers)")
        }
        if let body = request.httpBody,
           let bodyString = String(data: body, encoding: .utf8) {
            print("Body: \(bodyString)")
        }
#endif
    }
    
    func log(response: HTTPURLResponse, data: Data) {
#if DEBUG
        print("⬅️ Response: \(response.statusCode)")
        if let json = try? JSONSerialization.jsonObject(with: data, options: [.mutableContainers]),
           let prettyData = try? JSONSerialization.data(withJSONObject: json, options: .prettyPrinted),
           let jsonString = String(data: prettyData, encoding: .utf8) {
            print("Body: \(jsonString)")
        } else {
            print("Body: (Unreadable)")
        }
#endif
    }
}

