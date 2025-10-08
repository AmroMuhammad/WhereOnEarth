//
//  String+Extension.swift
//  WhereOnEarth
//
//  Created by Amr Muhammad on 08/10/2025.
//

import SwiftUI

extension String {
    var image: Image {
        return Image(self)
    }

    var systemImage: Image {
        return Image(systemName: self)
    }
}
