//
//  TaskButton.swift
//  LilyPath
//
//  Created by Chelsea Nguyen on 10/5/24.
//

import SwiftUI

struct TaskButton: View {
    @Binding var status: TaskModel.TaskStatus

    var body: some View {
        Button(action: {
            if status == .collect {
                onCollect()
            }
        }) {
            Text(status.rawValue)
                .font(.customBody)
                .frame(maxWidth: .infinity)
                .foregroundColor(buttonTextColor)
                .padding(10)
                .background(buttonBackgroundColor)
                .cornerRadius(10)
        }
        .disabled(isButtonDisabled)
    }

    private var buttonBackgroundColor: Color {
        switch status {
        case .inProgress:
            return Color.greyDarkenBg
        case .collect:
            return Color.lightBlue
        case .completed:
            return Color.darkerGreen
        }
    }

    private var buttonTextColor: Color {
        switch status {
        case .inProgress:
            return Color.gray
        case .collect:
            return Color.darkerBlue
        case .completed:
            return Color.lightGreen
        }
    }

    private var isButtonDisabled: Bool {
        return status == .inProgress || status == .completed
    }
    
    func onCollect() {
        status = .completed
    }
}
