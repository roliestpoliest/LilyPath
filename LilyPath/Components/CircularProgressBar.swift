//
//  CircularProgressBar.swift
//  LilyPath
//
//  Created by Chelsea Nguyen on 10/7/24.
//

import SwiftUI

struct CircularProgressBar: View {
    var value: Double
    var total: Double
    var lineWidth: CGFloat = 16

    var body: some View {
        ZStack {
            Circle()
                .stroke(
                    Color.lightGreen,
                    lineWidth: lineWidth
                )
                .shadow(
                    radius: ShadowConstants.radius,
                    y: ShadowConstants.yOffset
                )

            Circle()
                .trim(from: 0, to: (value / total))
                .stroke(
                    Color.darkGreen,
                    style: StrokeStyle(
                        lineWidth: lineWidth,
                        lineCap: .round
                    )
                )
                .rotationEffect(.degrees(-90))
        }
    }
}

#Preview {
    CircularProgressBar(value: 25, total: 100)
        .padding(30)
}
