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
    let showChevron: Bool

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

            Text("\((stat.value)) \(stat.fluentDisplayName.lowercased())")
                .font(.statsCard)
                .foregroundColor(.white)

            Spacer()

            if showChevron {
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
