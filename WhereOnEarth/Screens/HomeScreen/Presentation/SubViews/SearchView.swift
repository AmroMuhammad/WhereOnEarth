//
//  SearchView.swift
//  WhereOnEarth
//
//  Created by Amr Muhammad on 08/10/2025.
//

import SwiftUI

struct SearchView: View {
    var body: some View {
        HStack{
            Text(AppConstants.Localization.appName)
                .font(.title)
                .foregroundStyle(.main)
            
            Spacer()
            
            AppResources.Assets.magnifyingGlass
                .resizable()
                .padding(.horizontal)
                .foregroundStyle(.white)
                .frame(width: 60 , height: 30)
                .padding(12)
                .background(
                    RoundedRectangle(cornerRadius: 12)
                        .fill(.main)
                )
                .overlay(
                    RoundedRectangle(cornerRadius: 12)
                        .stroke(.border, lineWidth: 1)
                )
        }
    }
}

#Preview {
    SearchView()
}
