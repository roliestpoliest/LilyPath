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
//        clearData()
        
        // Seed the models during app initialization
        seedInitialData()
    }
    
    var body: some Scene {
        WindowGroup {
            SplashScreenView()
                .environmentObject(healthManager)
                .modelContainer(AppModelContainer.shared.container)
        }
    }
    
    /// Function to seed the initial data for all models
    private func seedInitialData() {
        do {
            // Initialize the ModelContainer
            let modelContainer = AppModelContainer.shared.container
            let context = modelContainer.mainContext
            
            // Seed CurrencyModel
            let currencyFetchDescriptor = FetchDescriptor<CurrencyModel>()
            if let existingCurrencies = try? context.fetch(currencyFetchDescriptor), existingCurrencies.isEmpty {
                let currency = CurrencyModel(waterPoints: 1000, gems: 5) // Default values
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
            let modelContainer = AppModelContainer.shared.container
            let context = modelContainer.mainContext

            func clearAll<T: PersistentModel>(_ type: T.Type) throws {
                let fetchDescriptor = FetchDescriptor<T>()
                let items = try context.fetch(fetchDescriptor)
                for item in items {
                    context.delete(item)
                }
            }

            // Clear data for all models
            try clearAll(CurrencyModel.self)
            try clearAll(TaskModel.self)
            try clearAll(UserPlantModel.self)
            try clearAll(BasePlantModel.self)
            
            // Remove UserDefaults for daily task generation
            UserDefaults.standard.removeObject(forKey: "lastGeneratedDate")

            // Save changes
            try context.save()
            print("All data cleared successfully.")
        } catch {
            fatalError("Failed to clear data: \(error)")
        }
    }
}
