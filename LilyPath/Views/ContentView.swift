//
//  ContentView.swift
//  LilyPath
//
//  Created by Carolyn Heron on 9/29/24.
//

import SwiftUI
import SwiftData

struct ContentView: View {
    @Query private var currencyModels: [CurrencyModel]
    
    @EnvironmentObject var healthManager: HealthManager
    
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
                    .environmentObject(healthManager)
                    .tag(Tabs.stats)
            }
            TabBar(selectedTab: $selectedTab)
                .background(Color.mainBackground)
        }
        .onAppear {
            Task {
                unconvertedSteps = await getUnconvertedUserDailySteps(currencyModels: currencyModels, healthManager: healthManager)
            }
        }
        .padding(.horizontal, 30)
        .background(Color.mainBackground)
    }
}

#Preview {
    ContentView()
        .environmentObject(HealthManager())
}
