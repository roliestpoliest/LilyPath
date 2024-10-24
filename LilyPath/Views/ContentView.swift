//
//  ContentView.swift
//  LilyPath
//
//  Created by Carolyn Heron on 9/29/24.
//

import SwiftUI

struct ContentView: View {
    @EnvironmentObject var healthManager: HealthManager
    @StateObject var userPlantManager = UserPlantManager.shared
    @State var selectedTab: Tabs = .home
    
    var body: some View {
        ZStack(alignment: .bottom) {
            TabView(selection: $selectedTab) {
                GardenView()
                    .tag(Tabs.garden)
                
                HomeView()
                    .tag(Tabs.home)
                
                StatisticsView()
                    .tag(Tabs.stats)
            }
            TabBar(selectedTab: $selectedTab)
                .background(Color.mainBackground)
        }
        .environmentObject(userPlantManager)
        .padding(.horizontal, 30)
        .background(Color.mainBackground)
    }
}

#Preview {
    ContentView()
        .environmentObject(HealthManager())
        .environmentObject(UserPlantManager.shared)
}
