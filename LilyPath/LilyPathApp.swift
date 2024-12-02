//
//  LilyPathApp.swift
//  LilyPath
//
//  Created by Carolyn Heron on 9/29/24.
//

import SwiftUI
import SwiftData

@main
struct LilyPathApp: App {
    @StateObject var healthManager = HealthManager()
    
    init() {
//        clearData() // Clear existing data for testing
        // Seed the CurrencyModel during app initialization
        seedCurrencyModel()
    }
    
    var body: some Scene {
        WindowGroup {
            SplashScreenView()
                .environmentObject(healthManager)
                .modelContainer(for: [CurrencyModel.self, TaskModel.self])
        }
    }
    
    /// Function to seed a single CurrencyModel instance
    private func seedCurrencyModel() {
        do {
            // Initialize the ModelContainer
            let modelContainer = try ModelContainer(for: CurrencyModel.self, TaskModel.self)
            let context = modelContainer.mainContext
            
            // Fetch existing CurrencyModel instances
            let fetchDescriptor = FetchDescriptor<CurrencyModel>()
            if let existingCurrency = try? context.fetch(fetchDescriptor), existingCurrency.isEmpty {
                // If no CurrencyModel exists, create a new one
                let currency = CurrencyModel(waterPoints: 0, gems: 0)
                context.insert(currency)
                try context.save()
                print("CurrencyModel seeded successfully.")
            } else {
                print("CurrencyModel already exists.")
            }
        } catch {
            fatalError("Failed to seed CurrencyModel: \(error)")
        }
    }
    
    /// Function to clear all CurrencyModel and TaskModel instances
    private func clearData() {
        do {
            // Initialize the ModelContainer for both models
            let modelContainer = try ModelContainer(for: CurrencyModel.self, TaskModel.self)
            let context = modelContainer.mainContext

            // Fetch and delete all CurrencyModel instances
            let currencyFetchDescriptor = FetchDescriptor<CurrencyModel>()
            let currencies = try context.fetch(currencyFetchDescriptor)
            for currency in currencies {
                context.delete(currency)
            }

            // Fetch and delete all TaskModel instances
            let taskFetchDescriptor = FetchDescriptor<TaskModel>()
            let tasks = try context.fetch(taskFetchDescriptor)
            for task in tasks {
                context.delete(task)
            }

            // Save changes to persist the deletion
            try context.save()
            print("All CurrencyModel and TaskModel instances have been cleared.")
        } catch {
            fatalError("Failed to clear data: \(error)")
        }
    }
}
