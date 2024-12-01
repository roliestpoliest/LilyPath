//
//  ContentView.swift
//  databased
//
//  Created by Carolyn Heron on 12/1/24.
//

import SwiftData
import SwiftUI

struct ContentView: View {
    @Environment(\.modelContext) private var context  // Access ModelContext
    @Query private var tasks: [TaskModel]  // Fetch TaskModel items
    @Query private var currency: [CurrencyModel]  // Fetch the single CurrencyModel instance

    var body: some View {
        VStack {
            Text("Task List")
                .font(.largeTitle)
                .padding()

            HStack {
                Button(action: {
                    TaskManager.shared.generateRandomTask(context: context)  // Generate a new task
                }) {
                    Text("Generate Task")
                        .padding()
                        .background(Color.blue)
                        .foregroundColor(.white)
                        .cornerRadius(8)
                }

                Button(action: autoPopulateProgress) {
                    Text("Auto Populate Progress")
                        .padding()
                        .background(Color.orange)
                        .foregroundColor(.white)
                        .cornerRadius(8)
                }
            }
            .padding()

            List(tasks) { task in
                VStack(alignment: .leading) {
                    Text(
                        "Task: \(String(format: task.type.descriptionTemplate, "\(task.goal)"))"
                    )
                    Text("Water Points: \(task.waterPointReward)")
                    Text("Gems: \(task.gemReward)")
                    Text("Progress: \(task.userProgress)/\(task.goal)")
                    Text("Status: \(task.status)")

                    if task.status == TaskStatus.collect.rawValue {
                        Button(action: {
                            collectRewards(for: task)
                        }) {
                            Text("Collect Rewards")
                                .padding(10)
                                .background(Color.green)
                                .foregroundColor(.white)
                                .cornerRadius(8)
                        }
                    }
                }
                .padding(.vertical, 4)
            }
        }
        .padding()
    }

    /// Function to auto-populate progress for all tasks
    private func autoPopulateProgress() {
        for task in tasks {
            guard task.status == TaskStatus.inProgress.rawValue else {
                continue
            }

            // Increment progress
            task.userProgress += Int.random(in: 1...5)  // Simulate random progress

            // Check if the task is completed
            if task.userProgress >= task.goal {
                task.userProgress = task.goal  // Cap progress at the goal
                task.status = TaskStatus.collect.rawValue  // Mark as ready to collect
            }
        }

        // Save changes to the database
        try? context.save()
    }

    /// Function to collect rewards and update the single CurrencyModel instance
    private func collectRewards(for task: TaskModel) {
        guard task.status == TaskStatus.collect.rawValue else { return }

        // Directly access the single CurrencyModel instance
        let currency = currency[0]  // Assume only one CurrencyModel exists

        // Update the existing CurrencyModel with task rewards
        currency.waterPoints += task.waterPointReward
        currency.gems += task.gemReward

        // Mark the task as completed
        task.status = TaskStatus.completed.rawValue

        // Save the changes
        try? context.save()
        print(
            "Rewards collected. Updated Currency: WaterPoints = \(currency.waterPoints), Gems = \(currency.gems)"
        )
    }
}
