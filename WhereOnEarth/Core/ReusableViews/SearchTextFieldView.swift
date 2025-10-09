//
//  SearchTextFieldView.swift
//  WhereOnEarth
//
//  Created by Amr Muhammad on 09/10/2025.
//

import SwiftUI

struct SearchTextFieldView: View {
    @Binding var text: String
    var placeholder: String = Constants.Localization.searchCountries
    var searchicon: Image = AppResources.Assets.magnifyingGlass
    var cancelIcon: Image = AppResources.Assets.cancelSearchIcon
    
    var body: some View {
        HStack(spacing: 8) {
            ZStack(alignment: .leading) {
                TextField(placeholder, text: $text)
                    .padding(.horizontal, 36)
                    .frame(height: 40)
                    .backgroundStyle()
                    .overlay(
                        HStack {
                            searchicon
                                .padding(.leading, 8)
                            Spacer()
                        }
                    )
            }
            
            if !text.isEmpty {
                Button(action: {
                    text = ""
                }) {
                    cancelIcon
                        .resizable()
                        .scaledToFit()
                        .frame(width: 20, height: 20)
                        .foregroundColor(.main)
                }
                .padding(.trailing, 4)
            }
        }
    }
}

#Preview {
    SearchTextFieldView(text: .constant("Egypt"))
}
