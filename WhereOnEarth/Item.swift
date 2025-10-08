//
//  Item.swift
//  WhereOnEarth
//
//  Created by Amr Muhammad on 08/10/2025.
//

import Foundation
import SwiftData

@Model
final class Item {
    var timestamp: Date
    
    init(timestamp: Date) {
        self.timestamp = timestamp
    }
}
