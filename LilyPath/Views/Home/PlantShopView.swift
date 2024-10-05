//
//  PlantShopView.swift
//  LilyPath
//
//  Created by Carolyn Heron on 10/2/24.
//

import SwiftUI

struct PlantShopView: View {
    let plants: [(name: String, image: String, locked: Bool)]

    var body: some View {
        VStack {
            Text("Plant Shop")
                .font(Font.viewTitle)
                .foregroundStyle(Color.customBrown)
                .padding(.vertical)
                .frame(maxWidth: .infinity, alignment: .leading)
            
            ScrollView (showsIndicators: false){
                VStack(spacing: 40) {
                    ForEach(0..<plants.count / 2, id: \.self) { index in
                        HStack(alignment: .center) {
                            PlantCard(plantName: plants[index * 2].name, plantImage: plants[index * 2].image, locked: plants[index * 2].locked)
                            
                            Spacer()
                            
                            PlantCard(plantName: plants[index * 2 + 1].name, plantImage: plants[index * 2 + 1].image, locked: plants[index * 2 + 1].locked)
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
        (name: "Delphinium", image: "Delphinium Stage 5", locked: false),
        (name: "Buttercup", image: "Buttercup Stage 5", locked: false),
        (name: "Rose", image: "Rose Stage 5", locked: false),
        (name: "Chamomile", image: "Chamomile Stage 5", locked: true),
        (name: "Petunia", image: "Petunia Stage 5", locked: true),
        (name: "Petunia", image: "Petunia Stage 5", locked: true),
        (name: "Petunia", image: "Petunia Stage 5", locked: true),
        (name: "Carnation", image: "Carnation Stage 5", locked: true)
    ])
    .padding(.horizontal, 30)
    .background(Color.mainBackground)
}
