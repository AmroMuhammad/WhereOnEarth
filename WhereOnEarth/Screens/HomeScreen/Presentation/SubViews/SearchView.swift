//
//  SearchView.swift
//  WhereOnEarth
//
//  Created by Amr Muhammad on 09/04/2026.
//

import SwiftUI

struct SearchView: View {
    var onSearchTapped: () -> Void = {}

    var body: some View {
        HStack{
            Text(Constants.Localization.appName)
                .font(.title2)
                .foregroundStyle(.main)
            
            Spacer()
            
            Button(action: onSearchTapped) {
                AppResources.Assets.magnifyingGlass
                    .padding(.horizontal)
                    .foregroundStyle(.white)
                    .frame(width: 25, height: 25)
                    .padding(12)
                    .backgroundStyle(
                        cornerRadius: 12,
                        borderColor: .border,
                        borderWidth: 1,
                        backgroundColor: .main
                    )
            }
        }
    }
}

#Preview {
    SearchView()
}
