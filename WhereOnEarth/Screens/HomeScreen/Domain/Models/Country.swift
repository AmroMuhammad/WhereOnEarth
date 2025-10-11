//
//  Country.swift
//  WhereOnEarth
//
//  Created by Amr Muhammad on 11/10/2025.
//

import Foundation

typealias Countries = [Country]

public struct Country: Identifiable, Hashable, Codable {
    public let id: String
    public let name: String
    public let capital: String
    public let currency: Currency
    public let language: String
    public let flag: String

    public init(
        id: String,
        name: String,
        capital: String,
        currency: Currency,
        language: String,
        flag: String
    ) {
        self.id = id
        self.name = name
        self.capital = capital
        self.currency = currency
        self.language = language
        self.flag = flag
    }
}
