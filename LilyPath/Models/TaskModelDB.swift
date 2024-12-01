//
//  TaskModelDB.swift
//  LilyPath
//
//  Created by Carolyn Heron on 12/1/24.
//


//@Model
//class TaskModelDB: Identifiable {
//    var id: String
//    var name: String
//    var createdAt: Date?
//
//    init(name: String) {
//        self.id = UUID().uuidString
//        self.name = name
//        self.createdAt = Date()
//
//    }
//}


import Foundation
import SwiftData

@Model
class TaskModelDB: Identifiable {
    var id: String
    var type: String
    var goal: Int
    var waterPointReward: Int
    var gemReward: Int
    var userProgress: Int
    var status: String // Store as a string for compatibility
    var createdAt: Date?
    
    init(
        type: String,
        goal: Int,
        waterPointReward: Int,
        gemReward: Int,
        userProgress: Int = 0,
        status: String = TaskStatus.inProgress.rawValue
    ) {
        self.id = UUID().uuidString
        self.type = type
        self.goal = goal
        self.waterPointReward = waterPointReward
        self.gemReward = gemReward
        self.userProgress = userProgress
        self.status = status
        self.createdAt = Date()
    }
}




class TaskManager {
    @Environment(\.modelContext) private var context
    @Query private var tasks: [TaskModel]
    
    func generateNewTasks() {
        // Delete all existing tasks
        for task in tasks {
            context.delete(task)
        }
        
        // Add new tasks
        for taskType in TaskType.allTasks {
            let goal = Int.random(in: taskType.goalRange)
            let task = TaskModel(
                type: taskType.descriptionTemplate,
                goal: goal,
                waterPointReward: 10,
                gemReward: 5
            )
            context.insert(task)
        }
        
        // Save changes to the database
        try? context.save()
    }
}
