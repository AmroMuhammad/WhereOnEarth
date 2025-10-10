//
//  CountryMapper.swift
//  WhereOnEarth
//
//  Created by Amr Muhammad on 11/10/2025.
//

import Foundation

enum CountryMapper {
    static func map(_ dto: CountryDTO) -> Country {
        let currencies = dto.currencies?.map { key, value in
            Currency(code: key, name: value.name, symbol: value.symbol)
        } ?? []

        return Country(
            id: dto.id,
            name: dto.name?.common ?? "-",
            capital: dto.capital?.first ?? "-",
            currency: currencies.first ?? Currency(code: "-", name: "-", symbol: "-"),
            language: dto.languages?.values.first ?? "-",
            flag: dto.flags?.png ?? ""
        )
    }
}
