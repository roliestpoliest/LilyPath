//
//  PlantGalleryView.swift
//  LilyPath
//
//  Created by Carolyn Heron on 10/6/24.
//

import SwiftUI

struct PlantGalleryView: View {
    @ObservedObject private var userPlantManager = UserPlantManager.shared
    let columns = [
        GridItem(.flexible(), spacing: 40),
        GridItem(.flexible(), spacing: 40)
    ]

    var body: some View {
        VStack{
            ViewTitle(title: "Plant Gallery")
            
            ScrollView(showsIndicators: false) {
                LazyVGrid(columns: columns, spacing: 30) {
                    ForEach(userPlantManager.getUserPlantsSorted()) { plant in
                        PlantGalleryCard(userPlantModel: plant)
                    }
                }
            }
            .shadow(radius: ShadowConstants.radius, y: ShadowConstants.yOffset)
        }
        .background(Color.mainBackground)
    }
}

#Preview {
    PlantGalleryView(/*plantGallery: [
        UserPlantModel(basePlant: BasePlantModel.peony, currentStage: 1, stepsCollected: 50),
        UserPlantModel(basePlant: BasePlantModel.peony, currentStage: 2, stepsCollected: 200),
        UserPlantModel(basePlant: BasePlantModel.lily, currentStage: 2, stepsCollected: 200),
        UserPlantModel(basePlant: BasePlantModel.lotus, currentStage: 4, stepsCollected: 1220),
        UserPlantModel(basePlant: BasePlantModel.lavender, currentStage: 2, stepsCollected: 200)
    ]*/)
        .padding(.horizontal, 30)
        .background(Color.mainBackground)

}
