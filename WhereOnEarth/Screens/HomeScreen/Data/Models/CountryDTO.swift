//
//  Country.swift
//  WhereOnEarth
//
//  Created by Amr Muhammad on 09/10/2025.
//

import Foundation

// MARK: - CountryDTO
struct CountryDTO: Codable, Hashable, Identifiable {
    let flags: FlagsDTO?
    let name: NameDTO?
    let cca2: String?
    let currencies: [String: CurrencyDTO]?
    let capital: [String]?
    let subregion: String?
    let languages: [String: String]?
    let population: Int?
    let timezones: [String]?
    
    var id: String {
        name?.common ?? UUID().uuidString
    }
    
    static func == (lhs: CountryDTO, rhs: CountryDTO) -> Bool {
        lhs.name?.common == rhs.name?.common
    }
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(name?.common)
    }
}

// MARK: - CurrencyDTO
struct CurrencyDTO: Codable {
    let name, symbol: String?
    
    var compinedName: String {
        "\(name ?? "") (\(symbol ?? ""))"
    }
}

// MARK: - FlagsDTO
struct FlagsDTO: Codable {
    let png: String?
    let svg: String?
    let alt: String?
}

// MARK: - NameDTO
struct NameDTO: Codable {
    let common, official: String?
    let nativeName: [String: NativeNameDTO]?
}

// MARK: - NativeNameDTO
struct NativeNameDTO: Codable {
    let official, common: String?
}
