//
//  PlantShopView.swift
//  LilyPath
//
//  Created by Carolyn Heron on 10/2/24.
//

import SwiftUI
import SwiftData

struct PlantShopView: View {
    // Query for BasePlantModel sorted by id in ascending order
    @Query(sort: [SortDescriptor(\BasePlantModel.id, order: .forward)])
    private var plants: [BasePlantModel]
    
    let columns = [
        GridItem(.flexible(), spacing: 40),
        GridItem(.flexible(), spacing: 40),
    ]
    
    @State var selectedPlant: BasePlantModel? = nil
    @State var showPopUp: Bool = false
    @ObservedObject var userModel = UserModel.shared
    @Environment(\.modelContext) private var modelContext
    
    var body: some View {
        ZStack {
            VStack {
                UserCurrencyBar()
                
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
                .shadow(radius: ShadowConstants.radius, y: ShadowConstants.yOffset)
            }
            .background(Color.mainBackground)
            
            if let plant = selectedPlant, showPopUp {
                Color.mainBackground.opacity(0.4)
                    .ignoresSafeArea()
                    .onTapGesture {
                        dismissPopup()
                    }
                
                getPopup(for: plant)
                    .frame(height: 250)
                    .transition(.scale)
            }
        }
        .animation(.easeInOut, value: showPopUp)
    }
    
    // MARK: - Helper Functions
    private func handlePlantSelection(_ plant: BasePlantModel) {
        withAnimation {
            selectedPlant = plant
            showPopUp = true
            print("\(plant.species) card tapped")
            print("User level: \(userModel.level), Plant level: \(plant.requiredLevelToBuy)")
        }
    }
    
    private func getPopup(for plant: BasePlantModel) -> some View {
//        if plant.requiredLevelToBuy > userModel.level {
//            return PopUp.locked(plantModel: plant, showPopUp: $showPopUp)
//                .eraseToAnyView()
//        } else
        if userModel.gems >= plant.price {
            return PopUp.purchase(plantModel: plant, showPopUp: $showPopUp) {
                handlePlantPurchase(plant)
            }.eraseToAnyView()
        } else {
            return EmptyView().eraseToAnyView()
        }
    }
    
    private func handlePlantPurchase(_ plant: BasePlantModel) {
        guard userModel.gems >= plant.price else {
            print("Not enough gems to purchase \(plant.species).")
            return
        }
        
        userModel.updateGems(by: -plant.price)

        // Mark current plant as no longer current
        if let currentPlant = fetchCurrentPlant() {
            currentPlant.isCurrent = false
        }

        // Create and save new plant
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
    
    private func fetchCurrentPlant() -> UserPlantModel? {
        let fetchDescriptor = FetchDescriptor<UserPlantModel>(
            predicate: #Predicate { $0.isCurrent == true }
        )
        return try? modelContext.fetch(fetchDescriptor).first
    }
    
    private func dismissPopup() {
        withAnimation {
            showPopUp = false
            selectedPlant = nil
        }
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
        .environmentObject(UserModel.shared)
}
