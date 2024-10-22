//
//  FitnessStatsView.swift
//  LilyPath
//
//  Created by Chelsea Nguyen on 10/21/24.
//

import SwiftUI

struct FitnessStatsView: View {
    @State private var selectedTab: TimePeriod = .daily
    @ObservedObject private var statsManager = FitnessStatsManager.shared

    var body: some View {
        NavigationStack {
            VStack {
                ViewTitle(title: "Fitness Stats")

                TimePeriodPicker(selectedTimePeriod: $selectedTab)
                    .padding(.bottom, 20)
                    .shadow(radius: ShadowConstants.radius, y: ShadowConstants.yOffset)

                ScrollView {
                    VStack(spacing: 30) {
                        ForEach(statsManager.fitnessStats, id: \.id) { stat in
                            NavigationLink(
                                destination: FitnessStatsDetailView(stat: stat, timePeriod: selectedTab)
                            ) {
                                FitnessStatsCard(stat: stat, timePeriod: selectedTab)
                            }
                        }
                    }
                }
                .shadow(radius: ShadowConstants.radius, y: ShadowConstants.yOffset)

                Spacer()
            }
            .background(Color.mainBackground)
        }
    }
}

struct FitnessStatsCard: View {
    @ObservedObject var stat: FitnessStatsModel
    let timePeriod: TimePeriod

    var body: some View {
        HStack {
            ZStack {
                IconImage(icon: stat.icon, font: .statsIcon, color: .darkerBlue)
            }
            .frame(width: 55, height: 55)
            .background(Color.lightBlue)
            .cornerRadius(10)

            Text(stat.description(for: timePeriod))
                .font(.statsCard)
                .foregroundColor(.white)
                .padding(.leading, 8)

            Spacer()

            Image(systemName: "chevron.right")
                .font(.statsCard)
                .foregroundColor(.white)
        }
        .padding(12)
        .frame(maxWidth: .infinity, maxHeight: 80)
        .background(Color.customBrown)
        .cornerRadius(20)
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
        .navigationTitle("\(timePeriod.rawValue.capitalized) \(stat.id.capitalized)")
        .background(Color.mainBackground)
    }
}

#Preview {
    FitnessStatsView()
        .padding(.horizontal, 30)
        .background(Color.mainBackground)
}
