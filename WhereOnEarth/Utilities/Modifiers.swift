//
//  Modifiers.swift
//  WhereOnEarth
//
//  Created by Amr Muhammad on 10/04/2026.
//

import SwiftUI

struct BackgroundViewModifier: ViewModifier {
    let cornerRadius: CGFloat
    let borderColor: Color
    let borderWidth: CGFloat
    let backgroundColor: Color
    
    func body(content: Content) -> some View {
        content
            .padding(borderWidth)
            .background(
                RoundedRectangle(cornerRadius: cornerRadius)
                    .fill(backgroundColor)
            )
            .overlay(
                RoundedRectangle(cornerRadius: cornerRadius)
                    .stroke(borderColor, lineWidth: borderWidth)
            )
    }
}
