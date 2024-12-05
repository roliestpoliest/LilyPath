//
//  HomeView.swift
//  LilyPath
//
//  Created by Carolyn Heron on 9/29/24.
//

import SwiftUI
import SwiftData

struct HomeView: View {
    @Query(
        filter: #Predicate { (plant: UserPlantModel) in
            plant.isCurrent == true
        }
    )
    private var currentPlants: [UserPlantModel]
    
    @Query private var currencyModels: [CurrencyModel]
    
    @State var showPopUp: Bool = false
    @State var showCurrencyPopUp: Bool = false
    
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
                    
                    Rectangle()
                        .frame(height: 0)
                        .padding(.top, 20)
                        .padding(.horizontal, 5)
                    
                    VStack {
                        CurrentPlantDisplay()
                            .padding(.horizontal)
                        
                        HomeViewActions(showPopUp: $showPopUp)
                            .offset(y: -50)
                    }
                    .padding(.top, 20)
                    
                    Spacer()
                }
                .background(Color.mainBackground)
            }
        }
        .navigationViewStyle(StackNavigationViewStyle())
        .onAppear {
            Task {
                unconvertedSteps = await getUnconvertedUserDailySteps(currencyModels: currencyModels, healthManager: healthManager)
            }
        }
        .popUpOverlay(isVisible: $showPopUp) {
            if let currentPlant = currentPlants.first {
                PopUp.levelUp(
                    currentPlant: currentPlant,
                    showPopUp: $showPopUp,
                    onLevelUp: onLevelUp
                )
            }
        }
        .popUpOverlay(isVisible: $showCurrencyPopUp) {
            PopUp.addWaterPoints(
                steps: unconvertedSteps,
                showPopUp: $showCurrencyPopUp,
                currencyModels: currencyModels,
                onConvert: onConvert,
                onBuy: onBuy
            )
        }
    }
    
    func onLevelUp() {
        showPopUp = false

        guard let currentPlant = currentPlants.first else {
            print("No current plant found.")
            return
        }

        guard let currencyModel = currencyModels.first else {
            print("No CurrencyModel found.")
            return
        }

        if currentPlant.status == .growing {
            currencyModel.gems += 1
        } else if currentPlant.status == .completed {
            currencyModel.gems += currentPlant.basePlant.gemReward
        }
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
    @Query(
        filter: #Predicate { (plant: UserPlantModel) in
            plant.isCurrent == true
        }
    )
    private var currentPlants: [UserPlantModel]
    
    let lineThickness: CGFloat = 18

    var body: some View {
        if let currentPlant = currentPlants.first {
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
    
    @Binding var showPopUp: Bool
    @State var canWaterPlant: Bool = false
    
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
                    text: "Water",
                    isDisabled: !canWater()
                )
            }
            .disabled(!canWater())
            
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
    
    private func canWater() -> Bool {
        guard let currencyModel = currencyModels.first else {
            print("No CurrencyModel found.")
            return false
        }
        
        guard let currentPlant = currentPlant else {
            print("No current plant found.")
            return false
        }
        
        guard currencyModel.waterPoints >= 1000 else {
            print("Not enough water points to water the plant.")
            return false
        }
        
        guard currentPlant.status != .completed else {
            print("Plant is already completed.")
            return false
        }
        
        return true
    }
    
    private func waterCurrentPlant() {
        guard canWater() else { return }
        
        guard let currencyModel = currencyModels.first,
              let currentPlant = currentPlant else { return }
        
        // Perform watering and deduct water points
        let isNextStage = currentPlant.waterPlant()
        currencyModel.waterPoints -= 1000
        
        showPopUp = isNextStage
        
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
    let isDisabled: Bool
    
    init(icon: Icon, color: Color, text: String, isDisabled: Bool = false) {
        self.icon = icon
        self.color = color
        self.text = text
        self.isDisabled = isDisabled
    }
    
    var body: some View {
        VStack {
            IconImage(icon: icon, font: .homeIcons, color: color)
            
            Text(text)
                .font(Font.customBody)
                .foregroundColor(.customBrown)
        }
        .colorMultiply(isDisabled ? .disabledLightGrey.opacity(0.6) : .white)
    }
}

#Preview {
    HomeView()
        .padding(.horizontal, 30)
        .background(Color.mainBackground)
}
