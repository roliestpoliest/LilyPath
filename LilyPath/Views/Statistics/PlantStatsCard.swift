//
//  StatsCard 2.swift
//  LilyPath
//
//  Created by Carolyn Heron on 12/4/24.
//


import SwiftUI

struct PlantStatsCard: View {
    let stat: String
    let value: Int
    let timePeriod: TimePeriod?
    let icon: String
    let showChevron: Bool
    
    init(stat: String, value: Int, timePeriod: TimePeriod? = nil, icon: String = "leaf", showChevron: Bool = true) {
        self.stat = stat
        self.value = value
        self.timePeriod = timePeriod
        self.icon = icon
        self.showChevron = showChevron
    }
    
    var body: some View {
        HStack {
            ZStack {
                if UIImage(systemName: icon) != nil { // Check if the icon is an SF Symbol
                    Image(systemName: icon)
                        .resizable()
                        .scaledToFit()
                        .frame(width: 30, height: 30)
                        .foregroundColor(.darkerBlue)
                } else { // Use a custom asset image if not an SF Symbol
                    Image(icon)
                        .resizable()
                        .scaledToFit()
                        .frame(width: 30, height: 30)
                }
            }
            .frame(width: 55, height: 55)
            .background(Color.lightBlue)
            .cornerRadius(10)
            
            Text("\(stat): \(value)")
                .font(.statsCard)
                .foregroundColor(.white)
            
            Spacer()
            
            if showChevron { // Conditionally show the chevron
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
