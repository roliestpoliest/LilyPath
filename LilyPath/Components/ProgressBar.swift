//
//  ProgressBar.swift
//  LilyPath
//
//  Created by Carolyn Heron on 10/6/24.
//

import SwiftUI

struct ProgressBar: View {
    var value: Double
    var total: Double
    var frameHeight: CGFloat = 12
    var foregroundColor: Color = .darkGreen
    var backgroundColor: Color = .lightGreen
    var applyShadow: Bool = false
    
    var body: some View {
        GeometryReader { geometry in
            let padding = frameHeight * 0.4
            let cornerRadius = frameHeight / 2
            
            ZStack(alignment: .leading) {
                // Background bar
                RoundedRectangle(cornerRadius: cornerRadius)
                    .fill(backgroundColor)
                    .frame(height: frameHeight)
                    .shadow(
                        radius: applyShadow ? ShadowConstants.radius : 0,
                        y: applyShadow ? ShadowConstants.yOffset : 0)
                
                // Foreground bar
                RoundedRectangle(cornerRadius: (frameHeight - padding) / 2)
                    .fill(foregroundColor)
                    .frame(
                        width: max(0, min(
                            geometry.size.width * CGFloat(value / max(total, 1)),
                            geometry.size.width - padding // Account for padding
                        )),
                        height: frameHeight - padding
                    )
                    .padding(.leading, padding / 2)
            }
        }
        .frame(height: frameHeight)
    }
}

#Preview {
    VStack {
        ProgressBar(value: 25, total: 100, frameHeight: 30)
        ProgressBar(value: 25, total: 100, frameHeight: 20)
        ProgressBar(
            value: 25, total: 100,
            foregroundColor: .darkerBlue,
            backgroundColor: .lightBlue)
        ProgressBar(value: 50, total: 100)
        ProgressBar(value: 75, total: 100)
        ProgressBar(value: 100, total: 100)
        ProgressBar(value: 1, total: 1)
        ProgressBar(value: 2, total: 1)
    }
    .padding()
}
