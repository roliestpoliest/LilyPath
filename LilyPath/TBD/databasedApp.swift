//
//  databasedApp.swift
//  databased
//
//  Created by Carolyn Heron on 12/1/24.
//

import SwiftData
import SwiftUI

@main
struct databasedApp: App {
    init() {
        do {
            // Initialize the ModelContainer
            let modelContainer = try ModelContainer(
                for: TaskModel.self, TaskType.self, CurrencyModel.self // Include all models
            )
            
            let context = modelContainer.mainContext
            
            // Seed all models
            seedAllModels(context: context)
            
        } catch {
            fatalError("Failed to initialize ModelContainer: \(error)")
        }
    }
    
    var body: some Scene {
        WindowGroup {
            ContentView()
                .modelContainer(for: [TaskModel.self, TaskType.self, CurrencyModel.self]) // Include all models
        }
    }
    
    /// Function to seed all models in the database
    private func seedAllModels(context: ModelContext) {
        // Seed TaskType models via TaskManager
        TaskManager.shared.seedTaskTypes(context: context)
        
        // Seed CurrencyModel
        seedCurrencyModel(context: context)
        
        // Add other models here if needed
    }
    
    /// Function to seed a single CurrencyModel instance
    private func seedCurrencyModel(context: ModelContext) {
        let fetchDescriptor = FetchDescriptor<CurrencyModel>()
        if let existingCurrency = try? context.fetch(fetchDescriptor), existingCurrency.isEmpty {
            let currency = CurrencyModel(waterPoints: 0, gems: 0)
            context.insert(currency)
            try? context.save()
            print("CurrencyModel seeded successfully.")
        } else {
            print("CurrencyModel already exists.")
        }
    }
}
