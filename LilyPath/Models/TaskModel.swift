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

class TaskModel: ObservableObject {
    enum TaskStatus: String {
        case inProgress = "In Progress"
        case collect = "Collect"
        case completed = "Completed"
    }
    
    let type: TaskType
    let goal: Int
    let waterPointReward: Int
    let gemReward: Int
    @Published var userProgress: Int
    @Published var status: TaskStatus
    
    init(type: TaskType, goal: Int, waterPointReward: Int, gemReward: Int, userProgress: Int = 0, status: TaskStatus = .inProgress) {
        self.type = type
        self.goal = goal
        self.waterPointReward = waterPointReward
        self.gemReward = gemReward
        self.userProgress = userProgress
        self.status = status
    }

    var taskName: String {
        return type.description(for: self.goal)
    }

    func updateStatus(to status: TaskStatus) {
        self.status = status
    }
    
    func checkProgress() {
        if self.userProgress >= self.goal {
            updateStatus(to: .completed)
        }
    }
    
    // TODO: update functionality
    func updateUserProgress(to newProgress: Int) {
        self.userProgress = newProgress
        checkProgress()
    }
}
