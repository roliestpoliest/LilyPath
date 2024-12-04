//
//  DailyTasksView.swift
//  LilyPath
//
//  Created by Chelsea Nguyen on 10/3/24.
//

import SwiftData
import SwiftUI

struct DailyTasksView: View {
    @Query(sort: [SortDescriptor(\TaskModel.timestamp, order: .forward)])
    var tasks: [TaskModel]
    @Environment(\.modelContext) private var modelContext
    @EnvironmentObject var healthManager: HealthManager
    @State private var lastGeneratedDate: Date =
        UserDefaults.standard.object(forKey: "lastGeneratedDate") as? Date
        ?? Date.distantPast

    var body: some View {
        VStack {
            UserCurrencyBar()

            ViewTitle(title: "Daily Tasks")

            ScrollView(showsIndicators: false) {
                ForEach(tasks) { task in
                    TaskCard(task: task)
                        .padding(.vertical, 8)
                }
            }
            .shadow(radius: ShadowConstants.radius, y: ShadowConstants.yOffset)

            Spacer()
        }
        .background(Color.mainBackground)
        .onAppear {
            Task {
                await updateTaskProgress()
                generateTasksIfNeeded()
            }
        }
    }

    private func generateTasksIfNeeded() {
        let currentDate = Calendar.current.startOfDay(for: Date())

        if Calendar.current.isDate(lastGeneratedDate, inSameDayAs: currentDate)
        {
            print("Tasks already generated for today.")
            return
        }

        for task in tasks {
            modelContext.delete(task)
        }

        let newTasks = generateRandomTasks()
        for task in newTasks {
            task.timestamp = Date()
            modelContext.insert(task)
        }

        do {
            try modelContext.save()
            lastGeneratedDate = currentDate
            UserDefaults.standard.set(
                lastGeneratedDate, forKey: "lastGeneratedDate")
            print("New tasks saved successfully on", currentDate)
        } catch {
            print("Failed to save new tasks: \(error)")
        }
    }

    private func generateRandomTasks() -> [TaskModel] {
        func generateRandomGoal(for taskType: TaskType) -> Int {
            let range = stride(
                from: taskType.lowerBound,
                through: taskType.upperBound,
                by: taskType.incrementFactor
            )

            return Array(range).randomElement() ?? taskType.lowerBound
        }

        func calculateRewards(for taskType: TaskType, goal: Int) -> (
            waterPoints: Int, gems: Int
        ) {
            let maxGoal = taskType.upperBound
            let minGoal = taskType.lowerBound

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

    private func updateTaskProgress() async {
        let startDate = Calendar.current.startOfDay(for: Date())

        async let stepsData = fetchHourlyData(
            using: healthManager.fetchHourlySteps, startDate: startDate)
        async let caloriesData = fetchHourlyData(
            using: healthManager.fetchHourlyCalories, startDate: startDate)
        async let flightsData = fetchHourlyData(
            using: healthManager.fetchHourlyFlightsClimbed, startDate: startDate
        )
        async let sleepData = fetchHourlyData(
            using: healthManager.fetchHourlySleep, startDate: startDate)
        async let distanceData = fetchHourlyData(
            using: healthManager.fetchHourlyWalkingRunningDistance,
            startDate: startDate)

        let results = await [
            stepsData, caloriesData, flightsData, sleepData, distanceData,
        ]
        let metricProgress = Dictionary(
            uniqueKeysWithValues: zip(
                TaskType.allTasks.map(\.descriptionTemplate), results))

        for task in tasks {
            if let progress = metricProgress[task.type.descriptionTemplate] {
                task.userProgress = min(progress, task.goal)

                if task.userProgress >= task.goal {
                    task.status = .collect
                }
            }
        }

        do {
            try modelContext.save()
            print("Task progress updated successfully.")
        } catch {
            print("Failed to save task progress: \(error)")
        }
    }

    private func fetchHourlyData(
        using fetchFunction: @escaping (
            Date, @escaping ([HealthDataPoint]) -> Void
        ) -> Void,
        startDate: Date
    ) async -> Int {
        await withCheckedContinuation { continuation in
            fetchFunction(startDate) { dataPoints in
                let total = dataPoints.reduce(0) { $0 + Int($1.value) }
                continuation.resume(returning: total)
            }
        }
    }
}

#Preview {
    return DailyTasksView()
        .padding(.horizontal, 30)
}
