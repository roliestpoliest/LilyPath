//
//  TimePeriodPicker.swift
//  LilyPath
//
//  Created by Chelsea Nguyen on 10/21/24.
//

import SwiftUI

enum TimePeriod: String, CaseIterable {
    case daily = "Daily"
    case weekly = "Weekly"
    case monthly = "Monthly"
}

struct TimePeriodPicker: View {
    @Binding var selectedTimePeriod: TimePeriod
    var options: [TimePeriod] = TimePeriod.allCases
    
    let color = Color.darkGreen
    
    var body: some View {
        HStack(spacing: 0) {
            ForEach(options.indices, id: \.self) { index in
                ZStack {
                    Rectangle()
                        .fill(Color.lightGreen)
                    
                    Rectangle()
                        .fill(
                            selectedTimePeriod == options[index]
                            ? Color.darkGreen : Color.lightGreen
                        )
                        .cornerRadius(12)
                        .padding(5)
                    
                    Text(options[index].rawValue)
                        .font(Font.label)
                        .foregroundColor(
                            selectedTimePeriod == options[index]
                            ? .white : Color.customBrown
                        )
                        .onTapGesture {
                            withAnimation(.interactiveSpring()) {
                                selectedTimePeriod = options[index]
                            }
                        }
                }
            }
        }
        .frame(height: 40)
        .cornerRadius(15)
    }
}

#Preview {
    TimePeriodPicker(selectedTimePeriod: .constant(.daily))
        .padding(30)
        .background(Color.mainBackground)
}
