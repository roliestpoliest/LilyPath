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
                    .shadow(
                        radius: ShadowConstants.radius,
                        y: ShadowConstants.yOffset
                    )

                Spacer()

                ScrollView {
                    VStack(spacing: 30) {
                        NavigationLink(
                            destination: PlantStatsDetailView(
                                title: "Plants Completed",
                                action: "Completed",
                                plants: completedPlants
                            )
                        ) {
                            PlantStatsCard(
                                stat: "Plants Completed",
                                value: completedPlants.count,
                                icon: .garden
                            )
                        }

                        NavigationLink(
                            destination: PlantStatsDetailView(
                                title: "Plants Watered",
                                action: "Last watered",
                                plants: wateredPlants
                            )
                        ) {
                            PlantStatsCard(
                                stat: "Plants Watered",
                                value: wateredPlants.count,
                                icon: .waterDrop
                            )
                        }

                        NavigationLink(
                            destination: PlantStatsDetailView(
                                title: "Seeds Planted",
                                action: "Planted",
                                plants: seedsPlanted
                            )
                        ) {
                            PlantStatsCard(
                                stat: "Seeds Planted",
                                value: seedsPlanted.count,
                                icon: .newPlant
                            )
                        }
                    }
                }
            }
            .background(Color.mainBackground)
        }
    }

    // MARK: - Filtered Plants
    private var completedPlants: [UserPlantModel] {
        fetchPlants(for: selectedTimePeriod).filter { $0.currentStage == 5 }
    }

    private var wateredPlants: [UserPlantModel] {
        fetchPlants(for: selectedTimePeriod).filter {
            $0.lastWateredDate != nil
        }
    }

    private var seedsPlanted: [UserPlantModel] {
        fetchPlants(for: selectedTimePeriod)
    }

    private func fetchPlants(for timePeriod: TimePeriod) -> [UserPlantModel] {
        let today = Date()
        let startDate: Date

        switch timePeriod {
        case .daily:
            startDate = today.startOfDay
        case .weekly:
            startDate = today.startOfWeek
        case .monthly:
            startDate = today.startOfMonth
        }

        return allUserPlants
            .filter {
                $0.plantDate >= startDate
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
