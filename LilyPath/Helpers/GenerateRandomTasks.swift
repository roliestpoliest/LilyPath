//
//  GenerateRandomTasks.swift
//  LilyPath
//
//  Created by Chelsea Nguyen on 10/4/24.
//

func generateRandomTasks() -> [TaskModel] {
    func generateRandomGoal(for taskType: TaskType) -> Int {
        let range = stride(
            from: taskType.goalRange.lowerBound,
            through: taskType.goalRange.upperBound,
            by: taskType.incrementFactor
        )
        
        return Array(range).randomElement() ?? taskType.goalRange.lowerBound
    }
    
    func calculateRewards(for taskType: TaskType, goal: Int) -> (
        waterPoints: Int, gems: Int
    ) {
        let maxGoal = taskType.goalRange.upperBound
        let minGoal = taskType.goalRange.lowerBound
        
        let progress = Double(goal - minGoal) / Double(maxGoal - minGoal)
        
        let waterPoints = Int(100 + progress * 100) * 10  // Min: 1000, Max: 2000, Increment: 10
        let gems = Int(1 + progress * 3)  // Min: 1, Max: 4
        
        return (waterPoints, gems)
    }
    
    return TaskType.allTasks.map { taskType in
        let goal = generateRandomGoal(for: taskType)
        let rewards = calculateRewards(for: taskType, goal: goal)
        
        return TaskModel(
            type: taskType,
            goal: goal,
            waterPointReward: rewards.waterPoints,
            gemReward: rewards.gems
        )
    }
}
