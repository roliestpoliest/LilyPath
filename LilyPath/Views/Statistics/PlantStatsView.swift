//
//  PlantStatsView.swift
//  LilyPath
//
//  Created by Chelsea Nguyen on 10/21/24.
//

import SwiftUI

//struct PlantStatsView: View {
//    @State private var selectedTimePeriod: TimePeriod = .daily
//    @ObservedObject private var plantManager = UserPlantManager.shared
//    
//    var body: some View {
//        NavigationStack {
//            VStack {
//                ViewTitle(title: "Plant Stats")
//                
//                TimePeriodPicker(selectedTimePeriod: $selectedTimePeriod)
//                    .padding(.bottom, 20)
//                    .shadow(
//                        radius: ShadowConstants.radius,
//                        y: ShadowConstants.yOffset)
//                
//                ScrollView {
//                    VStack(spacing: 30) {
//                        ForEach(PlantStatsModel.allStats, id: \.id) { stat in
//                            NavigationLink(
//                                destination: PlantStatsDetailView(
//                                    stat: stat, timePeriod: selectedTimePeriod)
//                            ) {
//                                StatsCard(
//                                    stat: stat, timePeriod: selectedTimePeriod)
//                            }
//                        }
//                    }
//                }
//                .shadow(
//                    radius: ShadowConstants.radius, y: ShadowConstants.yOffset)
//                
//                Spacer()
//            }
//            .background(Color.mainBackground)
//            .task(id: selectedTimePeriod) {
//                plantManager.updatePlantStats(for: selectedTimePeriod)
//            }
//        }
//    }
//}

//#Preview {
//    PlantStatsView()
//        .padding(.horizontal, 30)
//        .background(Color.mainBackground)
//}
