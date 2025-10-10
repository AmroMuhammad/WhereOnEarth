//
//  HeaderTitleView.swift
//  WhereOnEarth
//
//  Created by Amr Muhammad on 08/10/2025.
//

import SwiftUI

struct HeaderTitleView: View {
    let title: String
    var isLargeTitle: Bool = false
    var titleColor: Color = .main
    
    var body: some View {
        HStack {
            Text(title)
                .font(isLargeTitle ? .title2 : .headline)
                .foregroundStyle(.main)
            Spacer()
        }
        .padding(4)
    }
}

#Preview {
    HeaderTitleView(title: Constants.Localization.defaultCountry)
}
