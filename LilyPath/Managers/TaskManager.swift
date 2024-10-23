//
//  TaskManager.swift
//  LilyPath
//
//  Created by Chelsea Nguyen on 10/23/24.
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
