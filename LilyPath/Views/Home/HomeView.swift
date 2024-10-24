//
//  HomeView.swift
//  LilyPath
//
//  Created by Carolyn Heron on 9/29/24.
//

import SwiftUI

struct HomeView: View {
    @State var userCurrentPlant: UserPlantModel
    
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
                        CurrentPlantDisplay(userCurrentPlant: $userCurrentPlant)
                        
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
    let lineThickness: CGFloat = 18
    @Binding var userCurrentPlant: UserPlantModel
    
    var body: some View {
        VStack {
            Text(userCurrentPlant.basePlant.species)
                .font(.viewTitle)
                .foregroundColor(.customBrown)
            
            ZStack {
                CircularProgressBar(
                    value: Double(userCurrentPlant.stepsInCurrentStage),
                    total: Double(userCurrentPlant.currentStageGoal),
                    lineWidth: lineThickness)
                
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
                    
                    Image(userCurrentPlant.currentImage)
                        .resizable()
                        .scaledToFit()
                        .frame(
                            maxWidth: userCurrentPlant.currentStage == 1
                            ? 40 : 70
                        )
                        .modifier(
                            WiltFlowerEffect(
                                applyEffects: userCurrentPlant.status == .wilted
                            ))
                }
                .frame(maxHeight: 120)
            }
            .padding(20)
        }
    }
}

struct HomeViewActions: View {
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
                    print("Watering plant")
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
    HomeView(
        userCurrentPlant:
            UserPlantModel(
                basePlant: BasePlantModel.buttercup, currentStage: 4,
                watersCollected: 12,
                status: .wilted)
    )
    .padding(.horizontal, 30)
    .background(Color.mainBackground)
}
