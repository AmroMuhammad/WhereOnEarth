//
//  CachingManager.swift
//  WhereOnEarth
//
//  Created by Amr Muhammad on 11/10/2025.
//

import Foundation
import Combine

protocol CachingManagerContract {
    func save(_ countries: [Country])
    func load() -> [Country]
}

class CachingManager: CachingManagerContract {
    
    private let userDefaults: UserDefaults
    private let key: String
    
    init(
        userDefaults: UserDefaults = .standard,
        key: String = Constants.Localization.cacheKey
    ) {
        self.userDefaults = userDefaults
        self.key = key
    }
    
    func save(_ countries: [Country]) {
        let encoder = JSONEncoder()
        if let data = try? encoder.encode(countries) {
            userDefaults.set(data, forKey: key)
        }
    }
    
    func load() -> [Country] {
        guard let data = userDefaults.data(forKey: key) else { return [] }
        let decoder = JSONDecoder()
        return (try? decoder.decode([Country].self, from: data)) ?? []
    }
}
