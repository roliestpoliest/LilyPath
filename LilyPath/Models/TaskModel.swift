//
//  TaskModel.swift
//  LilyPath
//
//  Created by Chelsea Nguyen on 10/4/24.
//

import Foundation

class TaskManager: ObservableObject {
    static let shared = TaskManager()
    
    @Published var tasks: [TaskModel]
    
    private init() {
        self.tasks = generateRandomTasks()
    }
    
    // TODO: generate randome tasks once a day
    func generateNewTasks() {
        self.tasks = generateRandomTasks()
    }
}

class TaskModel: ObservableObject {
    let type: TaskType
    let goal: Int
    let waterPointReward: Int
    let gemReward: Int
    @Published var userProgress: Int
    @Published var status: TaskStatus
    
    init(
        type: TaskType,
        goal: Int,
        waterPointReward: Int,
        gemReward: Int,
        userProgress: Int = 0,
        status: TaskStatus = .inProgress
    ) {
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
    
    func updateStatus(to status: TaskStatus) {
        self.status = status
    }
    
    func checkProgress() {
        if userProgress >= goal {
            updateStatus(to: .completed)
        }
    }
    
    // TODO: update functionality
    func updateUserProgress(to newProgress: Int) {
        userProgress = newProgress
        checkProgress()
    }
}

enum TaskStatus: String {
    case inProgress = "In Progress"
    case collect = "Collect"
    case completed = "Completed"
}

struct TaskType {
    let descriptionTemplate: String
    let goalRange: ClosedRange<Int>
    let incrementFactor: Int
    
    init(
        descriptionTemplate: String, goalRange: ClosedRange<Int>,
        incrementFactor: Int = 1
    ) {
        self.descriptionTemplate = descriptionTemplate
        self.goalRange = goalRange
        self.incrementFactor = incrementFactor
    }
    
    func description(for goal: Int) -> String {
        String(format: descriptionTemplate, formatNumberWithCommas(goal))
    }
}

extension TaskType {
    static let walk = TaskType(
        descriptionTemplate: "Walk %@ steps",
        goalRange: 5000...10000,
        incrementFactor: 100
    )
    static let distance = TaskType(
        descriptionTemplate: "Walk & run %@ miles",
        goalRange: 2...5
    )
    static let climb = TaskType(
        descriptionTemplate: "Climb %@ flights of stairs",
        goalRange: 8...18
    )
    static let sleep = TaskType(
        descriptionTemplate: "Get %@ hours of sleep",
        goalRange: 7...9
    )
    static let calories = TaskType(
        descriptionTemplate: "Burn %@ calories",
        goalRange: 300...600
    )
    
    static let allTasks: [TaskType] = [
        .walk, .distance, .climb, .sleep, .calories,
    ]
}
