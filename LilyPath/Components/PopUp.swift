//
//  PlantPopUp.swift
//  LilyPath
//
//  Created by Carolyn Heron on 10/5/24.
//

import SwiftUI

// MARK: Generic view
struct GenericPopUpView<Content: View>: View {
    @Binding var showPopUp: Bool
    var headerColor: Color = .customPink
    var textColor: Color = .customBrown
    var x_color: Color = .redButton
    var headerText: String
    var content: () -> Content
    var width: CGFloat = 275
    var height: CGFloat = 200
    
    var body: some View {
        ZStack {
            VStack {
                header(
                    text: headerText, headerColor: headerColor,
                    textColor: textColor, x_color: x_color)
                
                Spacer()
                
                content()
                
                Spacer()
            }
            .font(.popupBody)
            .foregroundColor(textColor)
            .frame(width: width, height: height)
            .padding()
            .background(.mainBackground)
            .cornerRadius(25)
            .overlay(
                RoundedRectangle(cornerRadius: 25)
                    .stroke(.customBrown, lineWidth: 5)
            )
        }
        .zIndex(1)
    }
    // MARK: header
    private func header(
        text: String,
        headerColor: Color,
        textColor: Color,
        x_color: Color
    ) -> some View {
        ZStack {
            UnevenRoundedRectangle(
                topLeadingRadius: 17, bottomLeadingRadius: 0,
                bottomTrailingRadius: 0, topTrailingRadius: 17
            )
            .fill(headerColor)
            .customShadow()
            .frame(height: 50)
            
            ZStack {
                Text(text.uppercased())
                    .font(Font.popupTitle)
                    .foregroundColor(textColor)
                
                HStack {
                    Spacer()
                    Button(action: {
                        print("Close button tapped")
                        showPopUp = false
                    }) {
                        IconImage(icon: .x, height: 20, color: x_color)
                    }
                }
            }
            .padding()
        }
    }
}

// MARK: Pop Up Class
class PopUp {
    static func purchase(
        plantModel: BasePlantModel,
        showPopUp: Binding<Bool>,
        hasEnoughGems: Bool,
        onPurchase: @escaping (BasePlantModel) -> Void
    ) -> some View {
        GenericPopUpView(
            showPopUp: showPopUp,
            headerText: "Purchase",
            content: {
                HStack(spacing: 30) {
                    plantImage(image: plantModel.stageImages[4])
                    
                    VStack(spacing: 15) {
                        if hasEnoughGems {
                            Text(plantModel.species)
                        } else {
                            Text("Not enough gems!")
                        }
                        
                        actionButton(
                            text: String(plantModel.price),
                            icon: .gem,
                            isDisabled: !hasEnoughGems
                        ) {
                            if hasEnoughGems {
                                onPurchase(plantModel)
                                showPopUp.wrappedValue = false
                                print("Purchase button tapped")
                            } else {
                                print(
                                    "Attempted to purchase with insufficient gems"
                                )
                            }
                        }
                    }
                }
            }
        )
    }
    
    // MARK: locked
    static func locked(plantModel: BasePlantModel, showPopUp: Binding<Bool>)
    -> some View
    {
        GenericPopUpView(
            showPopUp: showPopUp,
            headerText: "Womp Womp",
            content: {
                HStack(spacing: 20) {
                    plantImage(image: plantModel.stageImages[4])
                    
                    VStack(alignment: .center, spacing: 15) {
                        Text(
                            "\(plantModel.species) is locked!\nUnlock at level \(plantModel.requiredLevelToBuy)"
                        )
                        .multilineTextAlignment(.center)
                    }
                }
            }
        )
    }
    
    // MARK: wilt
    static func wilt(plantModel: BasePlantModel, showPopUp: Binding<Bool>)
    -> some View
    {
        GenericPopUpView(
            showPopUp: showPopUp,
            headerText: "Uh oh!",
            content: {
                HStack(spacing: 10) {
                    plantImage(
                        image: plantModel.stageImages[4], applyEffects: true)
                    
                    VStack(spacing: 15) {
                        Text("Your \(plantModel.species) is wilting!")
                            .multilineTextAlignment(.center)
                        
                        actionButton(
                            text: "-1000", secondText: "Revive?",
                            icon: .waterDrop
                        ) {
                            print("Revive button tapped")
                        }
                    }
                }
            }
        )
    }
    
