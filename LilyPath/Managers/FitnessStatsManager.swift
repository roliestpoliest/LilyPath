//
//  FitnessStatsManager.swift
//  LilyPath
//
//  Created by Chelsea Nguyen on 10/23/24.
//

// TODO: DELETE UNUSED FILE
//import Foundation
//
//class FitnessStatsManager: ObservableObject {
//    static let shared = FitnessStatsManager()
//    
//    @Published var fitnessStats: [FitnessStatsModel]
//    
//    private init() {
//        self.fitnessStats = FitnessStatsModel.allFitnessStats
//    }
//    
//    // TODO: incorporate healthKit data fetching
//    func fetchAndUpdateStats() {
//        // Simulated HealthKit data fetching
//        DispatchQueue.global().asyncAfter(deadline: .now() + 2) {
//            let newValues: [TimePeriod: Int] = [
//                .daily: 5000, .weekly: 35000, .monthly: 120000,
//            ]
//            if let stepsStat = self.fitnessStats.first(where: {
//                $0.id == "steps"
//            }) {
//                stepsStat.updateValues(newValues)
//            }
//        }
//    }
//}
