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
                ViewTitle(title: "temp")
                
      
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
