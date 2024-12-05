//
//  GardenView.swift
//  LilyPath
//
//  Created by Carolyn Heron on 9/29/24.
//

import SwiftData
import SwiftUI

struct GardenView: View {
    @Environment(\.modelContext) private var context
    @Query(sort: [SortDescriptor(\UserPlantModel.plantDate, order: .reverse)])
    private var userPlants: [UserPlantModel]
    
    @State private var currentPlant: UserPlantModel? = nil
    @State private var showPopUp: Bool = false
    
    var body: some View {
        NavigationStack {
            ScrollView {
                VStack {
                    SubViewNavigationLink(
                        title: "Your Garden",
                        destination: PlantGalleryView()
                    ) {
                        YourGardenView(userPlants: userPlants)
                    }
                    .padding(.bottom, 30)

                    VStack {
                        HStack {
                            Text("Current Plant")
                            Spacer()
                            Image(systemName: "chevron.right")
                        }
                        .font(.viewTitle)
                        .foregroundColor(.customBrown)
                        .frame(maxWidth: .infinity, alignment: .leading)
                        
                        CurrentPlantView(
                            currentPlant: userPlants.first(where: { $0.isCurrent }))
                        .customShadow()
                    }
                    .onTapGesture {
                        if let currentPlant = userPlants.first(where: {
                            $0.isCurrent
                        }) {
                            self.currentPlant = currentPlant
                            showPopUp = true
                        }
                    }
                    
                    Spacer()
                }
            }
            .background(Color.mainBackground)
            .popUpOverlay(isVisible: $showPopUp) {
                if let plant = currentPlant, showPopUp {
                    PopUp.plantInfo(
                        currentPlantModel: plant,
                        swappablePlantModel: plant,
                        showPopUp: $showPopUp,
                        onSwap: { _ in }
                    )
                }
            }
        }
        .animation(.easeInOut, value: showPopUp)
    }
}

struct YourGardenView: View {
    let userPlants: [UserPlantModel]
    
    private let columns: [GridItem] = Array(
        repeating: GridItem(.flexible(), spacing: 10), count: 6
    )
    
    // Sort userPlants based on currentStage and species
    private var sortedPlants: [UserPlantModel] {
        userPlants.sorted {
            if $0.currentStage == $1.currentStage {
                return $0.basePlant.species < $1.basePlant.species
            } else {
                return $0.currentStage < $1.currentStage
            }
        }
    }
    
    var body: some View {
        LazyVGrid(columns: columns, spacing: 10) {
            ForEach(sortedPlants, id: \.id) { plant in
                Image(plant.currentImage)
                    .resizable()
                    .scaledToFit()
                    .frame(width: 40, height: 60)
            }
        }
        .padding(20)
        .frame(maxWidth: .infinity, minHeight: 200)
        .background(
            RoundedRectangle(cornerRadius: 20)
                .fill(Color.customBrown)
                .overlay(
                    RoundedRectangle(cornerRadius: 20)
                        .inset(by: 3)
                        .stroke(Color.customPink, lineWidth: 6)
                )
        )
    }
}

struct CurrentPlantView: View {
    let currentPlant: UserPlantModel?
    
    var body: some View {
        if let currentPlant = currentPlant {
            HStack {
                Image(currentPlant.currentImage)
                    .resizable()
                    .scaledToFit()
                    .frame(width: 40)
                    .padding(.leading, 10)
                
                VStack(alignment: .leading) {
                    HStack {
                        Text(currentPlant.basePlant.species)
                            .font(.currentPlant)
                            .foregroundColor(.white)
                    }
                    
                    HStack {
                        Image(
                            systemName:
                                "\(currentPlant.currentStage).circle.fill"
                        )
                        .foregroundColor(.lightGreen)
                        .bold()
                        
                        let stepsInCurrentStage: Double = currentPlant.currentStage == 5
                            ? 1 // Mark as full steps for final stage 5
                            : Double(currentPlant.stepsInCurrentStage)
                        
                        ProgressBar(
                            value: stepsInCurrentStage,
                            total: Double(currentPlant.currentStageGoal),
                            frameHeight: 16
                        )
                        
                        let stageProgress = currentPlant.currentStage == 5
                            ? 100 // Mark as full progress for final stage 5
                            : (currentPlant.stageProgress * 100)
                        
                        Text("\(Int(stageProgress))%")
                            .font(Font.label)
                            .foregroundColor(.white)
                            .frame(width: 35)
                    }
                }
                .padding(.leading, 10)
                
                Spacer()
            }
            .padding(20)
            .frame(maxWidth: .infinity, minHeight: 120)
            .background(
                RoundedRectangle(cornerRadius: 20)
                    .fill(Color.customBrown)
                    .overlay(
                        RoundedRectangle(cornerRadius: 20)
                            .inset(by: 3)
                            .stroke(Color.customPink, lineWidth: 6)
                    )
            )
        }
    }
}

#Preview {
    GardenView()
        .background(Color.mainBackground)
        .padding(.horizontal, 30)
}
