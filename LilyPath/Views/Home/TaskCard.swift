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
        .overlay(debugButton, alignment: .bottomTrailing) // Add the debug button
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
            
            TaskButton(status: task.status, onCollect: collectRewards)
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
        
        // Add task rewards to the CurrencyModel
        currencyModel.waterPoints += task.waterPointReward
        currencyModel.gems += task.gemReward
        
        // Update task status to completed
        task.status = .completed
        
        do {
            try context.save()
            print("Rewards added successfully!")
        } catch {
            print("Failed to update CurrencyModel: \(error)")
        }
    }
    
    var debugButton: some View {
        Group {
            if task.status == .inProgress {
                Button(action: incrementProgress) {
                    Text("Debug: +\(task.goal / 3)")
                        .font(.caption)
                        .padding(5)
                        .background(Color.orange)
                        .foregroundColor(.white)
                        .cornerRadius(5)
                }
                .padding()
            }
        }
    }
    
    func incrementProgress() {
        let increment = task.goal / 3
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
    var onCollect: () -> Void
    
    var body: some View {
        Button(action: handleCollect) {
            Text(status.rawValue)
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
        if status == .collect {
            onCollect()
        }
    }
    
    private var buttonBackgroundColor: Color {
        switch status {
        case .inProgress:
            return Color.lockGrey.opacity(0.3)
        case .collect:
            return Color.lightBlue
        case .completed:
            return Color.darkerGreen
        }
    }
    
    private var buttonTextColor: Color {
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
        return status == .inProgress || status == .completed
    }
}

//struct TaskListView: View {
//    @Query private var tasks: [TaskModel]
//    @Query private var currencyModels: [CurrencyModel]
//    
//    var body: some View {
//        List {
//            ForEach(tasks) { task in
//                TaskCard(task: task)
//            }
//        }
//    }
//}

//#Preview {
//    let sampleTask = TaskModel(
//        type: .climb,
//        goal: 12,
//        waterPointReward: 1000,
//        gemReward: 3,
//        userProgress: 12,
//        status: .collect
//    )
//
//    TaskCard(task: sampleTask)
//        .padding(30)
//        .background(Color.mainBackground)
//}
