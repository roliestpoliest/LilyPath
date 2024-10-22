//
//  StatisticsView.swift
//  LilyPath
//
//  Created by Carolyn Heron on 9/29/24.
//

import SwiftUI

struct StatisticsView: View {
    @EnvironmentObject var healthManager: HealthManager
    
    var body: some View {
        VStack {
            ViewTitle(title: "Statistics")
            
            ScrollView {
                LazyVGrid(columns: Array(repeating: GridItem(spacing: 20), count: 2)) {
                    ForEach(healthManager.activities.sorted(by: { $0.value.id < $1.value.id }), id: \.key) { _, activity in
                        ActivityCard(activity: activity)
                    }
                }
                .padding(.horizontal)
            }

        }
        .onAppear {
            Task {
                // Call each metric data fetch asynchronously
                await healthManager.fetchMetricData(for: .steps, timeFrame: .daily)
                await healthManager.fetchMetricData(for: .calories, timeFrame: .weekly)
                await healthManager.fetchMetricData(for: .flightsClimbed, timeFrame: .monthly)
            }
        }
    }
}

// Fetching Daily Data
//            healthManager.fetchMetricData(for: .steps, timeFrame: .daily)
//            healthManager.fetchMetricData(for: .calories, timeFrame: .daily)
//            healthManager.fetchMetricData(for: .flightsClimbed, timeFrame: .daily)
//            healthManager.fetchMetricData(for: .sleep, timeFrame: .daily)
//            healthManager.fetchMetricData(for: .walkingRunningDistance, timeFrame: .daily)

// Fetching Weekly Data:
//            healthManager.fetchMetricData(for: .steps, timeFrame: .weekly)
//            healthManager.fetchMetricData(for: .calories, timeFrame: .weekly)
//            healthManager.fetchMetricData(for: .flightsClimbed, timeFrame: .weekly)
//            healthManager.fetchMetricData(for: .sleep, timeFrame: .weekly)
//            healthManager.fetchMetricData(for: .walkingRunningDistance, timeFrame: .weekly)
//
//            // Fetching Monthly Data:
//            healthManager.fetchMetricData(for: .steps, timeFrame: .monthly)
//            healthManager.fetchMetricData(for: .calories, timeFrame: .monthly)
//            healthManager.fetchMetricData(for: .flightsClimbed, timeFrame: .monthly)
//            healthManager.fetchMetricData(for: .sleep, timeFrame: .monthly)
//            healthManager.fetchMetricData(for: .walkingRunningDistance, timeFrame: .monthly)
