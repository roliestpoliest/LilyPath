//
//  PlantShopView.swift
//  LilyPath
//
//  Created by Carolyn Heron on 10/2/24.
//

import SwiftUI

struct PlantShopView: View {
    let plants: [BasePlantModel]
    let columns = [
        GridItem(.flexible(), spacing: 40),
        GridItem(.flexible(), spacing: 40)
    ]
    
    var body: some View {
        VStack {
            ViewTitle(title: "Plant Shop")
            
            ScrollView(showsIndicators: false) {
                LazyVGrid(columns: columns, spacing: 40) {
                    ForEach(plants) { plant in
                        PlantShopCard(plantModel: plant)
                    }
                }
            }
            .shadow(radius: ShadowConstants.radius, y: ShadowConstants.yOffset)
        }
    }
}

#Preview {
    PlantShopView(plants: [
        BasePlantModel.lily,
        BasePlantModel.delphinium,
        BasePlantModel.buttercup,
        BasePlantModel.rose,
        BasePlantModel.chamomile,
        BasePlantModel.petunia,
        BasePlantModel.carnation,
        BasePlantModel.lotus
    ])
    .padding(.horizontal, 30)
    .background(Color.mainBackground)
}
