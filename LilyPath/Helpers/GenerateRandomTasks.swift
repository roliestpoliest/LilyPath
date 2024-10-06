//
//  GenerateRandomTasks.swift
//  LilyPath
//
//  Created by Chelsea Nguyen on 10/4/24.
//

func generateRandomTasks() -> [TaskModel] {
    return TaskType.all.map { taskType in
        let goal = taskType.generateRandomGoal()
        let rewards = taskType.calculateRewards(for: goal)
        
        return TaskModel(
            type: taskType,
            goal: goal,
            taskWaterPointsReward: rewards.waterPoints,
            taskGemsReward: rewards.gems
        )
    }
}
