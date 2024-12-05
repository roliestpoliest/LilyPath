//
//  ContentView.swift
//  LilyPath
//
//  Created by Carolyn Heron on 9/29/24.
//

import SwiftUI
import SwiftData

struct ContentView: View {
    @State private var selectedTab: Tabs = .home
    @State var unconvertedSteps: Int = 0

    var body: some View {
        ZStack(alignment: .bottom) {
            TabView(selection: $selectedTab) {
                GardenView()
                    .tag(Tabs.garden)
                
                HomeView(unconvertedSteps: $unconvertedSteps)
                    .tag(Tabs.home)
                
                StatisticsView()
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
