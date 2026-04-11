//
//  CountriesEndpoint.swift
//  WhereOnEarth
//
//  Created by Amr Muhammad on 10/04/2026.
//

import Foundation

enum CountriesEndpoint {
    case getAll
}

extension CountriesEndpoint: APIEndpoint {
    var path: String {
        switch self {
            case .getAll:
                return URLs.allPath.rawValue
        }
    }
    
    var method: HTTPMethod { .get }
    
    var apiType: APIType? {
        switch self {
            case .getAll:
                return .urlQuery(["fields" : "name,capital,flags,currencies,languages,cca2,subregion,population,timezones"])
        }
    }
}
