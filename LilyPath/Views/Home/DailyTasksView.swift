//
//  DailyTasksView.swift
//  LilyPath
//
//  Created by Chelsea Nguyen on 10/3/24.
//

import SwiftUI

struct DailyTasksView: View {
    // TODO: figure out how to randomize once a day
    @State var tasks: [TaskModel]
    
    var body: some View {
        VStack {
            ViewTitle(title: "Daily Tasks")
            
            ScrollView(showsIndicators: false) {
                ForEach(tasks.indices, id: \.self) { index in
                    TaskCard(task: tasks[index])
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
    let tasks = [
        TaskModel(
            type: .walk, goal: 15000, waterPointReward: 2000, gemReward: 4,
            userProgress: 1, status: .collect),
        TaskModel(
            type: .climb, goal: 20, waterPointReward: 1500, gemReward: 3,
            userProgress: 2),
        TaskModel(
            type: .sleep, goal: 8, waterPointReward: 1400, gemReward: 2,
            userProgress: 3, status: .completed),
        TaskModel(
            type: .stand, goal: 4, waterPointReward: 1000, gemReward: 1,
            userProgress: 4, status: .collect),
    ]
    
    return DailyTasksView(tasks: tasks)
        .padding(.horizontal, 30)
    
    //    return DailyTasksView(tasks: generateRandomTasks())
    //        .padding(.horizontal, 30)
    //        .background(Color.mainBackground)
}
