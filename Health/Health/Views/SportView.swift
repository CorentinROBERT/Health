//
//  SportView.swift
//  Health
//
//  Created by Corentin Robert on 23/04/2026.
//

import SwiftUI
import SwiftData

struct SportView: View {
    @Environment(\.modelContext) var context
    @Query(sort: \SportActivity.date, order: .reverse) var activities: [SportActivity]
    
    @State private var showAdd = false
    
    var body: some View {
        NavigationStack {
            List {
                ForEach(activities) { activity in
                    VStack(alignment: .leading) {
                        Text(activity.type.rawValue)
                            .bold()
                        Text("\(activity.duration / 60, specifier: "%.0f") min")
                            .font(.caption)
                    }
                }
                .onDelete { indexSet in
                    indexSet.forEach { context.delete(activities[$0]) }
                }
            }
            .navigationTitle("Sport")
            .toolbar {
                Button {
                    showAdd = true
                } label: {
                    Image(systemName: "plus")
                }
            }
            .sheet(isPresented: $showAdd) {
                AddSportView()
            }
        }
    }
}

#Preview {
    SportView()
}
