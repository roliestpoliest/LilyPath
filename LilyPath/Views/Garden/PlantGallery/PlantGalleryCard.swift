//
//  PlantGalleryCard.swift
//  LilyPath
//
//  Created by Carolyn Heron on 10/6/24.
//

import SwiftUI

struct PlantGalleryCard: View {
    @Bindable var userPlantModel: UserPlantModel
    
    var body: some View {
        VStack {
            VStack {
                ZStack {
                    Rectangle()
                        .fill(Color.customBrown)
                    
                    Spacer()
                    
                    VStack {
                        Spacer()
                        
                        ZStack {
                            UnevenRoundedRectangle(
                                topLeadingRadius: 8, bottomLeadingRadius: 0,
                                bottomTrailingRadius: 0, topTrailingRadius: 8
                            )
                            .fill(Color.lightBlue)
                            
                            Spacer()
                            
                            Image(userPlantModel.currentImage)
                                .resizable()
                                .aspectRatio(contentMode: .fit)
                                .frame(width: 45, height: 65)
                            
//                            if userPlantModel.isCurrent {
//                                Image(systemName: "righttriangle.fill")
//                                    .foregroundColor(.darkGreen)
//                                    .font(Font.statsCard)
//                                    .rotationEffect(.degrees(180))
//                                    .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .topLeading)
//                                    .offset(x: 8, y: 8)
//                            }
                        }
                        .frame(width: 125, height: 125)
                        .padding(.top, 5)
                        
                        Spacer()
                        
                        VStack(spacing: 5) {
                            Text(userPlantModel.basePlant.species)
                            
                            HStack(spacing: 5) {
                                Image(
                                    systemName:
                                        "\(userPlantModel.currentStage).circle.fill"
                                )
                                .foregroundColor(.lightGreen)
                                
                                let stageProgress: Double = userPlantModel.currentStage == 5
                                    ? 1 // Mark as full progress for final stage 5
                                    : Double(userPlantModel.stepsInCurrentStage)
                                
                                ProgressBar(
                                    value: stageProgress,
                                    total: Double(userPlantModel.currentStageGoal)
                                )
                            }
                            .padding(.horizontal, 10)
                        }
                        .font(Font.statsCard)
                        .foregroundStyle(.white)
                        .bold()
                        
                        Spacer()
                    }
                    if userPlantModel.isCurrent {
                        Image(systemName: "righttriangle.fill")
                            .foregroundColor(.darkGreen)
                            .font(.system(size: 50))
                            .rotationEffect(.degrees(178))
                            .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .topLeading)
                            .offset(x: -10, y: -5)
                    }
                }
                .frame(width: 150, height: 210)
            }
        }
        .clipShape(RoundedRectangle(cornerRadius: 15))
    }
}

#Preview {
    let plant1 = UserPlantModel(
        basePlant: BasePlantModel.lily,
        currentStage: 1,
        watersCollected: 1000,
        isCurrent: false
    )
    
    let plant2 = UserPlantModel(
        basePlant: BasePlantModel.lily,
        currentStage: 1,
        isCurrent: true
    )
    
    PlantGalleryCard(userPlantModel: plant1)
    PlantGalleryCard(userPlantModel: plant2)
}
