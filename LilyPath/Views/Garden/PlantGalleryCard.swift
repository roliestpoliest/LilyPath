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
                            UnevenRoundedRectangle(
                                topLeadingRadius: 8, bottomLeadingRadius: 0,
                                bottomTrailingRadius: 0, topTrailingRadius: 8
                            )
                            .fill(Color.lightBlue)
                            .frame(width: 125, height: 125)
                            Spacer()
                            Image(userPlantModel.currentImage)
                                .resizable()
                                .aspectRatio(contentMode: .fit)
                                .frame(width: 45, height: 65)
                            
                        }
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
                                
                                ProgressBar(
                                    value: Double(
                                        userPlantModel.stepsInCurrentStage),
                                    total: Double(
                                        userPlantModel.currentStageGoal))
                            }
                            .padding(.horizontal, 10)
                        }
                        .font(Font.statsCard)
                        .foregroundStyle(.white)
                        .bold()
                        
                        Spacer()
                    }
                }
                .frame(width: 150, height: 210)
            }
        }
        .contentShape(Rectangle())
        .onTapGesture {
            print(
                "Plant Gallery Card \(userPlantModel.basePlant.species) tapped")
        }
    }
}

#Preview {
    VStack {
        ForEach(UserPlantManager.shared.userPlants) {
            userPlant in
            PlantGalleryCard(userPlantModel: userPlant)
        }
    }
    .frame(maxWidth: .infinity, maxHeight: .infinity)
    .padding(.horizontal, 30)
    .background(Color.mainBackground)
    
}
