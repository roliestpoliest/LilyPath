//
//  PlantShopView.swift
//  LilyPath
//
//  Created by Carolyn Heron on 10/2/24.
//

import SwiftUI

struct PlantShopView: View {
    let plants: [BasePlantModel]
    
    var body: some View {
        VStack {
            Text("Plant Shop")
                .font(Font.viewTitle)
                .foregroundStyle(Color.customBrown)
                .padding(.vertical)
                .frame(maxWidth: .infinity, alignment: .leading)
            
            ScrollView(showsIndicators: false) {
                LazyVStack(spacing: 40) {
                    ForEach(0..<(plants.count + 1) / 2, id: \.self) { index in
                        HStack(alignment: .center) {
                            let firstPlant = plants[index * 2]
                            PlantCard(PlantModel: firstPlant)
                            
                            Spacer()
                            
                            if index * 2 + 1 < plants.count {
                                let secondPlant = plants[index * 2 + 1]
                                PlantCard(PlantModel: secondPlant)
                            } else {
                                Spacer()
                                    .frame(width: 150)
                            }
                        }
                    }
                }
            }
            .onAppear {
                UIScrollView.appearance().bounces = false
            }
            .onDisappear {
                UIScrollView.appearance().bounces = true
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
