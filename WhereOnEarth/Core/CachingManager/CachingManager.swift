//
//  CachingManager.swift
//  WhereOnEarth
//
//  Created by Amr Muhammad on 11/10/2025.
//

import Foundation
import Combine

protocol CachingManagerContract {
    func save(_ countries: Countries)
    func load() -> Countries
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
    
    func save(_ countries: Countries) {
        let encoder = JSONEncoder()
        if let data = try? encoder.encode(countries) {
            userDefaults.set(data, forKey: key)
        }
    }
    
    func load() -> Countries {
        guard let data = userDefaults.data(forKey: key) else { return [] }
        let decoder = JSONDecoder()
        return (try? decoder.decode(Countries.self, from: data)) ?? []
    }
}
