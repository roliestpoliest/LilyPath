//
//  DailyTasksView.swift
//  LilyPath
//
//  Created by Chelsea Nguyen on 10/3/24.
//

import SwiftUI

struct DailyTasksView: View {
    // TODO: figure out  how to randomize once a day
    @State var tasks: [TaskModel]
    // TODO: Replace with user's actual progress
    @State var userProgess: [Double]
    
    var body: some View {
        VStack {
            ViewTitle(title: "Daily Tasks")
                        
            ScrollView(showsIndicators: false) {
                ForEach(tasks.indices, id: \.self) { index in
                    TaskCard(task: tasks[index], userProgress: userProgess[index])
                        .padding(.vertical, 8)
                }
                ForEach(tasks.indices, id: \.self) { index in
                    TaskCard(task: tasks[index], userProgress: userProgess[index])
                        .padding(.vertical, 8)
                }
            }
            .shadow(radius: 3, y: 5)
            
            Spacer()
        }
    }
}

#Preview {
    return DailyTasksView(tasks: generateRandomTasks(), userProgess: [5000, 5, 6, 0])
        .padding(.horizontal, 30)
        .background(Color.mainBackground)
}
