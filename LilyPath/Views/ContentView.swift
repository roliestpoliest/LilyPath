//
//  ContentView.swift
//  LilyPath
//
//  Created by Carolyn Heron on 9/29/24.
//

import SwiftUI

struct ContentView: View {
    @EnvironmentObject var healthManager: HealthManager
    @State var selectedTab: Tabs = .home

    var body: some View {
        VStack {
            ZStack {
                TabView(selection: $selectedTab) {
                    GardenView()
                        .tag(Tabs.garden)

                    HomeView()
                        .tag(Tabs.home)

                    StatisticsView()
                        .tag(Tabs.stats)
                        .environmentObject(healthManager)
                }
                .tabViewStyle(PageTabViewStyle(indexDisplayMode: .never))
            }
            TabBar(selectedTab: $selectedTab)
        }
        .padding(.horizontal, 30)
        .background(Color.mainBackground)
    }
}

#Preview {
    ContentView().environmentObject(HealthManager())
}
