//
//  RootView.swift
//  Health
//
//  Created by Corentin Robert on 23/04/2026.
//

import SwiftUI

struct RootView: View {
    @AppStorage("hasOnboarded") var hasOnboarded = false
    @AppStorage("isLoggedIn") var isLoggedIn = false
    
    var body: some View {
        if !hasOnboarded {
            OnboardingView()
        } else if !isLoggedIn {
            LoginView()
        } else {
            MainTabView()
        }
    }
}

#Preview {
    RootView()
}
