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
            
            // TODO: remove, using to generate for testing
            HStack {
                Button(action: {
                    generateTasks()
                }) {
                    Text("Generate Tasks")
                        .font(.customBody)
                        .foregroundColor(.white)
                        .padding(.vertical, 8)
                        .padding(.horizontal, 16)
                        .background(Color.customBrown)
                        .cornerRadius(10)
                }
                
                Group {
                    if tasks.isEmpty {
                        Text("No tasks available")
                            .font(.customBody)
                            .foregroundColor(.customBrown)
                            .padding(.top, 20)
                    } else {
                        Text("Tasks: \(tasks.count)")
                            .font(.customBody)
                            .foregroundColor(.customBrown)
                            .padding(.top, 20)
                    }
                }
            }
            
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
            print("Daily Tasks View appeared, checking for existing tasks...")
            loadTasksFromDatabase()
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

        print("New tasks generated")
        do {
            try modelContext.save()
            lastGeneratedDate = currentDate
            UserDefaults.standard.set(lastGeneratedDate, forKey: "lastGeneratedDate")
            print("New tasks saved successfully on", currentDate)
        } catch {
            print("Failed to save new tasks: \(error)")
        }
    }
    
    // TODO: remove, using to generate for testing
    private func generateTasks() {
        let currentDate = Calendar.current.startOfDay(for: Date())

        for task in tasks {
            modelContext.delete(task)
        }

        let newTasks = generateRandomTasks()
        for task in newTasks {
            task.timestamp = Date()
            modelContext.insert(task)
        }

        print("New tasks generated")
        do {
            try modelContext.save()
            lastGeneratedDate = currentDate
            UserDefaults.standard.set(lastGeneratedDate, forKey: "lastGeneratedDate")
            print("New tasks saved successfully on", currentDate)

            let fetchDescriptor = FetchDescriptor<TaskModel>()
            let savedTasks = try modelContext.fetch(fetchDescriptor)
            print("Saved tasks in DB:", savedTasks.map { $0.id.uuidString })
        } catch {
            print("Failed to save new tasks: \(error)")
        }
    }
    
    // TODO: remove, using to generate for testing
    private func loadTasksFromDatabase() {
        do {
            let fetchDescriptor = FetchDescriptor<TaskModel>(sortBy: [SortDescriptor(\.timestamp)])
            let fetchedTasks = try modelContext.fetch(fetchDescriptor)
            print("Loaded tasks from DB:", fetchedTasks.map { "\($0.id.uuidString) goal: \($0.goal)" })
        } catch {
            print("Failed to load tasks from DB:", error)
        }
    }
}

#Preview {
    return DailyTasksView()
        .padding(.horizontal, 30)
}
