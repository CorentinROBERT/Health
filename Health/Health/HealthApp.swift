//
//  HealthApp.swift
//  Health
//
//  Created by Corentin Robert on 23/04/2026.
//

import SwiftUI
import SwiftData

@main
struct HealthApp: App {
    
    var sharedModelContainer: ModelContainer = {
        let schema = Schema([
            User.self,
            Profile.self,
            HealthRecord.self,
            Attachment.self,
            SportActivity.self,
            NutritionLog.self,
            HealthMetric.self,
            Goal.self,
            ConnectedDevice.self,
            WeightEntry.self
        ])
        
        let config = ModelConfiguration(schema: schema, isStoredInMemoryOnly: false)
        
        do {
            let container = try ModelContainer(for: schema, configurations: [config])
            
            // 👉 SEED ICI
            let context = container.mainContext
            DataSeeder.seedIfNeeded(context: context)
            
            return container
        } catch {
            fatalError("Could not create ModelContainer: \(error)")
        }
    }()

    var body: some Scene {
        WindowGroup {
            ContentView()
        }
        .modelContainer(sharedModelContainer)
    }
}
