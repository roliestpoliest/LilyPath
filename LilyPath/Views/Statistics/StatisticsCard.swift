//
//  StatsCard.swift
//  LilyPath
//
//  Created by Chelsea Nguyen on 12/5/24.
//

import SwiftUI

struct StatisticsCard: View {
    let title: String
    let value: String
    let icon: Icon
    let showChevron: Bool = false
    
    init(
        title: String,
        value: String,
        icon: Icon
    ) {
        self.title = title
        self.value = value
        self.icon = icon
    }
    
    var body: some View {
        GenericStatsCard(title: title, value: value, icon: icon, showChevron: showChevron)
        .fontWeight(.bold)
        .padding(10)
        .padding(.leading, 5)
        .frame(maxWidth: .infinity, minHeight: 110)
        .background(
            RoundedRectangle(cornerRadius: 20)
                .fill(Color.customBrown)
                .overlay(
                    RoundedRectangle(cornerRadius: 20)
                        .inset(by: 3)
                        .stroke(Color.darkerBlue, lineWidth: 6)
                )
        )
    }
}

#Preview {
    StatisticsCard(title: "Plants", value: "5", icon: .newPlant)
        .padding(20)
        .background(Color.mainBackground)
}
