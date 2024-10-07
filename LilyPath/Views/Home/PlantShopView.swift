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
        GridItem(.flexible(), spacing: 50),
        GridItem(.flexible(), spacing: 50)
    ]
    
    var body: some View {
        VStack {
            ViewTitle(title: "Plant Shop")
            
            ScrollView(showsIndicators: false) {
                LazyVGrid(columns: columns, spacing: 40) {
                    ForEach(plants) { plant in
                        PlantCard(plantModel: plant)
                    }
                }
                .padding(.horizontal)
            }
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
