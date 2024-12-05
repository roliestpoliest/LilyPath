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
    @Query(sort: [
        SortDescriptor(\UserPlantModel.currentStage, order: .forward),
        SortDescriptor(\UserPlantModel.basePlant.species, order: .forward),
    ])
    private var userPlants: [UserPlantModel]
    
    @State private var selectedPlant: UserPlantModel? = nil
    @State private var showPopUp: Bool = false
    
    private let columns: [GridItem] = Array(
        repeating: GridItem(.flexible(), spacing: 40), count: 2)
    
    var body: some View {
        ZStack {
            VStack {
                ViewTitle(title: "Plant Gallery")
                
                ScrollView(showsIndicators: false) {
                    LazyVGrid(columns: columns, spacing: 40) {
                        ForEach(userPlants) { plant in
                            PlantGalleryCard(userPlantModel: plant)
                                .onTapGesture {
                                    selectedPlant = plant
                                    showPopUp = true
                                }
                        }
                    }
                }
                .shadow(
                    radius: ShadowConstants.radius, y: ShadowConstants.yOffset)
            }
            .background(Color.mainBackground)
            .popUpOverlay(isVisible: $showPopUp) {
                if let selectedPlant = selectedPlant,
                   let currentPlant = userPlants.first(where: { $0.isCurrent })
                {
                    PopUp.plantStats(
                        currentPlantModel: currentPlant,
                        swappablePlantModel: selectedPlant,
                        showPopUp: $showPopUp,
                        onSwap: handleSwap
                    )
                }
            }
        }
        .animation(.easeInOut, value: showPopUp)
    }
    
    private func handleSwap(with newPlant: UserPlantModel) {
        guard let currentPlant = userPlants.first(where: { $0.isCurrent })
        else {
            print("No current plant found to swap.")
            return
        }
        
        currentPlant.isCurrent = false
        newPlant.isCurrent = true
        
        do {
            try context.save()
            print("Swapped to new plant: \(newPlant.basePlant.species)")
        } catch {
            print("Failed to swap plants: \(error)")
        }
        
        dismissPopup()
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
