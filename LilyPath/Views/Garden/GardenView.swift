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
    
    @State private var selectedPlant: UserPlantModel? = nil
    @State private var showPopUp: Bool = false
    
    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(spacing: 30) {
                    GardenNavigationLink(
                        title: "Your Garden",
                        destination: PlantGalleryView()
                    )
                    
                    YourGardenView(userPlants: userPlants)
                        .padding(.bottom, 30)
                    
                    Button(action: {
                        withAnimation {
                            if let currentPlant = userPlants.first(where: {
                                $0.isCurrent
                            }) {
                                selectedPlant = currentPlant
                                showPopUp = true
                            }
                        }
                    }) {
                        HStack {
                            Text("Current Plant")
                            Spacer()
                            Image(systemName: "chevron.right")
                        }
                        .font(.viewTitle)
                        .foregroundColor(.customBrown)
                        .frame(maxWidth: .infinity, alignment: .leading)
                    }
                    
                    CurrentPlantView(
                        currentPlant: userPlants.first(where: { $0.isCurrent }))
                    
                    Spacer()
                }
            }
            .background(Color.mainBackground)
            .overlay(
                ZStack {
                    if let plant = selectedPlant, showPopUp {
                        Color.mainBackground.opacity(0.4)
                            .ignoresSafeArea()
                            .onTapGesture {
                                dismissStatPopup()
                            }
                        
                        PopUp.plantStats(
                            currentPlantModel: plant,
                            swappablePlantModel: plant,
                            showPopUp: $showPopUp
                        ) {}
                            .frame(width: 300, height: 250)
                            .transition(.scale)
                    }
                }
            )
        }
        .animation(.easeInOut, value: showPopUp)
    }
    
    private func dismissStatPopup() {
        withAnimation {
            showPopUp = false
            selectedPlant = nil
        }
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
                    Text(currentPlant.basePlant.species)
                        .font(.currentPlant)
                        .foregroundColor(.white)
                    
                    HStack {
                        ProgressBar(
                            value: Double(currentPlant.stepsInCurrentStage),
                            total: Double(currentPlant.currentStageGoal),
                            frameHeight: 16
                        )
                        .padding(.bottom, 5)
                        
                        Text("\(Int(currentPlant.stageProgress * 100))%")
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

struct GardenNavigationLink<Destination: View>: View {
    let title: String
    let destination: Destination
    
    var body: some View {
        NavigationLink(destination: destination) {
            HStack {
                ViewTitle(title: title)
                
                Spacer()
                
                Image(systemName: "chevron.right")
                    .font(.viewTitle)
                    .foregroundColor(Color.customBrown)
            }
        }
    }
}

#Preview {
    GardenView()
        .background(Color.mainBackground)
        .padding(.horizontal, 30)
}
