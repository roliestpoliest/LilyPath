//
//  TaskModel.swift
//  LilyPath
//
//  Created by Chelsea Nguyen on 10/4/24.
//

import SwiftData
import SwiftUI

@Model
class TaskModel: Identifiable {
    @Attribute(.unique) var id: UUID = UUID()
    var type: TaskType
    var goal: Int
    var waterPointReward: Int
    var gemReward: Int
    var userProgress: Int
    var status: TaskStatus
    var timestamp: Date = Date()

    init(type: TaskType, goal: Int, waterPointReward: Int, gemReward: Int, userProgress: Int = 0, status: TaskStatus = .inProgress) {
        self.type = type
        self.goal = goal
        self.waterPointReward = waterPointReward
        self.gemReward = gemReward
        self.userProgress = userProgress
        self.status = status
    }
    
    var taskName: String {
        type.description(for: goal)
    }
}

enum TaskStatus: String, Codable {
    case inProgress = "In Progress"
    case collect = "Collect"
    case completed = "Completed"
}

struct TaskType: Codable {
    let descriptionTemplate: String
    let lowerBound: Int
    let upperBound: Int
    let incrementFactor: Int
    
    init(
        descriptionTemplate: String, lowerBound: Int, upperBound: Int,
        incrementFactor: Int = 1
    ) {
        self.descriptionTemplate = descriptionTemplate
        self.lowerBound = lowerBound
        self.upperBound = upperBound
        self.incrementFactor = incrementFactor
    }
    
    func description(for goal: Int) -> String {
        String(format: descriptionTemplate, formatNumberWithCommas(goal))
    }
}

extension TaskType {
    static let calories = TaskType(
        descriptionTemplate: "Burn %@ calories",
        lowerBound: 300,
        upperBound: 600
    )
    static let climb = TaskType(
        descriptionTemplate: "Climb %@ flights of stairs",
        lowerBound: 8,
        upperBound: 18
    )
    static let sleep = TaskType(
        descriptionTemplate: "Get %@ hours of sleep",
        lowerBound: 7,
        upperBound: 9
    )
    static let distance = TaskType(
        descriptionTemplate: "Walk & run %@ miles",
        lowerBound: 2,
        upperBound: 5
    )
    static let walk = TaskType(
        descriptionTemplate: "Walk %@ steps",
        lowerBound: 5000,
        upperBound: 10000,
        incrementFactor: 100
    )
    
    static let allTasks: [TaskType] = [
        .walk, .distance, .climb, .sleep, .calories,
    ]
}
