//
//  CountriesEndpoint.swift
//  WhereOnEarth
//
//  Created by Amr Muhammad on 09/10/2025.
//

import Foundation

enum CountriesEndpoint {
    case getAll
}

extension CountriesEndpoint: APIEndpoint {
    var baseURL: URL {
        return  URL(string: URLs.baseURL.rawValue) ?? URL(fileURLWithPath: "")
    }
    
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
                return .urlQuery(["fields" : "name,capital,flags,currencies,languages"])
        }
    }
}
