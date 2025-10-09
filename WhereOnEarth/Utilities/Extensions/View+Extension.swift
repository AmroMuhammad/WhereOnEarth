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

//MARK: - OneTimeCalling
extension View {
    func oneTimeCalling(_ action: @escaping () -> Void) -> some View {
        self.modifier(OneTimeCallingModifier(action: action))
    }
}

//MARK: - OneTimeCalling
struct OneTimeCallingModifier: ViewModifier {
    @State private var hasBeenCalled = false
    let action: () -> Void
    
    func body(content: Content) -> some View {
        content
            .onAppear {
                if !hasBeenCalled {
                    hasBeenCalled = true
                    action()
                }
            }
    }
}
