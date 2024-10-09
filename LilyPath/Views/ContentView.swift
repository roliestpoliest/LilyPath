//
//  ContentView.swift
//  LilyPath
//
//  Created by Carolyn Heron on 9/29/24.
//

import SwiftUI

struct ContentView: View {
    @State var selectedTab: Tabs = .home
    
    var body: some View {
        VStack {
            TabView(selection: $selectedTab) {
                GardenView()
                    .tag(Tabs.garden)
                
                // TODO: replace with user's current plant
                HomeView(
                    userCurrentPlant:
                        UserPlantModel(
                            basePlant: BasePlantModel.buttercup,
                            currentStage: 3,
                            stepsCollected: [100, 200, 100].reduce(0, +))
                )
                .tag(Tabs.home)
                
                StatisticsView()
                    .tag(Tabs.stats)
            }
            .tabViewStyle(PageTabViewStyle(indexDisplayMode: .never))
            
            TabBar(selectedTab: $selectedTab)
        }
        .padding(.horizontal, 30)
        .background(Color.mainBackground)
    }
}

#Preview {
    ContentView()
}
