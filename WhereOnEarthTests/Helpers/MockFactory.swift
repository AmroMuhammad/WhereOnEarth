//
//  MockFactory.swift
//  WhereOnEarthTests
//
//  Created by Amr Muhammad on 10/04/2026.
//

import Foundation
@testable import WhereOnEarth

enum CountryFactory {

    static func make(
        name: String = "Test",
        cca2: String = "TS",
        capital: String? = "TestCity",
        currencyKey: String? = "TST",
        currencyName: String? = "TestDollar",
        currencySymbol: String? = "$",
        flagPNG: String? = nil,
        languages: [String: String]? = nil,
        population: Int? = nil
    ) -> Country {
        var json: [String: Any] = [
            "name": [
                "common": name,
                "official": name
            ],
            "cca2": cca2
        ]

        if let capital {
            json["capital"] = [capital]
        }

        if let currencyKey, let currencyName {
            var currency: [String: Any] = ["name": currencyName]
            if let currencySymbol { currency["symbol"] = currencySymbol }
            json["currencies"] = [currencyKey: currency]
        }

        if let flagPNG {
            json["flags"] = ["png": flagPNG]
        }

        if let languages {
            json["languages"] = languages
        }

        if let population {
            json["population"] = population
        }

        let data = try! JSONSerialization.data(withJSONObject: json)
        return try! JSONDecoder().decode(Country.self, from: data)
    }

    static func egypt() -> Country {
        make(name: "Egypt", cca2: "EG", capital: "Cairo",
             currencyKey: "EGP", currencyName: "Egyptian pound", currencySymbol: "£",
             languages: ["ara": "Arabic"])
    }

    static func germany() -> Country {
        make(name: "Germany", cca2: "DE", capital: "Berlin",
             currencyKey: "EUR", currencyName: "Euro", currencySymbol: "€",
             languages: ["deu": "German"])
    }

    static func france() -> Country {
        make(name: "France", cca2: "FR", capital: "Paris",
             currencyKey: "EUR", currencyName: "Euro", currencySymbol: "€",
             languages: ["fra": "French"])
    }

    static func japan() -> Country {
        make(name: "Japan", cca2: "JP", capital: "Tokyo",
             currencyKey: "JPY", currencyName: "Japanese yen", currencySymbol: "¥",
             languages: ["jpn": "Japanese"])
    }

    static func brazil() -> Country {
        make(name: "Brazil", cca2: "BR", capital: "Brasília",
             currencyKey: "BRL", currencyName: "Brazilian real", currencySymbol: "R$",
             languages: ["por": "Portuguese"])
    }

    static func sampleList() -> [Country] {
        [egypt(), germany(), france(), japan(), brazil()]
    }
}
