//
//  CustomDialog.swift
//  WhereOnEarth
//
//  Created by Amr Muhammad on 10/10/2025.
//

import SwiftUI

struct CustomDialog: View {
    let icon: Image?
    let title: String
    let message: String
    let primaryButtonTitle: String
    let primaryAction: () -> Void
    let secondaryButtonTitle: String?
    let secondaryAction: (() -> Void)?
    
    var body: some View {
        VStack(spacing: 20) {
            if let icon {
                icon
                    .resizable()
                    .scaledToFit()
                    .frame(width: 50, height: 50)
            }
            
            Text(title)
                .font(.title2)
                .fontWeight(.semibold)
                .multilineTextAlignment(.center)
            
            Text(message)
                .font(.body)
                .foregroundColor(.gray)
                .multilineTextAlignment(.center)
            
            HStack(spacing: 16) {
                if let secondaryButtonTitle {
                    Button(secondaryButtonTitle) {
                        secondaryAction?()
                    }
                    .frame(maxWidth: .infinity)
                    .padding()
                    .background(.gray.opacity(0.15))
                    .cornerRadius(10)
                    .foregroundStyle(.red)
                }
                
                Button(primaryButtonTitle) {
                    primaryAction()
                }
                .frame(maxWidth: .infinity)
                .padding()
                .background(.main)
                .foregroundColor(.white)
                .cornerRadius(10)
            }
        }
        .padding()
        .frame(maxWidth: 320)
        .background(.white)
        .cornerRadius(16)
        .shadow(radius: 10)
    }
}
