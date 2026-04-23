//
//  SplashView.swift
//  Health
//
//  Created by Corentin Robert on 23/04/2026.
//

import SwiftUI

struct SplashView: View {
    @State private var isActive = false
    
    var body: some View {
        if isActive {
            RootView()
        } else {
            VStack {
                Text("Health")
                    .font(.largeTitle)
                    .bold()
            }
            .onAppear {
                DispatchQueue.main.asyncAfter(deadline: .now() + 1.5) {
                    isActive = true
                }
            }
        }
    }
}

#Preview {
    SplashView()
}
