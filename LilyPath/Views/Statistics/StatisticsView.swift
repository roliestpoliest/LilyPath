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

            TempStatsView()
                .environmentObject(healthManager)
        }
    }
}

#Preview {
    StatisticsView()
}