    // MARK: level up
    static func levelUp(
        currentPlant: UserPlantModel,
        showPopUp: Binding<Bool>,
        onLevelUp: @escaping () -> Void
    ) -> some View {
        let isGrowing = currentPlant.status == .growing
        
        return GenericPopUpView(
            showPopUp: showPopUp,
            headerText: isGrowing ? "Level Up!" : "CONGRATS!",
            content: {
                HStack(spacing: 10) {
                    plantImage(image: currentPlant.currentImage)
                    
                    VStack(spacing: 15) {
                        Text(
                            isGrowing
                            ? "Your \(currentPlant.basePlant.species) is at a new stage"
                            : "You completed this \(currentPlant.basePlant.species)"
                        )
                        .multilineTextAlignment(.center)
                        
                        actionButton(
                            text: isGrowing
                            ? "+1"
                            : "+\(String(currentPlant.basePlant.gemReward))",
                            icon: .gem
                        ) {
                            onLevelUp()
                            print(
                                isGrowing
                                ? "Level up button tapped"
                                : "Completed button tapped")
                        }
                    }
                    .frame(width: 175)
                }
            }
        )
    }
    
    // MARK: plant info
    static func plantInfo(
        currentPlantModel: UserPlantModel,
        swappablePlantModel: UserPlantModel,
        showPopUp: Binding<Bool>,
        onSwap: @escaping (UserPlantModel) -> Void
    ) -> some View {
        let showSwapButton = currentPlantModel.id != swappablePlantModel.id
        let additionalHeight: CGFloat = showSwapButton ? 50 : 0

        func gridRow(label: String, value: String) -> some View {
            GridRow {
                Text(label)
                    .frame(width: 150, alignment: .leading)
                    .font(.statsBodyBold)
                Text(value)
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .font(.statsBody)
            }
        }

        return GenericPopUpView(
            showPopUp: showPopUp,
            headerText: "PLANT INFO",
            content: {
                VStack {
                    PlantInfoView(currentPlant: swappablePlantModel)
                        .padding(.bottom, 20)

                    Grid {
                        gridRow(
                            label: "Plant Date",
                            value: swappablePlantModel.plantDate.formatted(
                                .dateTime.month(.abbreviated).day(.twoDigits).year()
                            )
                        )
                        gridRow(
                            label: "Completion Date",
                            value: swappablePlantModel.completionDate.map {
                                $0.formatted(.dateTime.month(.abbreviated).day(.twoDigits).year())
                            } ?? "N/A"
                        )
                        gridRow(
                            label: "Last Watered",
                            value: swappablePlantModel.lastWateredDate.map {
                                $0.formatted(.dateTime.month(.abbreviated).day(.twoDigits).year())
                            } ?? "N/A"
                        )
                        gridRow(
                            label: "Waterings Left",
                            value: formatNumberWithCommas((swappablePlantModel.basePlant.overallStepGoal - swappablePlantModel.stepsCollected) / 1000)
                        )
                        gridRow(
                            label: "Overall Progress",
                            value: "\(Int((swappablePlantModel.overallProgress) * 100))%"
                        )
                    }

                    if showSwapButton {
                        actionButton(text: "Swap to Current") {
                            onSwap(swappablePlantModel)
                            showPopUp.wrappedValue = false
                            print("Swap button tapped")
                        }
                        .padding(.top, 10)
                    }
                }
                .padding()
            },
            width: 300,
            height: 290 + additionalHeight
        )
    }
    
    // MARK: swap
    static func swapPlant(
        currentPlantModel: UserPlantModel, swappablePlantModel: UserPlantModel,
        showPopUp: Binding<Bool>
    ) -> some View {
        GenericPopUpView(
            showPopUp: showPopUp,
            headerText: "Swap Plant",
            content: {
                HStack {
                    plantImage(image: swappablePlantModel.currentImage)
                    VStack(spacing: 15) {
                        Text(
                            "Switch from \(currentPlantModel.basePlant.species) to \(swappablePlantModel.basePlant.species)?"
                        )
                        .multilineTextAlignment(.center)
                        
                        actionButton(text: "Yes") {
                            print("Swap button tapped")
                        }
                    }
                    .frame(width: 175)
                }
            }
        )
    }
    
