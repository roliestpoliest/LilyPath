//
//  PlantShopView.swift
//  LilyPath
//
//  Created by Carolyn Heron on 10/2/24.
//

import SwiftData
import SwiftUI

struct PlantShopView: View {
    @Query(sort: [SortDescriptor(\BasePlantModel.id, order: .forward)])
    private var plants: [BasePlantModel]
    
    @Query private var currencyModels: [CurrencyModel]
    
    @Environment(\.modelContext) private var modelContext
    
    @State var selectedPlant: BasePlantModel? = nil
    @State var showPopUp: Bool = false
    @State var showCurrencyPopUp: Bool = false
        
    let columns = [
        GridItem(.flexible(), spacing: 40),
        GridItem(.flexible(), spacing: 40),
    ]
    
    var body: some View {
        ZStack {
            VStack {
                UserCurrencyBar(showPopUp: $showCurrencyPopUp)
                
                ViewTitle(title: "Plant Shop")
                
                ScrollView(showsIndicators: false) {
                    LazyVGrid(columns: columns, spacing: 40) {
                        ForEach(plants) { plant in
                            PlantShopCard(plantModel: plant)
                                .onTapGesture {
                                    handlePlantSelection(plant)
                                }
                        }
                    }
                }
                .shadow(
                    radius: ShadowConstants.radius, y: ShadowConstants.yOffset)
            }
            .background(Color.mainBackground)
            .popUpOverlay(isVisible: $showPopUp) {
                if let currencyModel = getCurrencyModel(), let plant = selectedPlant {
                    let hasEnoughGems = currencyModel.gems >= plant.price
                    
                    PopUp.purchase(
                        plantModel: selectedPlant!,
                        showPopUp: $showPopUp,
                        hasEnoughGems: hasEnoughGems,
                        onPurchase: handlePlantPurchase
                    )
                }
            }
            .popUpOverlay(isVisible: $showCurrencyPopUp) {
                PopUp.addWaterPoints(
                    steps: 100,
                    showPopUp: $showCurrencyPopUp,
                    currencyModels: currencyModels,
                    onConvert: onConvert,
                    onBuy: onBuy
                )
            }
        }
//        .animation(.easeInOut, value: showPopUp)
    }
    
    // MARK: - Helper Functions
    private func handlePlantSelection(_ plant: BasePlantModel) {
        withAnimation {
            selectedPlant = plant
            showPopUp = true
            print("\(plant.species) card tapped")
        }
    }
    
    private func handlePlantPurchase(_ plant: BasePlantModel) {
        guard let currencyModel = getCurrencyModel() else {
            return
        }
        
        guard currencyModel.gems >= plant.price else {
            print("Not enough gems to purchase \(plant.species).")
            return
        }
        
        currencyModel.gems -= plant.price
        
        if let currentPlant = fetchCurrentPlant() {
            currentPlant.isCurrent = false
        }
        
        let newPlant = UserPlantModel(
            basePlant: plant,
            plantDate: Date(),
            currentStage: 1,
            watersCollected: 0,
            lastWateredDate: nil,
            isCurrent: true,
            status: .growing
        )
        modelContext.insert(newPlant)
        
        do {
            try modelContext.save()
            print("Added and set new plant: \(newPlant.basePlant.species)")
        } catch {
            print("Failed to save new plant: \(error)")
        }
    }
    
    private func getCurrencyModel() -> CurrencyModel? {
        guard let currencyModel = currencyModels.first else {
            print("No CurrencyModel found.")
            return nil
        }
        return currencyModel
    }
    
    private func fetchCurrentPlant() -> UserPlantModel? {
        let fetchDescriptor = FetchDescriptor<UserPlantModel>(
            predicate: #Predicate { $0.isCurrent == true }
        )
        return try? modelContext.fetch(fetchDescriptor).first
    }
}

// MARK: - Utility Extension for AnyView
extension View {
    func eraseToAnyView() -> AnyView {
        AnyView(self)
    }
}

#Preview {
    PlantShopView()
        .padding(.horizontal, 30)
}
