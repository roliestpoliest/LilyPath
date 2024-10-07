//
//  PlantGalleryCard.swift
//  LilyPath
//
//  Created by Carolyn Heron on 10/6/24.
//

import SwiftUI

struct PlantGalleryCard: View {
    var userPlantModel: UserPlantModel
    
    var body: some View {
        VStack {
            VStack {
                ZStack {
                    Rectangle()
                        .fill(Color.customBrown)
                        .cornerRadius(15)
                    
                    Spacer()
                    
                    VStack {
                        Spacer()
                        ZStack {
                            UnevenRoundedRectangle(topLeadingRadius: 8, bottomLeadingRadius: 0, bottomTrailingRadius: 0, topTrailingRadius: 8)
                                .fill(Color.lightBlue)
                                .frame(width: 125, height: 125)
                            Spacer()
                            Image(userPlantModel.currentImage)
                                .resizable()
                                .aspectRatio(contentMode: .fit)
                            // .scaleEffect(0.45)
                                .frame(width: 62, height: 62)
                        }
                        .padding(.top, 5)
                        
                        Spacer()
                        
                        VStack {
                            Text(userPlantModel.basePlant.species)
                            ProgressBar(value: Double(userPlantModel.stepsInCurrentStage), total: Double(userPlantModel.currentStageGoal))
                                .padding(.horizontal, 10)
                        }
                        .frame(maxWidth: .infinity, maxHeight: .infinity)
                        .font(Font.statsCard)
                        .foregroundStyle(.white)
                        .bold()
                        
                        Spacer()
                    }
                }
            }
            .frame(width: 150, height: 215)
        }
        .contentShape(Rectangle())
        .onTapGesture {
            print("Plant Gallery Card \(userPlantModel.basePlant.species) tapped")
        }
    }
}

#Preview {
    VStack{
        PlantGalleryCard(userPlantModel: UserPlantModel(basePlant: BasePlantModel.buttercup, currentStage: 3, stepsCollected: [100, 200, 100].reduce(0,+)))
        PlantGalleryCard(userPlantModel: UserPlantModel(basePlant: BasePlantModel.lavender, currentStage: 5, stepsCollected: [110, 210, 310, 410, 0].reduce(0,+)))
    }
    .frame(maxWidth: .infinity, maxHeight: .infinity)
    .padding(.horizontal, 30)
    .background(Color.mainBackground)
    
}
