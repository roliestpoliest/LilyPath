//
//  TaskManager.swift
//  databased
//
//  Created by Carolyn Heron on 12/1/24.
//


import SwiftData

class TaskManager {
    static let shared = TaskManager() // Singleton for centralized management
    
    private init() {}
    
    /// Seed predefined TaskTypes into the database
    func seedTaskTypes(context: ModelContext) {
        let predefinedTaskTypes = [
            TaskType(descriptionTemplate: "Walk %@ steps", goalRangeLower: 5000, goalRangeUpper: 10000, incrementFactor: 100),
            TaskType(descriptionTemplate: "Walk & run %@ miles", goalRangeLower: 2, goalRangeUpper: 5),
            TaskType(descriptionTemplate: "Climb %@ flights of stairs", goalRangeLower: 8, goalRangeUpper: 18),
            TaskType(descriptionTemplate: "Get %@ hours of sleep", goalRangeLower: 7, goalRangeUpper: 9),
            TaskType(descriptionTemplate: "Burn %@ calories", goalRangeLower: 300, goalRangeUpper: 600)
        ]
        
        let fetchDescriptor = FetchDescriptor<TaskType>()
        do {
            // Fetch existing TaskTypes
            let existingTaskTypes = try context.fetch(fetchDescriptor)
            if existingTaskTypes.isEmpty {
                // Seed predefined TaskTypes if none exist
                for taskType in predefinedTaskTypes {
                    context.insert(taskType)
                }
                try context.save()
                print("TaskTypes seeded successfully.")
            } else {
                print("TaskTypes already exist.")
            }
        } catch {
            print("Failed to seed TaskTypes: \(error)")
        }
    }
    
    /// Generate a random TaskModel based on available TaskTypes
    func generateRandomTask(context: ModelContext) {
        let fetchDescriptor = FetchDescriptor<TaskType>()
        do {
            // Fetch all available TaskTypes
            let taskTypes = try context.fetch(fetchDescriptor)
            guard let taskType = taskTypes.randomElement() else {
                print("No TaskTypes available to generate a task.")
                return
            }
            
            // Generate a random goal and create a new TaskModel
            let goal = taskType.randomGoal()
            let newTask = TaskModel(
                type: taskType,
                goal: goal,
                waterPointReward: Int.random(in: 5...20),
                gemReward: Int.random(in: 1...10),
                userProgress: 0,
                status: TaskStatus.inProgress.rawValue
            )
            context.insert(newTask)
            try context.save()
            print("Task generated: \(taskType.descriptionTemplate) with goal \(goal)")
        } catch {
            print("Failed to generate a task: \(error)")
        }
    }
}
