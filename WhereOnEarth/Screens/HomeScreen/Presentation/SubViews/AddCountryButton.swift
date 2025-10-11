//
//  AddCountryButton.swift
//  WhereOnEarth
//
//  Created by Amr Muhammad on 09/10/2025.
//

import SwiftUI

struct AddCountryButton: View {
    @Binding var openCountryPicker: Bool

    var body: some View {
        Button {
            openCountryPicker.toggle()
        } label: {
            HStack {
                Text(Constants.Localization.addCountryButtonTitle)
                    .font(.title2)
                    .foregroundStyle(.white)
            }
            .frame(maxWidth: .infinity, maxHeight: 50)
            .background(RoundedRectangle(cornerRadius: 8)
                .fill(.main))
        }
    }
}

#Preview {
    AddCountryButton(openCountryPicker: .constant(true))
}
