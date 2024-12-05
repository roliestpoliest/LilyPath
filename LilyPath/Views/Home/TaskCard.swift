//
//  TaskCard.swift
//  LilyPath
//
//  Created by Chelsea Nguyen on 10/4/24.
//

import SwiftUI
import SwiftData

struct TaskCard: View {
    var task: TaskModel
    @Environment(\.modelContext) private var context
    @Query private var currencyModels: [CurrencyModel]
    
    var body: some View {
        HStack(spacing: 16) {
            taskAndProgress
            rewardsAndTaskButton
        }
        .padding()
        .frame(height: 100)
        .background(Color.customBrown)
        .cornerRadius(20)
//        .overlay(simulateButton, alignment: .bottomTrailing) // Simulate progress button
    }
    
    var taskAndProgress: some View {
        VStack {
            Spacer()
            
            Text(task.taskName)
                .font(.customBody)
                .foregroundColor(.white)
                .frame(maxWidth: .infinity, alignment: .leading)
                .layoutPriority(1)
            
            ProgressBar(
                value: Double(task.userProgress), total: Double(task.goal),
                frameHeight: 11)
        }
    }
    
    var rewardsAndTaskButton: some View {
        VStack {
            rewards
                .padding(.horizontal)
            
            TaskButton(status: task.status, collected: task.collected, onCollect: collectRewards) // Pass collected
        }
    }
    
    var rewards: some View {
        HStack {
            RewardItem(icon: .waterDrop, value: task.waterPointReward)
            Spacer()
            RewardItem(icon: .gem, value: task.gemReward)
        }
    }
    
    func collectRewards() {
        guard let currencyModel = currencyModels.first else {
            print("No CurrencyModel found.")
            return
        }
        
        // Check if rewards have already been collected
        guard !task.collected else {
            print("Rewards already collected for this task.")
            return
        }
        
        // Add task rewards to the CurrencyModel
        currencyModel.waterPoints += task.waterPointReward
        currencyModel.gems += task.gemReward
        
        // Update task status to completed and mark as collected
        task.status = .completed
        task.collected = true
        
        do {
            try context.save()
            print("Rewards added successfully!")
        } catch {
            print("Failed to update CurrencyModel: \(error)")
        }
    }
    
    var simulateButton: some View {
        Group {
            if task.status == .inProgress {
                Button(action: incrementProgress) {
                    Text("Simulate: +\(task.goal / 2)")
                        .font(.caption2)
                        .padding(5)
                        .background(.customPink)
                        .foregroundColor(.white)
                        .cornerRadius(5)
                }
                .padding()
            }
        }
    }
    
    func incrementProgress() {
        let increment = task.goal / 2
        task.userProgress = min(task.userProgress + increment, task.goal)
        
        if task.userProgress >= task.goal {
            task.status = .collect
        }
        
        do {
            try context.save()
            print("Progress incremented by \(increment). New progress: \(task.userProgress)")
        } catch {
            print("Failed to update task progress: \(error)")
        }
    }
}

struct RewardItem: View {
    let icon: Icon
    let value: Int

    var body: some View {
        HStack(spacing: 3) {
            IconImage(icon: icon, height: 20, color: .waterBlue)
            Text("+ \(String(value))")
                .font(.rewards)
                .foregroundColor(.white)
        }
    }
}

struct TaskButton: View {
    var status: TaskStatus
    var collected: Bool
    var onCollect: () -> Void
    
    var body: some View {
        Button(action: handleCollect) {
            Text(collected ? "Collected" : status.rawValue)
                .font(.customBody)
                .frame(maxWidth: .infinity)
                .foregroundColor(buttonTextColor)
                .padding(10)
                .background(buttonBackgroundColor)
                .cornerRadius(10)
        }
        .disabled(isButtonDisabled)
    }
    
    private func handleCollect() {
        if status == .collect && !collected {
            onCollect()
        }
    }
    
    private var buttonBackgroundColor: Color {
        if collected {
            return Color.darkerGreen
        }
        switch status {
        case .inProgress:
            return Color.disabledDarkGrey
        case .collect:
            return Color.lightBlue
        case .completed:
            return Color.darkerGreen
        }
    }
    
    private var buttonTextColor: Color {
        if collected {
            return Color.lightGreen
        }
        switch status {
        case .inProgress:
            return Color.gray
        case .collect:
            return Color.darkerBlue
        case .completed:
            return Color.lightGreen
        }
    }
    
    private var isButtonDisabled: Bool {
        return collected || status == .inProgress || status == .completed
    }
}
