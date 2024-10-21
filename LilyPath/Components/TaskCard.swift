//
//  TaskCard.swift
//  LilyPath
//
//  Created by Chelsea Nguyen on 10/4/24.
//

import SwiftUI

struct TaskCard: View {
    @StateObject var task: TaskModel
    
    var body: some View {
        HStack (spacing: 16) {
            VStack {
                Spacer()
                
                Text(task.taskName)
                    .font(.customBody)
                    .foregroundColor(.white)
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .layoutPriority(1)
                
                ProgressBar(value: Double(task.userProgress), total: Double(task.goal), frameHeight: 11)
            }
            
            VStack {
                HStack {
                    HStack (spacing: 3) {
                        IconImage(icon: .waterDrop, height: 20, color: .waterBlue)
                        
                        Text("+ \(String(task.waterPointReward))")
                            .font(.rewards)
                            .foregroundColor(.white)
                    }
                    
                    Spacer()
                    
                    HStack (spacing: 3) {
                        IconImage(icon: .gem, height: 20, color: .waterBlue)
                        
                        Text("+ \(task.gemReward)")
                            .font(.rewards)
                            .foregroundColor(.white)
                    }
                }
                .padding(.horizontal)
                
                TaskButton(status: $task.status)
            }
        }
        .padding()
        .frame(height: 100)
        .background(Color.customBrown)
        .cornerRadius(20)
    }
}

#Preview {
    TaskCard(task: TaskModel(type: .climb, goal: 12000, waterPointReward: 1000, gemReward: 3, userProgress: 10000, status: TaskModel.TaskStatus.collect))
        .padding(30)
        .background(Color.mainBackground)
}
