//
//  PlantShopView.swift
//  LilyPath
//
//  Created by Carolyn Heron on 10/2/24.
//

import SwiftUI

struct PlantShopView: View {
    let plants: [BasePlantModel]
    let columns = [
        GridItem(.flexible(), spacing: 40),
        GridItem(.flexible(), spacing: 40),
    ]
    
    @State var selectedPlant: BasePlantModel? = nil
    @State var showPopUp: Bool = false
    @ObservedObject var userModel = UserModel.shared
    @EnvironmentObject var userPlantManager: UserPlantManager

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
            print("user level: \(userModel.level) plant level: \(plant.requiredLevelToBuy)")
        }
    }

    private func getPopup(for plant: BasePlantModel) -> some View {
        if plant.requiredLevelToBuy > userModel.level {
            return PopUp.locked(plantModel: plant, showPopUp: $showPopUp)
                .eraseToAnyView()
        } else if userModel.gems >= plant.price {
            return PopUp.purchase(plantModel: plant, showPopUp: $showPopUp) {
                userModel.updateGems(by: -plant.price)
                
                if let currentPlant = userPlantManager.currentPlant {
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
                
                userPlantManager.userPlants.append(newPlant)
                userPlantManager.currentPlant = newPlant

                print("Added and set new plant: \(newPlant.basePlant.species)")
            }.eraseToAnyView()
        } else {
            return EmptyView().eraseToAnyView()
        }
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
    PlantShopView(plants: BasePlantModel.allPlants)
        .padding(.horizontal, 30)
        .environmentObject(UserModel.shared)
}
