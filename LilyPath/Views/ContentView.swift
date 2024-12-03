//
//  ContentView.swift
//  LilyPath
//
//  Created by Carolyn Heron on 9/29/24.
//

import SwiftUI

struct ContentView: View {
    @EnvironmentObject var healthManager: HealthManager
    @State private var selectedTab: Tabs = .home

    var body: some View {
        ZStack(alignment: .bottom) {
            TabView(selection: $selectedTab) {
                GardenView()
                    .tag(Tabs.garden)
                
                HomeView()
                    .tag(Tabs.home)
                
                StatisticsView()
                    .environmentObject(healthManager)
                    .tag(Tabs.stats)
            }
            TabBar(selectedTab: $selectedTab)
                .background(Color.mainBackground)
        }
        .padding(.horizontal, 30)
        .background(Color.mainBackground)
    }
}

#Preview {
    ContentView()
        .environmentObject(HealthManager())
}
