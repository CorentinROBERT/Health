//
//  LoginView.swift
//  Health
//
//  Created by Corentin Robert on 23/04/2026.
//

import SwiftUI

struct LoginView: View {
    
    @AppStorage("isLoggedIn") var isLoggedIn = false
    @State private var email = ""
    
    var body: some View {
        VStack(spacing: 30) {
            
            Spacer()
            
            // MARK: - Header
            VStack(spacing: 8) {
                Text("Health")
                    .font(.largeTitle)
                    .bold()
                
                Text("Suivez votre sport, nutrition et santé")
                    .font(.subheadline)
                    .foregroundStyle(.secondary)
                    .multilineTextAlignment(.center)
            }
            
            // MARK: - Form
            VStack(spacing: 16) {
                
                TextField("Adresse email", text: $email)
                    .textInputAutocapitalization(.never)
                    .keyboardType(.emailAddress)
                    .padding()
                    .background(Color.gray.opacity(0.1))
                    .cornerRadius(12)
                
                Button {
                    isLoggedIn = true
                } label: {
                    Text("Continuer")
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(email.isEmpty ? Color.gray.opacity(0.3) : Color.black)
                        .foregroundColor(.white)
                        .cornerRadius(12)
                }
                .disabled(email.isEmpty)
            }
            
            Spacer()
            
            // MARK: - Footer
            Text("MVP local • SwiftData")
                .font(.caption)
                .foregroundStyle(.secondary)
        }
        .padding()
    }
}

#Preview {
    LoginView()
}
