//
//  TaskType.swift
//  databased
//
//  Created by Carolyn Heron on 12/1/24.
//

import Foundation
import SwiftData

import SwiftData

@Model
class TaskType: Identifiable {
    var id: String
    var descriptionTemplate: String
    var goalRangeLower: Int
    var goalRangeUpper: Int
    var incrementFactor: Int
    
    init(
        descriptionTemplate: String,
        goalRangeLower: Int,
        goalRangeUpper: Int,
        incrementFactor: Int = 1
    ) {
        self.id = UUID().uuidString
        self.descriptionTemplate = descriptionTemplate
        self.goalRangeLower = goalRangeLower
        self.goalRangeUpper = goalRangeUpper
        self.incrementFactor = incrementFactor
    }
    
    func randomGoal() -> Int {
        Int.random(in: goalRangeLower...goalRangeUpper)
    }
}
