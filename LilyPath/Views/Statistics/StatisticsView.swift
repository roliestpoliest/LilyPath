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
                SubViewNavigationLink(
                    title: "Plant Stats",
                    destination: PlantStatsView()
                ) {
                    StatisticsCard(
                        title: "Completed Since Start",
                        value: String(plantsWithStage5.count),
                        icon: .garden
                    )
                }
                .padding(.bottom, 15)

                SubViewNavigationLink(
                    title: "Fitness Stats",
                    destination: FitnessStatsView(),
                    onAppearAction: {
                        Task {
                            await fetchDailySteps()
                        }
                    }
                ) {
                    StatisticsCard(
                        title: "Steps Today",
                        value: formatNumberWithCommas(Int(countSteps)),
                        icon: .steps
                    )
                }

                Spacer()
            }
            .background(Color.mainBackground)
        }
    }

    init() {
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

#Preview {
    StatisticsView()
        .environmentObject(HealthManager())
        .padding(20)
}
