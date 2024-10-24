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
                                    }
                                }
                        }
                    }
                }
                .shadow(radius: ShadowConstants.radius, y: ShadowConstants.yOffset)
            }
            .background(Color.mainBackground)
            
            if let plant = selectedPlant, showPopUp {
                Color.black.opacity(0.4)
                    .ignoresSafeArea()
                    .onTapGesture {
                        selectedPlant = nil
                        showPopUp = false
                    }
                
                PopUp.purchase(plantModel: plant, showPopUp: $showPopUp)
                    .frame(height: 250)
                    .transition(.scale)
            }
        }
        .animation(.easeInOut, value: selectedPlant)
    }
}

#Preview {
    PlantShopView(plants: BasePlantModel.allPlants)
        .padding(.horizontal, 30)
}
