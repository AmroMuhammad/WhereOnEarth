//
//  CachedCountry.swift
//  WhereOnEarth
//
//  Created by Amr Muhammad on 10/04/2026.
//

import Foundation
import SwiftData

@Model
final class CachedCountry {
    @Attribute(.unique) var cca2: String
    var commonName: String
    var officialName: String
    var capitalCity: String
    var currencyCode: String
    var currencyName: String
    var currencySymbol: String
    var flagPNG: String
    var flagSVG: String
    var flagAlt: String
    var subregion: String
    var population: Int
    var languagesJSON: String
    var timezonesJSON: String
    var cachedAt: Date

    init(
        cca2: String,
        commonName: String,
        officialName: String,
        capitalCity: String,
        currencyCode: String,
        currencyName: String,
        currencySymbol: String,
        flagPNG: String,
        flagSVG: String,
        flagAlt: String,
        subregion: String,
        population: Int,
        languagesJSON: String,
        timezonesJSON: String,
        cachedAt: Date = Date()
    ) {
        self.cca2 = cca2
        self.commonName = commonName
        self.officialName = officialName
        self.capitalCity = capitalCity
        self.currencyCode = currencyCode
        self.currencyName = currencyName
        self.currencySymbol = currencySymbol
        self.flagPNG = flagPNG
        self.flagSVG = flagSVG
        self.flagAlt = flagAlt
        self.subregion = subregion
        self.population = population
        self.languagesJSON = languagesJSON
        self.timezonesJSON = timezonesJSON
        self.cachedAt = cachedAt
    }
}

// MARK: - Mapping

extension CachedCountry {

    convenience init(from country: Country) {
        let currencyEntry = country.currencies?.first
        let languages = (try? JSONEncoder().encode(country.languages ?? [:])) ?? Data()
        let timezones = (try? JSONEncoder().encode(country.timezones ?? [])) ?? Data()

        self.init(
            cca2: country.cca2 ?? "",
            commonName: country.name?.common ?? "",
            officialName: country.name?.official ?? "",
            capitalCity: country.capital?.first ?? "",
            currencyCode: currencyEntry?.key ?? "",
            currencyName: currencyEntry?.value.name ?? "",
            currencySymbol: currencyEntry?.value.symbol ?? "",
            flagPNG: country.flags?.png ?? "",
            flagSVG: country.flags?.svg ?? "",
            flagAlt: country.flags?.alt ?? "",
            subregion: country.subregion ?? "",
            population: country.population ?? 0,
            languagesJSON: String(data: languages, encoding: .utf8) ?? "{}",
            timezonesJSON: String(data: timezones, encoding: .utf8) ?? "[]"
        )
    }

    func toCountry() -> Country {
        let languages = (try? JSONDecoder().decode([String: String].self, from: Data(languagesJSON.utf8))) ?? [:]
        let timezones = (try? JSONDecoder().decode([String].self, from: Data(timezonesJSON.utf8))) ?? []

        return Country(
            flags: Flags(png: flagPNG, svg: flagSVG, alt: flagAlt),
            name: Name(common: commonName, official: officialName, nativeName: nil),
            cca2: cca2,
            currencies: currencyCode.isEmpty ? nil : [currencyCode: Currency(name: currencyName, symbol: currencySymbol)],
            capital: capitalCity.isEmpty ? nil : [capitalCity],
            subregion: subregion.isEmpty ? nil : subregion,
            languages: languages.isEmpty ? nil : languages,
            population: population,
            timezones: timezones.isEmpty ? nil : timezones
        )
    }
}
