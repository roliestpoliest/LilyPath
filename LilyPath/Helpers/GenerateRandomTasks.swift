//
//  GenerateRandomTasks.swift
//  LilyPath
//
//  Created by Chelsea Nguyen on 10/4/24.
//

func generateRandomTasks() -> [TaskModel] {
    func generateRandomGoal(taskType: TaskType) -> Int {
        return Int.random(in: taskType.goalRange) * taskType.incrementFactor
    }

    func calculateRewards(taskType: TaskType, goal: Int) -> (waterPoints: Int, gems: Int) {
        let maxGoal = taskType.goalRange.upperBound
        let minGoal = taskType.goalRange.lowerBound
        
        let waterPoints = ((100 + ((goal - minGoal) * 100) / (maxGoal - minGoal)) / taskType.incrementFactor) * 10 // Min: 1000, Max: 2000, Increment: 10
        let gems = (1 + ((goal - minGoal) * 3) / (maxGoal - minGoal)) / taskType.incrementFactor // Min: 1, Max: 4
        
        return (waterPoints, gems)
    }
    
    return TaskType.all.map { taskType in
        let goal = generateRandomGoal(taskType: taskType)
        let rewards = calculateRewards(taskType: taskType, goal: goal)
        
        return TaskModel(
            type: taskType,
            goal: goal,
            waterPointReward: rewards.waterPoints,
            gemReward: rewards.gems
        )
    }
}
