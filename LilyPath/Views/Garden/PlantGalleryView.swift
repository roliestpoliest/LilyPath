//
//  PlantGalleryView.swift
//  LilyPath
//
//  Created by Carolyn Heron on 10/6/24.
//

import SwiftData
import SwiftUI

struct PlantGalleryView: View {
    @Environment(\.modelContext) private var context
    @Query(sort: [SortDescriptor(\UserPlantModel.currentStage, order: .forward),
                  SortDescriptor(\UserPlantModel.basePlant.species, order: .forward)])
    private var userPlants: [UserPlantModel]
    
    @State private var selectedPlant: UserPlantModel? = nil
    @State private var showPopUp: Bool = false

    private let columns: [GridItem] = Array(repeating: GridItem(.flexible(), spacing: 40), count: 2)

    var body: some View {
        ZStack {
            VStack {
                ViewTitle(title: "Plant Gallery")

                ScrollView(showsIndicators: false) {
                    LazyVGrid(columns: columns, spacing: 40) {
                        ForEach(userPlants) { plant in
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
                Color.mainBackground.opacity(0.4)
                    .ignoresSafeArea()
                    .onTapGesture {
                        dismissPopup()
                    }

                PopUp.plantStats(
                    currentPlantModel: userPlants.first(where: { $0.isCurrent })!,
                    swappablePlantModel: plant,
                    showPopUp: $showPopUp
                )
                .frame(width: 300, height: 250)
                .transition(.scale)
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
    PlantGalleryView()
        .padding(.horizontal, 30)
        .background(Color.mainBackground)
    
}
