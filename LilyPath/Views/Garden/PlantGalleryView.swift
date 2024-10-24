//
//  PlantGalleryView.swift
//  LilyPath
//
//  Created by Carolyn Heron on 10/6/24.
//

import SwiftUI

struct PlantGalleryView: View {
    @ObservedObject private var userPlantManager = UserPlantManager.shared
    private let columns: [GridItem] = Array(repeating: GridItem(.flexible(), spacing: 40), count: 2)

    var body: some View {
        VStack{
            ViewTitle(title: "Plant Gallery")
            
            ScrollView(showsIndicators: false) {
                LazyVGrid(columns: columns, spacing: 40) {
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
    PlantGalleryView()
        .padding(.horizontal, 30)
        .background(Color.mainBackground)

}
