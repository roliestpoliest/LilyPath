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
                
                CurrentPlantDisplay(userCurrentPlant: $userCurrentPlant)
                    .offset(y: -20)
                
                HomeViewActions()
                    .offset(y: 200)
            }
        }
        .navigationViewStyle(StackNavigationViewStyle())
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
                            ? 40 : 70)
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
                    icon: .newPlant, height: 50,
                    color: Color.darkGreen, text: "New Plant"
                )
                .frame(height: 150)
            }
            
            // TODO: Implement watering functionality
            Button(action: {
                print("Watering plant")
            }) {
                IconWithText(
                    icon: .waterDrop, height: 55,
                    color: Color.waterBlue, text: "Water"
                )
            }
            
            NavigationLink(
                destination: DailyTasksView(
                    tasks: generateRandomTasks())
            ) {
                IconWithText(
                    icon: .dailyTask, height: 60,
                    color: Color.customPink, text: "Daily Tasks"
                )
                .frame(height: 160)
            }
        }
    }
}

struct IconWithText: View {
    let icon: Icon
    let height: CGFloat
    let color: Color
    let text: String
    
    var body: some View {
        VStack {
            IconImage(icon: icon, height: height, color: color)
            
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
                basePlant: BasePlantModel.buttercup, currentStage: 3,
                stepsCollected: [100, 200, 100].reduce(0, +))
    )
    .padding(.horizontal, 30)
    .background(Color.mainBackground)
}
