//
//  HomeView.swift
//  LilyPath
//
//  Created by Carolyn Heron on 9/29/24.
//

import SwiftUI

struct HomeView: View {
    @EnvironmentObject var userPlantManager: UserPlantManager
    
    var body: some View {
        NavigationView {
            ZStack {
                Color.mainBackground
                    .ignoresSafeArea(.all)
                
                VStack {
                    HStack {
                        HowToPlayButton()
                        UserCurrencyBar()
                    }
                    .padding(.top, 20)
                    .padding(.horizontal, 5)
                    
                    VStack {
                        CurrentPlantDisplay()
                        
                        HomeViewActions()
                            .offset(y: -50)
                    }
                    .padding(.top, 50)
                    
                    Spacer()
                }
                .background(Color.mainBackground)
            }
        }
        .navigationViewStyle(StackNavigationViewStyle())
    }
}

struct HowToPlayButton: View {
    @State private var showSheet = false
    
    var body: some View {
        VStack {
            Button(action: {
                showSheet = true
            }) {
                IconImage(
                    icon: .questionMark,
                    font: .system(size: 20, weight: .bold, design: .rounded),
                    color: .white
                )
                .padding(16)
                .background(
                    Circle()
                        .fill(Color.customBrown)
                        .overlay(
                            Circle()
                                .inset(by: 2.5)
                                .stroke(Color.customPink, lineWidth: 5)
                        )
                        .shadow(
                            radius: ShadowConstants.radius,
                            y: ShadowConstants.yOffset)
                )
            }
            .sheet(isPresented: $showSheet) {
                HowToPlayView(showSheet: $showSheet)
            }
        }
    }
}

struct CurrentPlantDisplay: View {
    @EnvironmentObject var userPlantManager: UserPlantManager
    
    let lineThickness: CGFloat = 18
    
    var body: some View {
        if let currentPlant = userPlantManager.currentPlant {
            VStack {
                Text(currentPlant.basePlant.species)
                    .font(.viewTitle)
                    .foregroundColor(.customBrown)
                
                ZStack {
                    CircularProgressBar(
                        value: Double(currentPlant.stepsInCurrentStage),
                        total: Double(currentPlant.currentStageGoal),
                        lineWidth: lineThickness
                    )
                    
                    // Sky
                    Circle()
                        .fill(Color.lightBlue)
                        .padding(lineThickness * 0.5)
                    
                    // Soil
                    Circle()
                        .trim(from: 0, to: 0.5)
                        .fill(Color.customBrown)
                        .padding(lineThickness * 1.5)
                    
                    // Plant
                    VStack {
                        Spacer()
                        
                        Image(currentPlant.currentImage)
                            .resizable()
                            .scaledToFit()
                            .frame(
                                maxWidth: currentPlant.currentStage == 1
                                ? 40 : 70
                            )
                            .modifier(
                                WiltFlowerEffect(
                                    applyEffects: currentPlant.status == .wilted
                                )
                            )
                    }
                    .frame(maxHeight: 120)
                }
                .padding(20)
            }
        } else {
            // Placeholder when no current plant is selected
            Text("No current plant selected")
                .font(.headline)
                .foregroundColor(.gray)
                .padding()
        }
    }
}

struct HomeViewActions: View {
    @EnvironmentObject var userPlantManager: UserPlantManager
    @ObservedObject var userModel = UserModel.shared
    
    var body: some View {
        HStack(alignment: .bottom, spacing: 60) {
            NavigationLink(
                destination: PlantShopView(
                    plants: BasePlantModel.allPlants)
            ) {
                IconWithText(
                    icon: .newPlant,
                    color: Color.darkGreen,
                    text: "New Plant"
                )
                .frame(height: 150)
            }
            
            // TODO: Implement watering functionality
            Button(
                action: {
                    waterCurrentPlant()
                }
            ) {
                IconWithText(
                    icon: .waterDrop,
                    color: Color.waterBlue,
                    text: "Water"
                )
            }
            
            // TODO: Replace tasks with actual daily tasks
            NavigationLink(
                destination: DailyTasksView()
            ) {
                IconWithText(
                    icon: .dailyTask,
                    color: Color.customPink,
                    text: "Daily Tasks"
                )
                .frame(height: 160)
            }
        }
    }
    
    private func waterCurrentPlant() {
        if userModel.waterPoints >= 1000
            && userPlantManager.currentPlant?.status != .completed
        {
            userPlantManager.waterCurrentPlant()
            userModel.updateWaterPoints(by: -1000)
            print(
                "Watered plant. Remaining water points: \(userModel.waterPoints)"
            )
        } else {
            print("Not enough water points to water the plant.")
        }
    }
}

struct IconWithText: View {
    let icon: Icon
    let color: Color
    let text: String
    
    var body: some View {
        VStack {
            IconImage(icon: icon, font: .homeIcons, color: color)
            
            Text(text)
                .font(Font.customBody)
                .foregroundColor(.customBrown)
        }
    }
}

#Preview {
    HomeView()
        .padding(.horizontal, 30)
        .background(Color.mainBackground)
        .environmentObject(UserPlantManager.shared)
}
