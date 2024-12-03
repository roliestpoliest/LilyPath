//
//  HomeView.swift
//  LilyPath
//
//  Created by Carolyn Heron on 9/29/24.
//

import SwiftUI
import SwiftData

struct HomeView: View {
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
        .environment(\.modelContext, AppModelContainer.shared.container.mainContext)
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
    @Query(
        filter: #Predicate { (plant: UserPlantModel) in
            plant.isCurrent == true
        }
    )
    private var currentPlants: [UserPlantModel] // Real-time query for the current plant
    
    let lineThickness: CGFloat = 18

    var body: some View {
        if let currentPlant = currentPlants.first { // Take the first current plant if it exists
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
            Text("No current plant to display...")
                .font(.customBody)
                .foregroundColor(.customBrown)
        }
    }
}

struct HomeViewActions: View {
    @Environment(\.modelContext) private var context
    @Query private var currencyModels: [CurrencyModel]
    @Query private var basePlants: [BasePlantModel]
    
    private var currentPlant: UserPlantModel? {
        let fetchDescriptor = FetchDescriptor<UserPlantModel>(
            predicate: #Predicate { $0.isCurrent == true }
        )
        return try? context.fetch(fetchDescriptor).first
    }
    
    var body: some View {
        HStack(alignment: .bottom, spacing: 60) {
            NavigationLink(
                destination: PlantShopView()
            ) {
                IconWithText(
                    icon: .newPlant,
                    color: Color.darkGreen,
                    text: "New Plant"
                )
                .frame(height: 150)
            }
            
            Button(action: waterCurrentPlant) {
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
        
        guard let currentPlant = currentPlant else {
            print("No current plant found.")
            return
        }
        
        guard currencyModel.waterPoints >= 1000, currentPlant.status != .completed else {
            print("Cannot water plant. Not enough water points or plant is already completed.")
            return
        }
        
        // Perform watering and deduct water points
        currentPlant.waterPlant()
        currencyModel.waterPoints -= 1000
        
        do {
            try context.save()
            print("Watered plant. Remaining water points: \(currencyModel.waterPoints)")
        } catch {
            print("Failed to save updated water points: \(error)")
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
}
