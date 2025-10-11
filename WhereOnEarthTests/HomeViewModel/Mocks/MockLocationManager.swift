//
//  MockLocationManager.swift
//  WhereOnEarthTests
//
//  Created by Amr Muhammad on 11/10/2025.
//

import XCTest
import Combine
@testable import WhereOnEarth

class MockLocationManager: LocationManager {
    var mockUserCountry: String = ""
    override var userCountry: String {
        get { mockUserCountry }
        set { mockUserCountry = newValue }
    }
}
