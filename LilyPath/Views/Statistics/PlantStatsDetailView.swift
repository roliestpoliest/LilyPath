//
//  PlantStatsDetailView.swift
//  LilyPath
//
//  Created by Chelsea Nguyen on 10/23/24.
//

import SwiftData
import SwiftUI

struct PlantStatsDetailView: View {
    let title: String
    let plants: [UserPlantModel]
    
    var body: some View {
        NavigationStack {
            VStack {
                ViewTitle(title: title) // Display the title of the stats category
                
                ScrollView {
                    if plants.isEmpty {
                        Text("No \(title.lowercased()) yet")
                            .foregroundColor(.gray)
                            .font(.customBody) // Use your custom font
                            .multilineTextAlignment(.center)
                            .padding()
                    } else {
                        VStack(spacing: 20) {
                            ForEach(plants, id: \.id) { plant in
                                PlantStatsCard(
                                    stat: plant.basePlant.species, // Use the plant's species as the stat
                                    value: plant.currentStage,    // Use the current stage as the value
                                    icon: plant.currentImage,      // Use the plant's current image
                                    showChevron: false
                                )
                            }
                        }
                        .padding(.horizontal, 16)
                    }
                }
            }
            .background(Color.mainBackground)
            .navigationTitle(title)
        }
    }
}
