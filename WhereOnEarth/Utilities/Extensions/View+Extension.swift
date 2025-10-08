//
//  View+Extension.swift
//  WhereOnEarth
//
//  Created by Amr Muhammad on 09/10/2025.
//

import SwiftUI

extension View {
    func backgroundStyle(
        cornerRadius: CGFloat = 8,
        borderColor: Color = .gray,
        borderWidth: CGFloat = 1,
        backgroundColor: Color = .white
    ) -> some View {
        self.modifier(
            BackgroundViewModifier(
                cornerRadius: cornerRadius,
                borderColor: borderColor,
                borderWidth: borderWidth,
                backgroundColor: backgroundColor
            )
        )
    }
}
