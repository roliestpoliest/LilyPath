// TODO: DELETE UNUSED FILE
////
////  FitnessStatsDetailView.swift
////  LilyPath
////
////  Created by Carolyn Heron on 10/23/24.
////
//
//import SwiftUI
//
//// TODO: separate onto a different file & reformat
//struct FitnessStatsDetailView: View {
//    @ObservedObject var stat: FitnessStatsModel
//    let timePeriod: TimePeriod
//    
//    var body: some View {
//        VStack {
//            // TODO: Add Swift Chart
//            Image(systemName: "chart.bar")
//                .resizable()
//                .scaledToFit()
//                .frame(height: 200)
//                .padding()
//            
//            Text(stat.description(for: timePeriod))
//                .font(.title2)
//                .padding()
//            
//            Spacer()
//        }
//        .frame(maxWidth: .infinity, maxHeight: .infinity)
//        .navigationTitle(
//            "\(timePeriod.rawValue.capitalized) \(stat.id.capitalized)"
//        )
//        .background(Color.mainBackground)
//    }
//}
//
