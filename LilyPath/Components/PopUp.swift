//
//  PlantPopUp.swift
//  LilyPath
//
//  Created by Carolyn Heron on 10/5/24.
//

import SwiftUI

// TODO: disable view behind the pop
// TODO: blur/darken background
// TODO: add popup functionality

// MARK: Generic view
struct GenericPopUpView<Content: View>: View {
    @State private var showPopUp = true
    var headerColor: Color = .customPink
    var textColor: Color = .customBrown
    var x_color: Color = .darkPink
    var headerText: String
    var content: () -> Content
    var width: CGFloat = 275
    var height: CGFloat = 200

    var body: some View {
        ZStack {
            VStack {
                header(text: headerText, headerColor: headerColor, textColor: textColor, x_color: x_color)
                Spacer()
                content()
                Spacer()
            }
            .frame(width: width, height: height)
            .padding()
            .background(Color.mainBackground)
            .cornerRadius(25)
            .overlay(
                RoundedRectangle(cornerRadius: 25)
                    .stroke(Color.customBrown, lineWidth: 5)
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
            .shadow(color: .black.opacity(0.5), radius: 3, x: 0, y: 3)
            .frame(height: 50)

            ZStack {
                Text(text.uppercased())
                    .font(Font.popupTitle)
                    .foregroundColor(textColor)

                HStack {
                    Spacer()
                    Button(action: {
                        print("Close button tapped")
                        showPopUp.toggle()
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
    static func purchase(plantModel: BasePlantModel) -> some View {
        GenericPopUpView(
            headerText: "Purchase",
            content: {
                HStack(spacing: 30) {
                    plantImage(image: plantModel.stageImages[4])

                    VStack(spacing: 15) {
                        Text(plantModel.species)
                            .font(Font.popupBody)
                            .foregroundColor(.customBrown)

                        actionButton(text: String(plantModel.price), icon: .gem)
                        {
                            print("Purchase button tapped")
                        }
                    }
                }
            }
        )
    }
    // MARK: locked
    static func locked(plantModel: BasePlantModel) -> some View {
        GenericPopUpView(
            headerText: "Womp Womp",
            content: {
                HStack(spacing: 20) {
                    plantImage(image: plantModel.stageImages[4])

                    VStack(alignment: .center, spacing: 15) {
                        Text(
                            "\(plantModel.species) is locked!\nUnlock at level \(plantModel.requiredLevelToBuy)"
                        )
                        .multilineTextAlignment(.center)
                        .font(Font.popupBody)
                        .foregroundColor(.customBrown)
                    }
                }
            }
        )
    }

    // MARK: wilt
    static func wilt(plantModel: BasePlantModel) -> some View {
        GenericPopUpView(
            headerText: "Uh oh!",
            content: {
                HStack(spacing: 10) {
                    plantImage(
                        image: plantModel.stageImages[4], applyEffects: true)

                    VStack(spacing: 15) {
                        Text("Your \(plantModel.species) is wilting!")
                            .multilineTextAlignment(.center)
                            .font(Font.popupBody)
                            .foregroundColor(.customBrown)

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
    static func levelUp(plantModel: BasePlantModel) -> some View {
        GenericPopUpView(
            headerText: "Level Up!",
            content: {
                HStack(spacing: 10) {
                    plantImage(image: plantModel.stageImages[4])

                    VStack(spacing: 15) {
                        Text("Your \(plantModel.species) is growing!")
                            .multilineTextAlignment(.center)
                            .font(Font.popupBody)
                            .foregroundColor(.customBrown)

                        actionButton(text: "+1", icon: .gem) {
                            print("Level Up button tapped")
                        }
                    }
                    .frame(width: 175)
                }
            }
        )
    }

    // MARK: stats
    static func plantStats(
        currentPlantModel: UserPlantModel, swapabblePlantModel: UserPlantModel
    ) -> some View {
        let showSwapButton = currentPlantModel.id != swapabblePlantModel.id
        let additionalHeight: CGFloat = showSwapButton ? 20 : 0

        return GenericPopUpView(
            headerText: currentPlantModel.basePlant.species,
            content: {
                VStack {
                    Grid {
                        let width: CGFloat = 135
                        GridRow {
                            Text("Plant Date")
                                .frame(width: width, alignment: .leading)
                                .font(.statsBodyBold)

                            Text(
                                currentPlantModel.plantDate.formatted(
                                    .dateTime.month(.abbreviated).day(
                                        .twoDigits
                                    )
                                    .year())
                            )
                            .frame(maxWidth: .infinity, alignment: .leading)
                            .font(.statsBody)

                        }
                        GridRow {
                            Text("Completion Date")
                                .frame(width: width, alignment: .leading)
                                .font(.statsBodyBold)

                            Text(
                                currentPlantModel.completionDate.map {
                                    $0.formatted(
                                        .dateTime.month(.abbreviated).day(
                                            .twoDigits
                                        ).year())
                                } ?? "N/A"
                            )
                            .frame(maxWidth: .infinity, alignment: .leading)
                            .font(.statsBody)

                        }
                        GridRow {
                            Text("Species")
                                .frame(width: width, alignment: .leading)
                                .font(.statsBodyBold)
                            Text(currentPlantModel.basePlant.species)
                                .frame(maxWidth: .infinity, alignment: .leading)
                                .font(.statsBody)

                        }
                        GridRow {
                            Text("Overall Progress")
                                .frame(width: width, alignment: .leading)
                                .font(.statsBodyBold)

                            Text(
                                "\(Int((currentPlantModel.overallProgress) * 100))%"
                            )
                            .frame(maxWidth: .infinity, alignment: .leading)
                            .font(.statsBody)

                        }
                        GridRow {
                            Text("Steps Left")
                                .frame(width: width, alignment: .leading)
                                .font(.statsBodyBold)
                            Text(
                                "\(currentPlantModel.basePlant.stepGoal - currentPlantModel.stepsCollected)"
                            )
                            .frame(maxWidth: .infinity, alignment: .leading)
                            .font(.statsBody)
                        }
                    }

                    HStack {
                        Text("Stage \(currentPlantModel.currentStage)")
                            .font(.stageLable)
                            .layoutPriority(1)

                        ProgressBar(
                            value: Double(
                                currentPlantModel.stepsInCurrentStage),
                            total: Double(currentPlantModel.currentStageGoal),
                            foregroundColor: .darkerBlue,
                            backgroundColor: .waterBlue
                        )
                        .frame(maxWidth: .infinity)

                        if showSwapButton {
                            actionButton(text: "Swap") {
                                print("Swap button tapped")
                            }
                            .layoutPriority(2)
                        }
                    }
                }
                .padding()
                .foregroundColor(.customBrown)
            },
            width: 300, height: 215 + additionalHeight
        )
    }

    // MARK: swap
    static func swapPlant(
        currentPlantModel: UserPlantModel, swapabblePlantModel: UserPlantModel
    ) -> some View {
        GenericPopUpView(
            headerText: "Swap Plant",
            content: {
                HStack {
                    plantImage(image: swapabblePlantModel.currentImage)
                    VStack(spacing: 15) {
                        Text(
                            "Switch from \(currentPlantModel.basePlant.species) to \(swapabblePlantModel.basePlant.species)?"
                        )
                        .multilineTextAlignment(.center)
                        .font(Font.popupBody)
                        .foregroundColor(.customBrown)

                        actionButton(text: "Yes") {
                            print("Swap button tapped")
                        }
                    }
                    .frame(width: 175)
                }
            }
        )
    }
        
    // MARK: plant image
    private static func plantImage(image: String, applyEffects: Bool = false)
        -> some View
    {
        Image(image)
            .resizable()
            .aspectRatio(contentMode: .fit)
            .frame(width: 50, height: 75)
            .modifier(WiltFlowerEffect(applyEffects: applyEffects))
    }

    // MARK: action button
    private static func actionButton(
        text: String, secondText: String? = nil, icon: Icon? = nil,
        action: @escaping () -> Void
    ) -> some View {
        Button(action: action) {
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
            .background(Color.customBrown)
        }
        .clipShape(Capsule())
        .shadow(color: .black.opacity(0.5), radius: 3, x: 0, y: 3)
        .buttonStyle(PlainButtonStyle())
    }
}

#Preview {
    ZStack {
        ScrollView(showsIndicators: false) {
            VStack {
                let myPlant1 = UserPlantModel(
                    basePlant: .peony, currentStage: 4, stepsCollected: 1000
                )
                let myPlant2 = UserPlantModel(
                    basePlant: .lily, currentStage: 4, stepsCollected: 1000
                )

//                PopUp.purchase(plantModel: BasePlantModel.delphinium)
//                    .frame(height: 250)
//                PopUp.locked(plantModel: BasePlantModel.delphinium)
//                    .frame(height: 250)
//                PopUp.wilt(plantModel: BasePlantModel.lavender)
//                    .frame(height: 250)
//                PopUp.levelUp(plantModel: BasePlantModel.delphinium)
//                    .frame(height: 250)
//                PopUp.plantStats(
//                    currentPlantModel: myPlant1, swapabblePlantModel: myPlant2)
//                PopUp.plantStats(
//                    currentPlantModel: myPlant1, swapabblePlantModel: myPlant1
//                )
//                .frame(height: 275)
//                PopUp.swapPlant(
//                    currentPlantModel: myPlant1, swapabblePlantModel: myPlant2)
//                PopUp.fitnessStats(metricType: .steps, chartPeriod: .day)
//                GenericPopUpView./*fitnessStats(metricType: .steps, chartPeriod: .day)*/
            }
            .padding(.horizontal)
            .padding()
        }
    }
}
