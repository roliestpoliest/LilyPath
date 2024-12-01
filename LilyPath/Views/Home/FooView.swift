//
//  FooView.swift
//  LilyPath
//
//  Created by Carolyn Heron on 12/1/24.
//

import SwiftUI
import SwiftData

struct FooView: View {
//    @Environment(\.modelContext) private var context
//    @Query(sort: \TaskModelDB.createdAt, order: .forward) private var tasks: [TaskModelDB]
//    var body: some View {
//        VStack {
//            Text("Tap on this button to add data")
//            Button("Add an Item") {
//                addItem()
//            }
//            
//            List {
//                ForEach(tasks) { item in
//                    HStack {
//                        Text(item.name)
//                        Spacer()
//                        Button{
//                            updateItem(item)
//                        } label: {
//                            Image(systemName: "arrow.2.circlepath")
//                        }
//                    }
//                }
//                .onDelete { indexes in
//                    for index in indexes {
//                        deleteItem(tasks[index])
//                    }
//                }
//            }
//        }
//    }
    @Environment(\.modelContext) private var context
    @Query private var tasks: [TaskModel]
    
    var body: some View {
        VStack {
            Button("Generate New Tasks") {
                generateTasks()
            }
            
            List(tasks) { task in
                VStack(alignment: .leading) {
                    Text(task.type)
                    Text("Goal: \(task.goal)")
                    Text("Progress: \(task.userProgress) / \(task.goal)")
                    Text("Status: \(task.status)")
                }
            }
        }
    }
    
    private func generateTasks() {
        // Generate new tasks
        let manager = TaskManager()
        manager.generateNewTasks()
    }

    
//    func addItem() {
//        let item = TaskModelDB(name: "Test item")
//        context.insert(item)
//        try? context.save()
//    }
//    
//    func deleteItem(_ item: TaskModelDB) {
//        context.delete(item)
//    }
//    
//    func updateItem(_ item: TaskModelDB) {
//        item.name = "Updated item"
//        
//        try? context.save()
//    }
}

#Preview {
    FooView()
}
