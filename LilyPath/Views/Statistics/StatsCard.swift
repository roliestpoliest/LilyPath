//
//  StatsCard.swift
//  LilyPath
//
//  Created by Chelsea Nguyen on 10/23/24.
//

import SwiftUI

struct StatsCard: View {
    let stat: MetricStatsModel
    let timePeriod: TimePeriod
    let showChevron: Bool  // Determines if the chevron is visible

    init(
        stat: MetricStatsModel, timePeriod: TimePeriod, showChevron: Bool = true
    ) {
        self.stat = stat
        self.timePeriod = timePeriod
        self.showChevron = showChevron
    }

    var body: some View {
        HStack {
            ZStack {
                IconImage(icon: stat.icon, font: .statsIcon, color: .darkerBlue)
            }
            .frame(width: 55, height: 55)
            .background(Color.lightBlue)
            .cornerRadius(10)

            Text("\(stat.value) \(stat.fluentDisplayName)")
                .font(.statsCard)
                .foregroundColor(.white)

            Spacer()

            if showChevron {  // Conditionally show the chevron
                Image(systemName: "chevron.right")
                    .font(.statsCard)
                    .foregroundColor(.white)
            }
        }
        .padding(12)
        .frame(maxWidth: .infinity, maxHeight: 80)
        .background(Color.customBrown)
        .cornerRadius(20)
    }
}

struct MetricStatsModel {
    var metricType: MetricType
    var value: String

    var icon: Icon {
        switch metricType {
        case .steps: return .steps
        case .calories: return .calories
        case .flightsClimbed: return .climbed
        case .sleep: return .slept
        case .walkingRunningDistance: return .distance
        }
    }

    var displayName: String {
        return metricType.displayName
    }

    var fluentDisplayName: String {
        return metricType.fluentDisplayName
    }
}
