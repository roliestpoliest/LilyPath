//
//  PlantStatsDetailView.swift
//  LilyPath
//
//  Created by Chelsea Nguyen on 10/23/24.
//

import SwiftUI

struct PlantStatsDetailView: View {
    @ObservedObject var stat: PlantStatsModel
    let timePeriod: TimePeriod
    @ObservedObject private var plantManager = UserPlantManager.shared
    
    var body: some View {
        VStack {
            ViewTitle(
                title:
                    "\(stat.plant.capitalized)s \(stat.action.capitalized): \(stat.count)"
            )
            
            ScrollView {
                VStack(spacing: 20) {
                    let filtered = plantManager.filteredPlants(
                        for: stat.id, within: timePeriod)
                    
                    if filtered.isEmpty {
                        Text("No \(stat.plant)s \(stat.action) yet")
                            .font(.headline)
                            .italic()
                            .foregroundColor(.gray)
                    } else {
                        ForEach(filtered, id: \.id) { plant in
                            PlantRowView(plant: plant, action: stat.action)
                        }
                        .shadow(
                            radius: ShadowConstants.radius,
                            y: ShadowConstants.yOffset)
                    }
                }
            }
            
            Spacer()
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .navigationTitle("\(timePeriod.rawValue.capitalized)")
        .background(Color.mainBackground)
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

#Preview {
    PlantStatsDetailView(
        stat: PlantStatsModel.seedsPlanted,
        timePeriod: .daily
    )
    .background(Color.mainBackground)
    .padding(.horizontal, 30)
}
