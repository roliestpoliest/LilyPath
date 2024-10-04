//
//  DailyTasksView.swift
//  LilyPath
//
//  Created by Chelsea Nguyen on 10/3/24.
//

import SwiftUI

struct DailyTasksView: View {
    @State private var rewardWaterPoints: Int = 1000
    @State private var rewardGems: Int = 3
    // TODO: figure out  how to randomize once a day
    @State private var tasks: [TaskModel] = generateRandomTasks()
    // TODO: Replace with user's actual progress
    @State private var userProgess: [Double] = [5000, 5, 5, 2]
    
    var body: some View {
        VStack {
            ViewTitle(title: "Daily Tasks")
                        
            ForEach(tasks.indices, id: \.self) { index in
                TaskCard(task: tasks[index], userProgress: userProgess[index])
                    .padding(.vertical, 8)
            }
            
            Spacer()
        }
    }
}

#Preview {
    DailyTasksView()
        .padding(.horizontal, 30)
        .background(Color.mainBackground)
}
