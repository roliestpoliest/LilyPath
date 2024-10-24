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
        GridItem(.flexible(), spacing: 40),
    ]
    
    var body: some View {
        VStack {
            UserCurrencyBar()

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
        .background(Color.mainBackground)
    }
}

#Preview {
    PlantShopView(plants: BasePlantModel.allPlants)
        .padding(.horizontal, 30)
}
