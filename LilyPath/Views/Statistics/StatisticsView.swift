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
        NavigationStack {
            VStack {
                StatNavigationLink(title: "Plant Stats", destination: PlantStatsView())
                
                StatNavigationLink(title: "Fitness Stats", destination: FitnessStatsView())
                
                Spacer()
            }
            .background(Color.mainBackground)
        }
    }
}

struct StatNavigationLink<Destination: View>: View {
    let title: String
    let destination: Destination

    var body: some View {
        NavigationLink(destination: destination) {
            HStack {
                ViewTitle(title: title)

                Spacer()

                Image(systemName: "chevron.right")
                    .font(.viewTitle)
                    .foregroundColor(Color.customBrown)
            }
        }
    }
}

#Preview {
    StatisticsView()
        .padding(.horizontal, 30)
        .background(Color.mainBackground)
}
