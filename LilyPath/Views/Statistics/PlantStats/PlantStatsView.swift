//
//  PlantStatsView.swift
//  LilyPath
//
//  Created by Chelsea Nguyen on 10/21/24.
//

import SwiftData
import SwiftUI

struct PlantStatsView: View {
    @Query var allUserPlants: [UserPlantModel]

    @Environment(\.modelContext) private var modelContext
    
    @State private var selectedTimePeriod: TimePeriod = .daily

    var body: some View {
        NavigationStack {
            VStack {
                ViewTitle(title: "Plant Stats")

                TimePeriodPicker(selectedTimePeriod: $selectedTimePeriod)
                    .padding(.bottom, 20)
                    .customShadow()

                Spacer()

                ScrollView {
                    VStack(spacing: 30) {
                        ForEach(plantStats, id: \.title) { stat in
                            NavigationLink(
                                destination: PlantStatsDetailView(
                                    title: stat.title,
                                    action: stat.action,
                                    plants: stat.plants
                                )
                            ) {
                                GenericStatsCard(
                                    title: stat.title,
                                    value: "\(stat.plants.count)",
                                    icon: stat.icon,
                                    showChevron: true
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

    // MARK: - Filtered Stats
    private var plantStats: [PlantStatsModel] {
        [
            PlantStatsModel(
                title: "Plants Completed",
                action: "Completed",
                icon: .garden,
                plants: filteredPlants { $0.currentStage == 5 }
            ),
            PlantStatsModel(
                title: "Plants Watered",
                action: "Last watered",
                icon: .waterDrop,
                plants: filteredPlants { $0.lastWateredDate != nil }
            ),
            PlantStatsModel(
                title: "Seeds Planted",
                action: "Planted",
                icon: .newPlant,
                plants: filteredPlants { _ in true }
            )
        ]
    }

    private func filteredPlants(_ predicate: (UserPlantModel) -> Bool) -> [UserPlantModel] {
        let today = Date()
        let startDate: Date

        switch selectedTimePeriod {
        case .daily:
            startDate = today.startOfDay
        case .weekly:
            startDate = today.startOfWeek
        case .monthly:
            startDate = today.startOfMonth
        }

        return allUserPlants
            .filter {
                $0.plantDate >= startDate && predicate($0)
            }
            .sorted {
                // Sort by most recent day, ignoring time
                if let firstDate = $0.lastWateredDate?.startOfDay, let secondDate = $1.lastWateredDate?.startOfDay {
                    if firstDate != secondDate {
                        return firstDate > secondDate
                    }
                }
                // Tiebreaker: sort alphabetically by species
                return $0.basePlant.species < $1.basePlant.species
            }
    }
}

// MARK: - Date Extensions
extension Date {
    var startOfDay: Date {
        Calendar.current.startOfDay(for: self)
    }

    var startOfWeek: Date {
        Calendar.current.date(
            from: Calendar.current.dateComponents(
                [.yearForWeekOfYear, .weekOfYear], from: self)) ?? self
    }

    var startOfMonth: Date {
        Calendar.current.date(
            from: Calendar.current.dateComponents([.year, .month], from: self))
            ?? self
    }
}

#Preview {
    PlantStatsView()
        .background(Color.mainBackground)
}
