//
//  StatisticsView.swift
//  LilyPath
//
//  Created by Carolyn Heron on 9/29/24.
//

import SwiftData
import SwiftUI

struct StatisticsView: View {
    @Environment(\.modelContext) private var modelContext
    @Query var plantsWithStage5: [UserPlantModel]
    @EnvironmentObject var healthManager: HealthManager

    @State private var countSteps: Double = 0.0

    var body: some View {
        NavigationStack {
            VStack {
                GardenNavigationLink(
                    title: "Plant Stats",
                    destination: PlantStatsView()
                )

                NavigationLink(destination: PlantStatsView()) {
                    PlantStatsCard(
                        stat: "Plants Completed",
                        value: plantsWithStage5.count,
                        icon: .garden,
                        showChevron: false
                    )
                }

                GardenNavigationLink(
                    title: "Fitness Stats",
                    destination: FitnessStatsView()
                )

                NavigationLink(
                    destination: FitnessStatsView().environmentObject(
                        healthManager)
                ) {
                    StatsCard(
                        stat: MetricStatsModel(
                            metricType: .steps,
                            value: formatNumberWithCommas(Int(countSteps))
                        ),
                        timePeriod: .daily,
                        showChevron: false
                    )
                }
                .onAppear {
                    Task {
                        await fetchDailySteps()
                    }
                }

                Spacer()
            }
            .background(Color.mainBackground)
        }
    }

    init() {
        // Query to fetch only plants where currentStage == 5
        _plantsWithStage5 = Query(filter: #Predicate { $0.currentStage == 5 })
    }

    private func fetchDailySteps() async {
        countSteps = await withCheckedContinuation { continuation in
            healthManager.fetchHourlySteps(for: Date.startOfDay) { dataPoints in
                let totalValue = dataPoints.reduce(0) { $0 + $1.value }
                DispatchQueue.main.async {
                    continuation.resume(returning: totalValue)
                }
            }
        }
    }
}
