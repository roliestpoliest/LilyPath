//
//  FitnessStatModel.swift
//  LilyPath
//
//  Created by Chelsea Nguyen on 10/22/24.
//

import Foundation

class FitnessStatsModel: Identifiable, ObservableObject {
    let id: String
    let icon: Icon
    @Published private(set) var values: [TimePeriod: Int] = [:]
    let unit: String
    let action: String
    
    init(id: String, icon: Icon, unit: String, action: String) {
        self.id = id
        self.icon = icon
        self.unit = unit
        self.action = action
        fetchInitialValues()
    }
    
    func value(for timePeriod: TimePeriod) -> Int {
        values[timePeriod] ?? 0
    }
    
    func description(for timePeriod: TimePeriod) -> String {
        let value = formatNumberWithCommas(self.value(for: timePeriod))
        return "\(value) \(detail(for: value))"
    }
    
    private func detail(for value: String) -> String {
        "\(unitWithPluralSuffix(for: value)) \(action)"
    }
    
    private func unitWithPluralSuffix(for value: String) -> String {
        "\(unit)\(value == "1" ? "" : "s")"
    }
    
    // TODO: incorporate healthKit data fetching
    private func fetchInitialValues() {
        DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
            self.values = [
                .daily: 0,
                .weekly: 0,
                .monthly: 0,
            ]
        }
    }
    
    // TODO: incorporate healthKit data fetching
    func updateValues(_ newValues: [TimePeriod: Int]) {
        DispatchQueue.main.async {
            self.values = newValues
        }
    }
}

extension FitnessStatsModel {
    static let steps = FitnessStatsModel(
        id: "steps",
        icon: .steps,
        unit: "step",
        action: "taken"
    )

    static let distance = FitnessStatsModel(
        id: "distance",
        icon: .distance,
        unit: "mile",
        action: "walked & ran"
    )

    static let climbed = FitnessStatsModel(
        id: "climbed",
        icon: .climbed,
        unit: "flight",
        action: "climbed"
    )

    static let slept = FitnessStatsModel(
        id: "slept",
        icon: .slept,
        unit: "hour",
        action: "slept"
    )

    static let calories = FitnessStatsModel(
        id: "calories",
        icon: .calories,
        unit: "cal",
        action: "burned"
    )

    static let allFitnessStats: [FitnessStatsModel] = [
        .steps,
        .distance,
        .climbed,
        .slept,
        .calories
    ]
}
