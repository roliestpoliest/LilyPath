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
                                    withAnimation {
                                        selectedPlant = plant
                                        showPopUp = true
                                        print("\(plant.species) card tapped")
                                        print("user level: \(userModel.level) plant level: \(plant.requiredLevelToBuy)")
                                    }
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
                
                if plant.requiredLevelToBuy > userModel.level {
                    PopUp.locked(plantModel: plant, showPopUp: $showPopUp)
                        .frame(height: 250)
                        .transition(.scale)
                } else {
                    PopUp.purchase(plantModel: plant, showPopUp: $showPopUp)
                        .frame(height: 250)
                        .transition(.scale)
                }
            }
        }
        .animation(.easeInOut, value: showPopUp)
    }
    
    private func dismissPopup() {
        withAnimation {
            showPopUp = false
            selectedPlant = nil
        }
    }
}

#Preview {
    PlantShopView(plants: BasePlantModel.allPlants)
        .padding(.horizontal, 30)
}
