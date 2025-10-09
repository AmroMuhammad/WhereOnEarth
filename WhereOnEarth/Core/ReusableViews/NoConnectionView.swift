//
//  NoConnectionView.swift
//  WhereOnEarth
//
//  Created by Amr Muhammad on 09/10/2025.
//

import SwiftUI

struct NoConnectionView: View {
    
    var body: some View {
        VStack {
            Spacer()
            
            HStack {
                AppResources.Assets.noConnection
                    .resizable()
                    .padding(.horizontal)
            }
            .frame(width: 250 , height: 250)
            .backgroundStyle(
                cornerRadius: 20,
                borderColor: .black,
                borderWidth: 1,
                backgroundColor: .white
            )
            
            Text(Constants.Localization.checkConnection)
                .font(.title2)
                .foregroundStyle(.red)
                .multilineTextAlignment(.center)
                .padding(.top, 20)
            
            Spacer()
        }
        .padding(.horizontal, 30)
    }
}

#Preview {
    NoConnectionView()
}
