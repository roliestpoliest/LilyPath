//
//  PlantStatsCard.swift
//  LilyPath
//
//  Created by Carolyn Heron on 12/4/24.
//


import SwiftUI

struct PlantStatsCard: View {
    let stat: String
    let value: Int
    let timePeriod: TimePeriod?
    let icon: Icon
    let showChevron: Bool
    
    init(stat: String, value: Int, timePeriod: TimePeriod? = nil, icon: Icon, showChevron: Bool = true) {
        self.stat = stat
        self.value = value
        self.timePeriod = timePeriod
        self.icon = icon
        self.showChevron = showChevron
    }
    
    var body: some View {
        HStack {
            ZStack {
                IconImage(icon: icon, font: .statsIcon, color: .darkerBlue)
            }
            .frame(width: 55, height: 55)
            .background(Color.lightBlue)
            .cornerRadius(10)
            
            Text("\(value) \(stat.lowercased())")
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
