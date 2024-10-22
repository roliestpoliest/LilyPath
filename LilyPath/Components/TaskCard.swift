//
//  TaskCard.swift
//  LilyPath
//
//  Created by Chelsea Nguyen on 10/4/24.
//

import SwiftUI

struct TaskCard: View {
    @ObservedObject var task: TaskModel

    var body: some View {
        HStack(spacing: 16) {
            taskAndProgress

            rewardsAndTaskButton
        }
        .padding()
        .frame(height: 100)
        .background(Color.customBrown)
        .cornerRadius(20)
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

            TaskButton(status: $task.status)
        }
    }

    var rewards: some View {
        HStack {
            RewardItem(icon: .waterDrop, value: task.waterPointReward)
            Spacer()
            RewardItem(icon: .gem, value: task.gemReward)
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
    @Binding var status: TaskStatus

    var body: some View {
        Button(action: onCollect) {
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

    private var buttonBackgroundColor: Color {
        switch status {
        case .inProgress:
            return Color.greyDarkenBg
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

    func onCollect() {
        if status == .collect {
            // TODO: Add logic to reward user with points and gems
            status = .completed
        }
    }
}

#Preview {
    let sampleTask = TaskModel(
        type: .climb,
        goal: 12,
        waterPointReward: 1000,
        gemReward: 3,
        userProgress: 12,
        status: .collect
    )

    TaskCard(task: sampleTask)
        .padding(30)
        .background(Color.mainBackground)
}
