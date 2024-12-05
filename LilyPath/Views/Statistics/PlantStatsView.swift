//
//  PlantStatsView.swift
//  LilyPath
//
//  Created by Chelsea Nguyen on 10/21/24.
//

import SwiftData
import SwiftUI

struct PlantStatsView: View {
    @Environment(\.modelContext) private var modelContext
    @Query var allUserPlants: [UserPlantModel]
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
                                plants: completedPlants
                            )
                        ) {
                            PlantStatsCard(
                                stat: "Plants Completed",
                                value: completedPlants.count,
                                icon: "checkmark.circle.fill"  // Represents completion
                            )
                        }

                        NavigationLink(
                            destination: PlantStatsDetailView(
                                title: "Plants Watered",
                                plants: wateredPlants
                            )
                        ) {
                            PlantStatsCard(
                                stat: "Plants Watered",
                                value: wateredPlants.count,
                                icon: "drop.fill"  // Represents water
                            )
                        }

                        NavigationLink(
                            destination: PlantStatsDetailView(
                                title: "Seeds Planted",
                                plants: seedsPlanted
                            )
                        ) {
                            PlantStatsCard(
                                stat: "Seeds Planted",
                                value: seedsPlanted.count,
                                icon: "leaf.fill"  // Represents growth and planting
                            )
                        }
                    }
                }
            }
            .background(Color.mainBackground)
        }
    }

    init() {
        _allUserPlants = Query(filter: nil)
    }

    // MARK: - Filtered Plants
    private var completedPlants: [UserPlantModel] {
        fetchPlants(for: selectedTimePeriod).filter { $0.currentStage == 5 }
    }

    private var wateredPlants: [UserPlantModel] {
        fetchPlants(for: selectedTimePeriod).filter {
            $0.lastWateredDate != nil && $0.currentStage != 5
        }
    }

    private var seedsPlanted: [UserPlantModel] {
        fetchPlants(for: selectedTimePeriod).filter { $0.currentStage == 1 }
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

        return allUserPlants.filter {
            $0.plantDate >= startDate
        }
    }
}
// MARK: - Supporting Models and Extensions

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

// MARK: - Preview

#Preview {
    PlantStatsView()
        .background(Color.mainBackground)
}
