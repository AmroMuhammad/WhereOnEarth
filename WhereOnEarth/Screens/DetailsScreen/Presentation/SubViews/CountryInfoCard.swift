//
//  CountryInfoCard.swift
//  WhereOnEarth
//
//  Created by Amr Muhammad on 11/10/2025.
//

import SwiftUI

struct CountryInfoCard: View {
    let icon: String
    let label: String
    let value: String
    let backgroundColor: Color

    var body: some View {
        VStack(spacing: 8) {
            Image(systemName: icon)
                .font(.largeTitle)
                .foregroundColor(.white)
            Text("\(label) \(value)")
                .font(.headline)
                .foregroundColor(.white)
                .multilineTextAlignment(.center)
        }
        .padding()
        .frame(maxWidth: .infinity, minHeight: 120)
        .backgroundStyle(
            cornerRadius: 12,
            borderColor: .border,
            borderWidth: 2,
            backgroundColor: backgroundColor
        )
    }
}

#Preview {
    CountryInfoCard(icon: "globe", label: "Country", value: "Egypt", backgroundColor: .red)
}
