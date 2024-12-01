//
//  TaskModel.swift
//  databased
//
//  Created by Carolyn Heron on 12/1/24.
//

import Foundation
import SwiftData

@Model
class TaskModel: Identifiable {
    var id: String
    var createdAt: Date?
    var type: TaskType // Relationship with TaskType
    var goal: Int
    var waterPointReward: Int
    var gemReward: Int
    var userProgress: Int
    var status: String
    
    init(type: TaskType, goal: Int, waterPointReward: Int, gemReward: Int, userProgress: Int, status: String) {
        self.id = UUID().uuidString
        self.createdAt = Date()
        self.type = type
        self.goal = goal
        self.waterPointReward = waterPointReward
        self.gemReward = gemReward
        self.userProgress = userProgress
        self.status = status
    }
}

enum TaskStatus: String {
    case inProgress = "In Progress"
    case collect = "Collect"
    case completed = "Completed"
}
