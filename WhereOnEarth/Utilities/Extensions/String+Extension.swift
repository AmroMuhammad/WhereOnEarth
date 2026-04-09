//
//  String+Extension.swift
//  WhereOnEarth
//
//  Created by Amr Muhammad on 09/04/2026.
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
