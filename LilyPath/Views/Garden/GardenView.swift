//
//  GardenView.swift
//  LilyPath
//
//  Created by Carolyn Heron on 9/29/24.
//

import SwiftUI

struct GardenView: View {
    @EnvironmentObject var userPlantManager: UserPlantManager
    
    var body: some View {
        NavigationStack {
            ScrollView {
                VStack {
                    GardenNavigationLink(
                        title: "Your Garden",
                        destination: PlantGalleryView())
                    
                    YourGardenView()
                        .padding(.bottom, 30)
                    
                    // TODO: replace with current plant popup
                    //                    GardenNavigationLink(
                    //                        title: "Current Plant", destination: GardenView())
                    Text("Current Plant")
                        .font(.viewTitle)
                        .foregroundColor(.customBrown)
                        .frame(maxWidth: .infinity, alignment: .leading)
                    
                    CurrentPlantView()
                    
                    Spacer()
                }
            }
            .background(Color.mainBackground)
        }
    }
}

struct YourGardenView: View {
    @EnvironmentObject var userPlantManager: UserPlantManager
    
    private let columns: [GridItem] = Array(
        repeating: GridItem(.flexible(), spacing: 10), count: 6)
    
    var body: some View {
        LazyVGrid(columns: columns, spacing: 10) {
            ForEach(userPlantManager.getUserPlantsSorted(), id: \.id) { plant in
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
    @EnvironmentObject var userPlantManager: UserPlantManager
    
    var body: some View {
        if let currentPlant = userPlantManager.currentPlant {
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
                            value: Double(
                                currentPlant.stepsInCurrentStage),
                            total: Double(
                                currentPlant.currentStageGoal),
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
        .environmentObject(UserPlantManager.shared)
        .background(Color.mainBackground)
        .padding(.horizontal, 30)
}
