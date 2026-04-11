//
//  HeaderTitleView.swift
//  WhereOnEarth
//
//  Created by Amr Muhammad on 09/04/2026.
//

import SwiftUI

struct HeaderTitleView: View {
    let title: String
    var titleColor: Color = .main
    
    var body: some View {
        HStack {
            Text(title)
                .font(.headline)
                .foregroundStyle(.main)
            Spacer()
        }
        .padding(4)
    }
}

#Preview {
    HeaderTitleView(title: Constants.Localization.defaultCountry)
}
