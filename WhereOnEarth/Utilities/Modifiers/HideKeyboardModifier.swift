//
//  HideKeyboardModifier.swift
//  WhereOnEarth
//
//  Created by Amr Muhammad on 10/04/2026.
//

import SwiftUI

struct HideKeyboardModifier: ViewModifier {
    func body(content: Content) -> some View {
        content
            .onTapGesture {
                UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
            }
    }
}
