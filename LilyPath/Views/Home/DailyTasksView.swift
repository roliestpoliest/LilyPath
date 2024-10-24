//
//  DailyTasksView.swift
//  LilyPath
//
//  Created by Chelsea Nguyen on 10/3/24.
//

import SwiftUI

struct DailyTasksView: View {
    // TODO: figure out how to randomize once a day
    @ObservedObject var taskManager: TaskManager = TaskManager.shared

    var body: some View {
        VStack {
            UserCurrencyBar()

            ViewTitle(title: "Daily Tasks")

            ScrollView(showsIndicators: false) {
                ForEach(taskManager.tasks.indices, id: \.self) { index in
                    TaskCard(task: taskManager.tasks[index])
                        .padding(.vertical, 8)
                }
            }
            .shadow(radius: ShadowConstants.radius, y: ShadowConstants.yOffset)

            Spacer()
        }
        .background(Color.mainBackground)
    }
}

#Preview {
    return DailyTasksView()
        .padding(.horizontal, 30)
}
