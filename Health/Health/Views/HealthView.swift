//
//  HealthView.swift
//  Health
//
//  Created by Corentin Robert on 23/04/2026.
//

import SwiftUI
import SwiftData

struct HealthView: View {
    @Environment(\.modelContext) var context
    @Query(sort: \HealthRecord.date, order: .reverse) var records: [HealthRecord]
    
    var body: some View {
        NavigationStack {
            List {
                ForEach(records) { record in
                    VStack(alignment: .leading) {
                        Text(record.title)
                            .bold()
                        Text(record.type.rawValue)
                            .font(.caption)
                        Text(record.date, style: .date)
                            .font(.caption2)
                    }
                }
                .onDelete { indexSet in
                    indexSet.forEach { context.delete(records[$0]) }
                }
            }
            .navigationTitle("Santé")
        }
    }
}

#Preview {
    HealthView()
}
