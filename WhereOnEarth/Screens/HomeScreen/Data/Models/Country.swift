//
//  Country.swift
//  WhereOnEarth
//
//  Created by Amr Muhammad on 09/10/2025.
//

import Foundation

typealias Countries = [Country]

// MARK: - Country
struct Country: Codable, Hashable, Identifiable {
    let flags: Flags?
    let name: Name?
    let cca2: String?
    let currencies: [String: Currency]?
    let capital: [String]?
    let subregion: String?
    let languages: [String: String]?
    let population: Int?
    let timezones: [String]?
    
    var id: String {
        name?.common ?? UUID().uuidString
    }
    
    static func == (lhs: Country, rhs: Country) -> Bool {
        lhs.name?.common == rhs.name?.common
    }
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(name?.common)
    }
}

// MARK: - Currency
struct Currency: Codable {
    let name, symbol: String?
}

// MARK: - Flags
struct Flags: Codable {
    let png: String?
    let svg: String?
    let alt: String?
}

// MARK: - Name
struct Name: Codable {
    let common, official: String?
    let nativeName: [String: NativeName]?
}

// MARK: - NativeName
struct NativeName: Codable {
    let official, common: String?
}
