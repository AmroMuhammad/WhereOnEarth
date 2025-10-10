//
//  Currency.swift
//  WhereOnEarth
//
//  Created by Amr Muhammad on 11/10/2025.
//

import Foundation

public struct Currency: Hashable, Codable {
    public let code: String?
    public let name: String?
    public let symbol: String?
    
    var compinedName: String {
        "\(name ?? "") (\(symbol ?? ""))"
    }
}
