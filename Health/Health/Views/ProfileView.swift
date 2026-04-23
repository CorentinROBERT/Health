//
//  ProfileView.swift
//  Health
//
//  Created by Corentin Robert on 23/04/2026.
//

import SwiftUI
import SwiftData

struct ProfileView: View {
    @Query var users: [User]
    @State private var showEdit = false
    
    var user: User? {
        users.first
    }
    
    var body: some View {
        NavigationStack {
            VStack(spacing: 20) {
                
                if let profile = user?.profile {
                    
                    if let photoURL = profile.photoURL {
                        Text("Photo: \(photoURL)")
                    }
                    
                    Text("\(profile.firstName) \(profile.lastName)")
                        .font(.title)
                    
                    Text(profile.email)
                        .foregroundStyle(.secondary)
                }
                
                Button("Modifier profil") {
                    showEdit = true
                }
            }
            .navigationTitle("Profil")
        }
    }
}

#Preview {
    ProfileView()
}
