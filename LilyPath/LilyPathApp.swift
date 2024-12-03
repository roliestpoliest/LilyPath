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
        // Uncomment the line below to clear data for testing
        // clearData()
        
        // Seed the models during app initialization
        seedInitialData()
    }
    
    var body: some Scene {
        WindowGroup {
            SplashScreenView()
                .environmentObject(healthManager)
                .modelContainer(for: [CurrencyModel.self, TaskModel.self, UserPlantModel.self, BasePlantModel.self])
        }
    }
    
    /// Function to seed the initial data for all models
    private func seedInitialData() {
        do {
            // Initialize the ModelContainer
            let modelContainer = try ModelContainer(for: CurrencyModel.self, TaskModel.self, UserPlantModel.self, BasePlantModel.self)
            let context = modelContainer.mainContext
            
            // Seed CurrencyModel
            let currencyFetchDescriptor = FetchDescriptor<CurrencyModel>()
            if let existingCurrencies = try? context.fetch(currencyFetchDescriptor), existingCurrencies.isEmpty {
                let currency = CurrencyModel(waterPoints: 1000, gems: 10) // Default values
                context.insert(currency)
                print("CurrencyModel seeded successfully.")
            } else {
                print("CurrencyModel already exists.")
            }
            
            // Seed BasePlantModel
            let basePlantFetchDescriptor = FetchDescriptor<BasePlantModel>()
            if let existingBasePlants = try? context.fetch(basePlantFetchDescriptor), existingBasePlants.isEmpty {
                for plant in BasePlantModel.allPlants {
                    context.insert(plant)
                }
                print("BasePlantModel seeded successfully.")
            } else {
                print("BasePlantModel already exists.")
            }
            
            // Seed UserPlantModel
            let userPlantFetchDescriptor = FetchDescriptor<UserPlantModel>()
            if let existingUserPlants = try? context.fetch(userPlantFetchDescriptor), existingUserPlants.isEmpty {
                if let firstBasePlant = BasePlantModel.allPlants.first {
                    let userPlant = UserPlantModel(basePlant: firstBasePlant)
                    context.insert(userPlant)
                }
                print("UserPlantModel seeded successfully.")
            } else {
                print("UserPlantModel already exists.")
            }
            
            // Save changes
            try context.save()
        } catch {
            fatalError("Failed to seed initial data: \(error)")
        }
    }
    
    /// Function to clear all data for testing
    private func clearData() {
        do {
            // Initialize the ModelContainer
            let modelContainer = try ModelContainer(for: CurrencyModel.self, TaskModel.self, UserPlantModel.self, BasePlantModel.self)
            let context = modelContainer.mainContext
            
            // Delete all instances of CurrencyModel
            let currencyFetchDescriptor = FetchDescriptor<CurrencyModel>()
            let currencies = try context.fetch(currencyFetchDescriptor)
            for currency in currencies {
                context.delete(currency)
            }
            
            // Delete all instances of TaskModel
            let taskFetchDescriptor = FetchDescriptor<TaskModel>()
            let tasks = try context.fetch(taskFetchDescriptor)
            for task in tasks {
                context.delete(task)
            }
            
            // Delete all instances of UserPlantModel
            let userPlantFetchDescriptor = FetchDescriptor<UserPlantModel>()
            let userPlants = try context.fetch(userPlantFetchDescriptor)
            for userPlant in userPlants {
                context.delete(userPlant)
            }
            
            // Delete all instances of BasePlantModel
            let basePlantFetchDescriptor = FetchDescriptor<BasePlantModel>()
            let basePlants = try context.fetch(basePlantFetchDescriptor)
            for basePlant in basePlants {
                context.delete(basePlant)
            }
            
            // Save changes
            try context.save()
            print("All data cleared successfully.")
        } catch {
            fatalError("Failed to clear data: \(error)")
        }
    }
}
