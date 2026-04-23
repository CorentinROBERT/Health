//
//  ProfileView.swift
//  Health
//
//  Created by Corentin Robert on 23/04/2026.
//

import SwiftUI
import SwiftData

import SwiftUI
import SwiftData

struct ProfileView: View {
    
    @Query private var users: [User]
    private let viewModel = ProfileViewModel()
    
    var body: some View {
        VStack(alignment: .leading, spacing: 16) {
            
            if let user = users.first {
                
                Text(user.profile?.firstName ?? "")
                    .font(.title)
                    .bold()
                
                Text("Age: \(viewModel.age(user)) ans")
                
                Text("Devices: \(viewModel.connectedDevicesCount(user))")
                
                Button("Demander suppression compte") {
                    viewModel.requestAccountDeletion(user: user)
                }
                .foregroundColor(.red)
            }
        }
        .padding()
    }
}

#Preview {
    ProfileView()
}
