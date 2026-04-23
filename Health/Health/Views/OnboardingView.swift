//
//  OnBoardingView.swift
//  Health
//
//  Created by Corentin Robert on 23/04/2026.
//

import SwiftUI

struct OnboardingView: View {
    
    @AppStorage("hasOnboarded") var hasOnboarded = false
    @State private var step = 0
    
    var body: some View {
        VStack {
            
            Spacer()
            
            // MARK: - Pages
            TabView(selection: $step) {
                
                onboardingStep(
                    title: "Ton objectif",
                    subtitle: "Reste en forme, perds du poids ou améliore ta santé",
                    systemImage: "target"
                )
                .tag(0)
                
                onboardingStep(
                    title: "Ton activité",
                    subtitle: "On s’adapte à ton niveau et ton rythme",
                    systemImage: "figure.run"
                )
                .tag(1)
                
                onboardingStep(
                    title: "Ta nutrition",
                    subtitle: "Suivi simple de tes calories et macros",
                    systemImage: "leaf"
                )
                .tag(2)
            }
            .tabViewStyle(.page)
            
            // MARK: - Indicator
            HStack(spacing: 8) {
                ForEach(0..<3, id: \.self) { index in
                    Circle()
                        .fill(step == index ? Color.black : Color.gray.opacity(0.3))
                        .frame(width: 8, height: 8)
                }
            }
            .padding(.bottom, 20)
            
            // MARK: - Button
            Button {
                if step < 2 {
                    step += 1
                } else {
                    hasOnboarded = true
                }
            } label: {
                Text(step == 2 ? "Commencer" : "Suivant")
                    .frame(maxWidth: .infinity)
                    .padding()
                    .background(Color.black)
                    .foregroundColor(.white)
                    .cornerRadius(14)
            }
            .padding(.horizontal)
            .padding(.bottom, 20)
        }
    }
    
    // MARK: - Reusable Step UI
    private func onboardingStep(title: String, subtitle: String, systemImage: String) -> some View {
        VStack(spacing: 24) {
            
            Spacer()
            
            Image(systemName: systemImage)
                .font(.system(size: 60))
                .foregroundStyle(.black.opacity(0.8))
            
            Text(title)
                .font(.largeTitle)
                .bold()
            
            Text(subtitle)
                .font(.body)
                .foregroundStyle(.secondary)
                .multilineTextAlignment(.center)
                .padding(.horizontal, 30)
            
            Spacer()
        }
    }
}

#Preview {
    OnboardingView()
}
