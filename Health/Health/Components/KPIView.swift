//
//  KPIView.swift
//  Health
//
//  Created by Corentin Robert on 23/04/2026.
//

import SwiftUI

struct KPIView: View {
    var title: String
    var value: String
    
    var body: some View {
        VStack {
            Text(title)
                .font(.caption)
            Text(value)
                .font(.title2)
                .bold()
        }
        .frame(maxWidth: .infinity)
        .padding()
        .background(.gray.opacity(0.1))
        .cornerRadius(12)
    }
}

#Preview {
    KPIView(title: "Heart rate", value: "70")
}
