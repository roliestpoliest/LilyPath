//
//  FitnessStatsView.swift
//  LilyPath
//
//  Created by Chelsea Nguyen on 10/21/24.
//

import SwiftUI

struct FitnessStatsView: View {
    @State private var selectedTimePeriod: TimePeriod = .daily
    @ObservedObject private var statsManager = FitnessStatsManager.shared
    
    var body: some View {
        NavigationStack {
            VStack {
                ViewTitle(title: "Fitness Stats")
                
                TimePeriodPicker(selectedTimePeriod: $selectedTimePeriod)
                    .padding(.bottom, 20)
                    .shadow(
                        radius: ShadowConstants.radius,
                        y: ShadowConstants.yOffset)
                
                ScrollView {
                    VStack(spacing: 30) {
                        Text("foo")
//                        ForEach(statsManager.fitnessStats, id: \.id) { stat in
//                            NavigationLink(
//                                destination: FitnessStatsDetailView(
//                                    stat: stat, timePeriod: selectedTimePeriod)
//                            ) {
                                StatsCard(stat: stat, timePeriod: selectedTimePeriod)
//                            }
//                        }
                    }
                }
                .shadow(
                    radius: ShadowConstants.radius, y: ShadowConstants.yOffset)
                
                Spacer()
            }
            .background(Color.mainBackground)
            .task(id: selectedTimePeriod) {
                statsManager.fetchAndUpdateStats()
            }
        }
    }
}

#Preview {
    FitnessStatsView()
        .padding(.horizontal, 30)
        .background(Color.mainBackground)
}
