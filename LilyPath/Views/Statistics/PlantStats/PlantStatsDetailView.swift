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
    let action: String
    let plants: [UserPlantModel]
    
    var body: some View {
        NavigationStack {
            VStack {
                ViewTitle(title: title)
                
                ScrollView {
                    if plants.isEmpty {
                        Text("No \(title.lowercased()) yet")
                            .foregroundColor(.gray)
                            .font(.customBody)
                            .multilineTextAlignment(.center)
                            .padding()
                    } else {
                        VStack(spacing: 20) {
                            ForEach(plants, id: \.id) { plant in
                                PlantRowView(
                                    plant: plant,
                                    action: action
                                )
                                .darkCustomShadow()
                            }
                        }
                    }
                }
            }
            .background(Color.mainBackground)
        }
    }
}

struct PlantRowView: View {
    let plant: UserPlantModel
    let action: String
    
    var body: some View {
        HStack {
            ZStack {
                Image(plant.currentImage)
                    .resizable()
                    .scaledToFit()
                    .frame(width: 40, height: 40)
            }
            .frame(width: 55, height: 55)
            .background(Color.lightBlue)
            .cornerRadius(10)
            
            VStack(alignment: .leading) {
                Text(plant.basePlant.species)
                    .font(.statsCard)
                    .foregroundColor(.white)
                
                Text(statDateText())
                    .font(.subheadline)
                    .foregroundColor(.gray)
            }
            .padding(.leading, 8)
            
            Spacer()
        }
        .padding(12)
        .frame(maxWidth: .infinity)
        .background(Color.customBrown)
        .cornerRadius(20)
    }
    
    private func statDateText() -> String {
        let date: Date?
        
        switch action {
        case "completed":
            date = plant.completionDate
        case "watered":
            date = plant.lastWateredDate
        default:
            date = plant.plantDate
        }
        
        return date.map { "\(action.capitalized) on \(formattedDate($0))" }
        ?? ""
    }
    
    private func formattedDate(_ date: Date) -> String {
        let formatter = DateFormatter()
        formatter.dateStyle = .medium
        return formatter.string(from: date)
    }
}
