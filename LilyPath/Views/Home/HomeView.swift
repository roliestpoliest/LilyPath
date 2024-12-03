//
//  HomeView.swift
//  LilyPath
//
//  Created by Carolyn Heron on 9/29/24.
//

import SwiftUI
import SwiftData

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
                    
//                    UserLevelBar()
                    Rectangle()
                        .frame(height: 0)
                        .padding(.top, 20)
                        .padding(.horizontal, 5)
                    
                    VStack {
                        CurrentPlantDisplay()
                            .padding(.horizontal)
                        
                        HomeViewActions()
                            .offset(y: -50)
                    }
                    .padding(.top, 20)
                    
                    Spacer()
                }
                .background(Color.mainBackground)
            }
        }
        .navigationViewStyle(StackNavigationViewStyle())
    }
}

//struct UserLevelBar: View {
//    @ObservedObject var userModel = UserModel.shared
//    
//    var body: some View {
//        HStack {
//            Text("Lvl \(userModel.level)")
//                .font(.customBody)
//                .foregroundColor(Color.customBrown)
//            
//            Spacer()
//            
//            ZStack {
//                ProgressBar(
//                    value: Double(userModel.xpProgress),
//                    total: Double(1),
//                    frameHeight: 30,
//                    foregroundColor: Color.darkerBlue,
//                    backgroundColor: Color.waterBlue,
//                    applyShadow: true
//                )
//                .frame(height: 40)
//                
//                Text("\(Int(userModel.xpProgress * 100))/100 XP")
//                    .font(.label)
//                    .foregroundColor(.white)
//                    .shadow(radius: ShadowConstants.radius, y: ShadowConstants.yOffset)
//            }
//        }
//    }
//}

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
        }
    }
}

struct HomeViewActions: View {
    @EnvironmentObject var userPlantManager: UserPlantManager
    @Environment(\.modelContext) private var context
    @Query private var currencyModels: [CurrencyModel] // Fetch CurrencyModel
    
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
        guard let currencyModel = currencyModels.first else {
            print("No CurrencyModel found.")
            return
        }
        
        if currencyModel.waterPoints >= 1000
            && userPlantManager.currentPlant?.status != .completed
        {
            userPlantManager.waterCurrentPlant()
            currencyModel.waterPoints -= 1000 // Subtract 1000 water points
            
            do {
                try context.save()
                print("Watered plant. Remaining water points: \(currencyModel.waterPoints)")
            } catch {
                print("Failed to save updated water points: \(error)")
            }
        } else {
            print("Cannot water plant. Not enough water points or plant is already completed.")
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
