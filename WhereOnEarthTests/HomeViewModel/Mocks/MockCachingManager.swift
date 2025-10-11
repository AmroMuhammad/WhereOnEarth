//
//  MockCachingManager.swift
//  WhereOnEarthTests
//
//  Created by Amr Muhammad on 11/10/2025.
//

import XCTest
import Combine
@testable import WhereOnEarth

class MockCachingManager: CachingManagerContract {
    private var mockStorage = [String: Data]()
    
    func save(_ countries: [Country]) {
        let encoder = JSONEncoder()
        mockStorage["storageKey"] = try? encoder.encode(countries)
    }
    
    func load() -> [Country] {
        guard let data = mockStorage["storageKey"] else { return [] }
        let decoder = JSONDecoder()
        return (try? decoder.decode([Country].self, from: data)) ?? []
    }
}
