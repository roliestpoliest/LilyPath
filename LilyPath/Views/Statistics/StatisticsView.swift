//
//  StatisticsView.swift
//  LilyPath
//
//  Created by Carolyn Heron on 9/29/24.
//

import HealthKit
import SwiftUI

struct StatisticsView: View {
    @State private var selectedTimePeriod: TimePeriod = .daily
    @EnvironmentObject var healthManager: HealthManager

    var body: some View {
        NavigationStack {
            VStack {
                FitnessStatsView()
                    .environmentObject(healthManager)

            }
            .background(Color.mainBackground)
//            .task(id: selectedTimePeriod) {
//                statsManager.fetchAndUpdateStats()
//            }
        }
    }
}
