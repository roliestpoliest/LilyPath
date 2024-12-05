//
//  PlantInfoView.swift
//  LilyPath
//
//  Created by Chelsea Nguyen on 12/5/24.
//

import SwiftUI

struct PlantInfoView: View {
    let currentPlant: UserPlantModel

    var body: some View {
        HStack {
            Image(currentPlant.currentImage)
                .resizable()
                .scaledToFit()
                .frame(width: 40)
                .padding(.leading, 10)

            VStack(alignment: .leading) {
                Text(currentPlant.basePlant.species)
                    .font(.currentPlant)

                Text("Stage \(currentPlant.currentStage)")
                    .font(.stageLabel)

                HStack {
                    let stepsInCurrentStage: Double = currentPlant.currentStage == 5
                        ? 1 // Mark as full steps for final stage 5
                        : Double(currentPlant.stepsInCurrentStage)

                    ProgressBar(
                        value: stepsInCurrentStage,
                        total: Double(currentPlant.currentStageGoal),
                        frameHeight: 16
                    )

                    let stageProgress = currentPlant.currentStage == 5
                        ? 100 // Mark as full progress for final stage 5
                        : (currentPlant.stageProgress * 100)

                    Text("\(Int(stageProgress))%")
                        .font(Font.label)
                        .frame(width: 35)
                }
            }
            .padding(.leading, 10)

            Spacer()
        }
    }
}
