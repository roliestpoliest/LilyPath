//
//  GenerateRandomTasks.swift
//  LilyPath
//
//  Created by Chelsea Nguyen on 10/4/24.
//

func generateRandomTasks() -> [TaskModel] {
    let tasks: [Task] = [.walk(Int.random(in: 80...150) * 100),
                         .climb(Int.random(in: 10...20)),
                         .sleeps(Int.random(in: 7...9)),
                         .stand(Int.random(in: 4...7))]

    return tasks.map { task in
        TaskModel(
            taskName: task.description(),
            taskGoal: task.goal(),
            taskWaterPointsReward: Int.random(in: 10...15) * 100,
            taskGemsReward: Int.random(in: 1...4)
        )
    }
}
