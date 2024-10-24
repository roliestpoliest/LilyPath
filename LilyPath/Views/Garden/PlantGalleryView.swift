//
//  PlantGalleryView.swift
//  LilyPath
//
//  Created by Carolyn Heron on 10/6/24.
//

import SwiftUI

struct PlantGalleryView: View {
    @EnvironmentObject var userPlantManager: UserPlantManager
    
    @State private var selectedPlant: UserPlantModel? = nil
    @State private var showPopUp: Bool = false

    private let columns: [GridItem] = Array(repeating: GridItem(.flexible(), spacing: 40), count: 2)

    var body: some View {
        ZStack {
            VStack {
                ViewTitle(title: "Plant Gallery")

                ScrollView(showsIndicators: false) {
                    LazyVGrid(columns: columns, spacing: 40) {
                        ForEach(userPlantManager.getUserPlantsSorted()) { plant in
                            PlantGalleryCard(userPlantModel: plant)
                                .onTapGesture {
                                    withAnimation {
                                        selectedPlant = plant
                                        showPopUp = true
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
                        dismissPopup()
                    }

                PopUp.plantStats(
                    currentPlantModel: userPlantManager.currentPlant!,
                    swapabblePlantModel: plant,
                    showPopUp: $showPopUp
                )
                .frame(width: 300, height: 250)
                .transition(.scale)
            }
        }
    }

    private func dismissPopup() {
        withAnimation {
            showPopUp = false
            selectedPlant = nil
        }
    }
}

#Preview {
    PlantGalleryView()
        .environmentObject(UserPlantManager.shared)
        .padding(.horizontal, 30)
        .background(Color.mainBackground)
    
}
