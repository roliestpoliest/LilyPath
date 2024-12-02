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
        // Seed the CurrencyModel during app initialization
        seedCurrencyModel()
    }
    
    var body: some Scene {
        WindowGroup {
            SplashScreenView()
                .environmentObject(healthManager)
                .modelContainer(for: CurrencyModel.self)
        }
    }
    
    /// Function to seed a single CurrencyModel instance
    private func seedCurrencyModel() {
        do {
            // Initialize the ModelContainer
            let modelContainer = try ModelContainer(for: CurrencyModel.self)
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
}
