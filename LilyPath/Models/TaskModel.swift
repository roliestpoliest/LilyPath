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
    
    func generateRandomGoal() -> Int {
        return Int.random(in: goalRange) * incrementFactor
    }

    func calculateRewards(for goal: Int) -> (waterPoints: Int, gems: Int) {
        let maxGoal = goalRange.upperBound
        let minGoal = goalRange.lowerBound
        
        let waterPoints = ((100 + ((goal - minGoal) * 100) / (maxGoal - minGoal)) / incrementFactor) * 10 // Min: 1000, Max: 2000, Increment: 10
        let gems = (1 + ((goal - minGoal) * 3) / (maxGoal - minGoal)) / incrementFactor // Min: 1, Max: 4

        return (waterPoints, gems)
    }

    static let walk = TaskType(descriptionTemplate: "Walk %@ steps", goalRange: 80...150, incrementFactor: 100)
    static let climb = TaskType(descriptionTemplate: "Climb %@ flights of stairs", goalRange: 10...20)
    static let sleep = TaskType(descriptionTemplate: "Get %@ hours of sleep", goalRange: 7...9)
    static let stand = TaskType(descriptionTemplate: "Stand for %@ hours", goalRange: 4...7)
    
    static let all: [TaskType] = [.walk, .climb, .sleep, .stand]
}

class TaskModel {
    let type: TaskType
    let goal: Int
    let waterPointReward: Int
    let gemReward: Int
    var isRewardCollected: Bool
    var isCompleted: Bool

    init(type: TaskType, goal: Int,taskWaterPointsReward: Int, taskGemsReward: Int, isRewardCollected: Bool = false, isCompleted: Bool = false) {
        self.type = type
        self.goal = goal
        self.waterPointReward = taskWaterPointsReward
        self.gemReward = taskGemsReward
        self.isRewardCollected = isRewardCollected
        self.isCompleted = isCompleted
    }

    var taskName: String {
        return type.description(for: goal)
    }

    func updateProgress(toCompleted: Bool) {
        self.isCompleted = toCompleted
    }
    
    func updateReward(toCollected: Bool) {
        self.isRewardCollected = toCollected
    }
}
