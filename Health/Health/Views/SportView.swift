//
//  SportView.swift
//  Health
//
//  Created by Corentin Robert on 23/04/2026.
//

import SwiftUI
import SwiftData
import Foundation

struct SportView: View {
    
    @Query private var activities: [SportActivity]
    @Environment(\.modelContext) private var context
    
    @StateObject private var viewModel = SportViewModel()
    
    var body: some View {
        NavigationStack {
            List {
                ForEach(viewModel.sorted(activities)) { activity in
                    VStack(alignment: .leading) {
                        Text(activity.type.rawValue.capitalized)
                            .bold()
                        
                        Text("\(activity.duration / 60, specifier: "%.0f") min")
                            .font(.caption)
                    }
                }
                .onDelete { indexSet in
                    indexSet.forEach {
                        viewModel.delete(activities[$0], context: context)
                    }
                }
            }
            .navigationTitle("Sport")
        }
    }
}

#Preview {
    SportView()
}
