//
//  HomeView.swift
//  LilyPath
//
//  Created by Carolyn Heron on 9/29/24.
//

import SwiftUI

struct HomeView: View {
    @EnvironmentObject var healthManager: HealthManager
    var body: some View {
        VStack {
            ViewTitle(title: "Home")
//            Spacer()
            PopUp.fitnessStats(metricType: .steps, chartPeriod: .day)
        }
    }
}

#Preview {
    HomeView()
        .padding(.horizontal, 30)
        .background(Color.mainBackground)
}
