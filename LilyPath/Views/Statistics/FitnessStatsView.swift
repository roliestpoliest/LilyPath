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
                        ForEach(statsManager.fitnessStats, id: \.id) { stat in
                            NavigationLink(
                                destination: FitnessStatsDetailView(
                                    stat: stat, timePeriod: selectedTimePeriod)
                            ) {
                                StatsCard(stat: stat, timePeriod: selectedTimePeriod)
                            }
                        }
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

// TODO: separate onto a different file & reformat
struct FitnessStatsDetailView: View {
    @ObservedObject var stat: FitnessStatsModel
    let timePeriod: TimePeriod
    
    var body: some View {
        VStack {
            // TODO: Add Swift Chart
            Image(systemName: "chart.bar")
                .resizable()
                .scaledToFit()
                .frame(height: 200)
                .padding()
            
            Text(stat.description(for: timePeriod))
                .font(.title2)
                .padding()
            
            Spacer()
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .navigationTitle(
            "\(timePeriod.rawValue.capitalized) \(stat.id.capitalized)"
        )
        .background(Color.mainBackground)
    }
}

#Preview {
    FitnessStatsView()
        .padding(.horizontal, 30)
        .background(Color.mainBackground)
}
