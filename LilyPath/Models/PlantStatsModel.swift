////
////  PlantStatsModel.swift
////  LilyPath
////
////  Created by Chelsea Nguyen on 10/23/24.
////
//
//import Foundation
//

// TODO: DELETE UNUSED FILE

//class PlantStatsModel: Identifiable, ObservableObject {
//    let id: String
//    let icon: Icon
//    let plant: String
//    let action: String
//    @Published var count: Int
//    
//    init(id: String, icon: Icon, plant: String, action: String, count: Int = 0) {
//        self.id = id
//        self.icon = icon
//        self.plant = plant
//        self.action = action
//        self.count = count
//    }
//    
//    func description(for timePeriod: TimePeriod) -> String {
//        let value = formatNumberWithCommas(count)
//        return "\(value) \(detail(for: value))"
//    }
//    
//    private func detail(for value: String) -> String {
//        "\(unitWithPluralSuffix(for: value)) \(action)"
//    }
//    
//    private func unitWithPluralSuffix(for value: String) -> String {
//        "\(plant)\(value == "1" ? "" : "s")"
//    }
//}
//
//extension PlantStatsModel {
//    static let seedsPlanted = PlantStatsModel(
//        id: "seedsPlanted",
//        icon: .newPlant,
//        plant: "seed",
//        action: "planted"
//    )
//    
//    static let plantsCompleted = PlantStatsModel(
//        id: "plantsCompleted",
//        icon: .garden,
//        plant: "plant",
//        action: "completed"
//    )
//    
//    static let plantsWatered = PlantStatsModel(
//        id: "plantsWatered",
//        icon: .waterDrop,
//        plant: "plant",
//        action: "watered"
//    )
//    
//    static let allStats: [PlantStatsModel] = [
//        seedsPlanted,
//        plantsCompleted,
//        plantsWatered,
//    ]
//}
