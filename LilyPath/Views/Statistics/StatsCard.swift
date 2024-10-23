//
//  StatsCard.swift
//  LilyPath
//
//  Created by Chelsea Nguyen on 10/23/24.
//

import SwiftUI

struct StatsCard<Stat: StatsProtocol>: View {
    @ObservedObject var stat: Stat
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

protocol StatsProtocol: ObservableObject, Identifiable {
    var icon: Icon { get }
    func description(for timePeriod: TimePeriod) -> String
}

extension PlantStatsModel: StatsProtocol {}
extension FitnessStatsModel: StatsProtocol {}
