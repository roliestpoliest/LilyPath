//
//  PlantGalleryView.swift
//  LilyPath
//
//  Created by Carolyn Heron on 10/6/24.
//

import SwiftUI

struct PlantGalleryView: View {
    var plantGallery: [UserPlantModel]
    let columns = [
        GridItem(.flexible(), spacing: 50),
        GridItem(.flexible(), spacing: 50)
    ]

    var body: some View {
        VStack{
            ViewTitle(title: "Plant Gallery")
            
            ScrollView(showsIndicators: false) {
                LazyVGrid(columns: columns, spacing: 30) {
                    ForEach(plantGallery) { plant in
                        PlantGalleryCard(userPlantModel: plant)
                    }
                }
            }
        }
    }
}

#Preview {
    PlantGalleryView(plantGallery: [
        UserPlantModel(basePlant: BasePlantModel.peony, currentStage: 1, stepsCollected: 50),
        UserPlantModel(basePlant: BasePlantModel.peony, currentStage: 2, stepsCollected: 200),
        UserPlantModel(basePlant: BasePlantModel.lily, currentStage: 2, stepsCollected: 200),
        UserPlantModel(basePlant: BasePlantModel.lotus, currentStage: 4, stepsCollected: 1220),
        UserPlantModel(basePlant: BasePlantModel.lavender, currentStage: 2, stepsCollected: 200)
    ])
        .padding(.horizontal, 30)
        .background(Color.mainBackground)

}
