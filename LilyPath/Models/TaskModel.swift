//
//  TaskModel.swift
//  LilyPath
//
//  Created by Chelsea Nguyen on 10/4/24.
//

import Foundation

struct TaskType {
    let descriptionTemplate: String
    let goalRange: ClosedRange<Int>
    let incrementFactor: Int

    init(descriptionTemplate: String, goalRange: ClosedRange<Int>, incrementFactor: Int = 1) {
        self.descriptionTemplate = descriptionTemplate
        self.goalRange = goalRange
        self.incrementFactor = incrementFactor
    }
    
    private func formatNumberWithCommas(_ number: Int) -> String {
        let numberFormatter = NumberFormatter()
        numberFormatter.numberStyle = .decimal
        return numberFormatter.string(from: NSNumber(value: number)) ?? "\(number)"
    }

    func description(for goal: Int) -> String {
        return String(format: descriptionTemplate, formatNumberWithCommas(goal))
    }

    static let walk = TaskType(descriptionTemplate: "Walk %@ steps", goalRange: 80...150, incrementFactor: 100)
    static let climb = TaskType(descriptionTemplate: "Climb %@ flights of stairs", goalRange: 10...20)
    static let sleep = TaskType(descriptionTemplate: "Get %@ hours of sleep", goalRange: 7...9)
    static let stand = TaskType(descriptionTemplate: "Stand for %@ hours", goalRange: 4...7)
    
    static let all: [TaskType] = [.walk, .climb, .sleep, .stand]
}

class TaskModel {
    enum TaskStatus: String {
        case inProgress = "In Progress"
        case completed = "Completed"
        case collected = "Collected"
    }
    
    let type: TaskType
    var goal: Int
    var waterPointReward: Int
    var gemReward: Int
    var status: TaskStatus

    init(type: TaskType, goal: Int, waterPointReward: Int, gemReward: Int, status: TaskStatus = .inProgress) {
        self.type = type
        self.goal = goal
        self.waterPointReward = waterPointReward
        self.gemReward = gemReward
        self.status = status
    }

    var taskName: String {
        return type.description(for: goal)
    }

    func updateStatus(status: TaskStatus) {
        self.status = status
    }
}
