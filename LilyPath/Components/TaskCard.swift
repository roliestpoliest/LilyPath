//
//  TaskCard.swift
//  LilyPath
//
//  Created by Chelsea Nguyen on 10/4/24.
//

import SwiftUI

struct TaskCard: View {
    @State var task: TaskModel
    @State var userProgress: Double = 0
    
    var body: some View {
        HStack (spacing: 16) {
            VStack {
                Spacer()
                
                Text(task.taskName)
                    .font(.customBody)
                    .foregroundColor(.white)
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .layoutPriority(1)
                ProgressBar(value: userProgress, total: Double(task.taskGoal))
            }
            
            VStack {
                HStack {
                    HStack (spacing: 3) {
                        IconImage(icon: .waterDrop, height: 20, color: .waterBlue)
                        
                        Text("+" + String(task.taskWaterPointsReward))
                            .font(.rewards)
                            .foregroundColor(.white)
                    }
                    
                    Spacer()
                    
                    HStack (spacing: 3) {
                        IconImage(icon: .gem, height: 20, color: .waterBlue)
                        
                        Text("+" + String(task.taskGemsReward))
                            .font(.rewards)
                            .foregroundColor(.white)
                    }
                }
                .padding(.horizontal)
                
                Button(action: {
                    print("Button pressed")
                }) {
                    Text("In Progress")
                        .font(.customBody)
                        .frame(maxWidth: .infinity)
                        .foregroundColor(.gray)
                        .padding(10)
                        .background(Color.greyDarkenBg)
                        .cornerRadius(10)
                }
            }
        }
        .padding()
        .frame(width: .infinity, height: 100)
        .background(Color.customBrown)
        .cornerRadius(20)
        .shadow(radius: 3, y: 5)
    }
}


#Preview {
    TaskCard(task: generateRandomTasks()[0], userProgress: [5000, 5, 5, 2][0])
        .padding()
}
