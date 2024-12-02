//
//  DailyTasksView.swift
//  LilyPath
//
//  Created by Chelsea Nguyen on 10/3/24.
//

import SwiftUI
import SwiftData

struct DailyTasksView: View {
    @Query(sort: [SortDescriptor(\TaskModel.timestamp, order: .forward)]) var tasks: [TaskModel]
    @Environment(\.modelContext) private var modelContext
    @State private var lastGeneratedDate: Date = UserDefaults.standard.object(forKey: "lastGeneratedDate") as? Date ?? Date.distantPast
    
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
            generateTasksIfNeeded()
        }
    }
    
    private func generateTasksIfNeeded() {
        let currentDate = Calendar.current.startOfDay(for: Date())
        
        if Calendar.current.isDate(lastGeneratedDate, inSameDayAs: currentDate) {
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
            UserDefaults.standard.set(lastGeneratedDate, forKey: "lastGeneratedDate")
            print("New tasks saved successfully on", currentDate)
        } catch {
            print("Failed to save new tasks: \(error)")
        }
    }
}

#Preview {
    return DailyTasksView()
        .padding(.horizontal, 30)
}
