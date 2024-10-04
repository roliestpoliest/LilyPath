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
                
                ProgressView(value: userProgress, total: Double(task.taskGoal))
                    .progressViewStyle(LinearProgressViewStyle(tint: .darkGreen))
                    .scaleEffect(x: 1, y: 2, anchor: .center)
                    .frame(maxWidth: .infinity, maxHeight: 12)
                    .padding(.horizontal, 2)
                    .background(Color.lightGreen)
                    .cornerRadius(10)
            }
            
            VStack {
                HStack {
                    HStack (spacing: 3) {
                        Image(systemName: "drop.fill")
                            .resizable()
                            .scaledToFit()
                            .frame(height: 20)
                            .foregroundColor(.waterBlue)
                        
                        Text("+" + String(task.taskWaterPointsReward))
                            .font(.rewards)
                            .foregroundColor(.white)
                    }
                    
                    Spacer()
                    
                    HStack (spacing: 3) {
                        Image("Gem")
                            .resizable()
                            .scaledToFit()
                            .frame(height: 20)
                            .foregroundColor(.gray)
                        
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