    // MARK: add water points
    static func addWaterPoints(
        steps: Int,
        showPopUp: Binding<Bool>,
        currencyModels: [CurrencyModel],
        onConvert: @escaping ([CurrencyModel], Int) -> Void,
        onBuy: @escaping ([CurrencyModel]) -> Void
    ) -> some View {
        GenericPopUpView(
            showPopUp: showPopUp,
            headerText: "WATER POINTS",
            content: {
                VStack(spacing: 30) {
                    ForEach(
                        [
                            (
                                currency: "daily steps",
                                text: "\(steps)",
                                converting: Icon.steps,
                                text2: "\(steps)",
                                buttonText: "Convert",
                                onAction: { onConvert(currencyModels, steps) },
                                isDisabled: steps < 1
                            ),
                            (
                                currency: "gems",
                                text: "1",
                                converting: Icon.gem,
                                text2: "3000",
                                buttonText: "Buy",
                                onAction: { onBuy(currencyModels) },
                                isDisabled: currencyModels.first?.gems ?? 0 < 1
                            ),
                        ], id: \.text
                    ) { item in
                        VStack {
                            Text("Use \(item.currency):")
                                .fontWeight(.bold)
                            
                            // Conversion rate
                            HStack {
                                Text(item.text)
                                IconImage(
                                    icon: item.converting, height: 20,
                                    color: .waterBlue)
                                Text("= \(item.text2)")
                                IconImage(
                                    icon: .waterDrop, height: 20,
                                    color: .waterBlue)
                            }
                            
                            actionButton(
                                text: item.buttonText,
                                isDisabled: item.isDisabled,
                                action: {
                                    item.onAction()
                                    showPopUp.wrappedValue = false
                                    print("\(item.currency) button tapped")
                                }
                            )
                        }
                    }
                }
            },
            width: 270,
            height: 320
        )
    }
    
    // MARK: plant image
    static func plantImage(image: String, applyEffects: Bool = false)
    -> some View
    {
        Image(image)
            .resizable()
            .aspectRatio(contentMode: .fit)
            .frame(width: 50, height: 75)
            .modifier(WiltFlowerEffect(applyEffects: applyEffects))
    }
    
    // MARK: action button
    static func actionButton(
        text: String,
        secondText: String? = nil,
        icon: Icon? = nil,
        isDisabled: Bool = false,
        action: @escaping () -> Void
    ) -> some View {
        Button(action: {
            if !isDisabled {
                action()
            }
        }) {
            HStack(spacing: 10) {
                secondText.map {
                    Text($0)
                        .font(.popupDetails)
                        .foregroundColor(.white)
                }
                icon.map {
                    IconImage(icon: $0, height: 20, color: .waterBlue)
                }
                Text(text)
                    .font(.popupDetails)
                    .foregroundColor(.white)
            }
            .padding(.vertical, 10)
            .padding(.horizontal, 25)
            .background(.customBrown)
            .clipShape(Capsule())
            .colorMultiply(
                isDisabled ? .disabledLightGrey.opacity(0.6) : .white
            )
            .customShadow()
        }
        .disabled(isDisabled)
    }
}

#Preview {
    ZStack {
        ScrollView(showsIndicators: false) {
            VStack(spacing: 20) {
                let myPlant1 = UserPlantModel(
                    basePlant: .peony,
                    currentStage: 3,
                    watersCollected: 24,
                    status: .growing
                )
                
                let myPlant2 = UserPlantModel(
                    basePlant: .lily,
                    currentStage: 4,
                    watersCollected: 24,
                    status: .completed
                )
                
                PopUp.plantInfo(
                    currentPlantModel: myPlant1, swappablePlantModel: myPlant2,
                    showPopUp: .constant(true),
                    onSwap: {_ in }
                )
                
                PopUp.plantInfo(
                    currentPlantModel: myPlant1, swappablePlantModel: myPlant1,
                    showPopUp: .constant(true),
                    onSwap: {_ in }
                )
                
                PopUp.addWaterPoints(
                    steps: 1000,
                    showPopUp: .constant(true),
                    currencyModels: [],
                    onConvert: { _, _ in },
                    onBuy: { _ in }
                )
                
                PopUp.purchase(
                    plantModel: BasePlantModel.delphinium,
                    showPopUp: .constant(true),
                    hasEnoughGems: true,
                    onPurchase: {_ in }
                )
                
                PopUp.purchase(
                    plantModel: BasePlantModel.delphinium,
                    showPopUp: .constant(true),
                    hasEnoughGems: false,
                    onPurchase: {_ in }
                )
                
                PopUp.locked(
                    plantModel: BasePlantModel.delphinium,
                    showPopUp: .constant(true)
                )
                
                PopUp.wilt(
                    plantModel: BasePlantModel.lavender,
                    showPopUp: .constant(true)
                )
                
                PopUp.levelUp(
                    currentPlant: myPlant1,
                    showPopUp: .constant(true),
                    onLevelUp: {}
                )
                
                PopUp.levelUp(
                    currentPlant: myPlant2,
                    showPopUp: .constant(true),
                    onLevelUp: {}
                )
                
                PopUp.swapPlant(
                    currentPlantModel: myPlant1, swappablePlantModel: myPlant2,
                    showPopUp: .constant(true))
            }
            .padding(.horizontal)
            .padding()
        }
    }
}
