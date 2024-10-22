//
//  IconImage.swift
//  LilyPath
//
//  Created by Chelsea Nguyen on 10/5/24.
//

import SwiftUI

struct IconImage: View {
    let icon: Icon
    let color: Color
    let height: CGFloat?
    let font: Font?
    
    // init for resizable image
    init(icon: Icon, height: CGFloat, color: Color) {
        self.icon = icon
        self.color = color
        self.height = height
        self.font = nil
    }
    
    // init for sf symbol with font size
    init(icon: Icon, font: Font, color: Color) {
        self.icon = icon
        self.color = color
        self.font = font
        self.height = nil
    }
    
    var body: some View {
        let image: Image
        
        if UIImage(systemName: icon.rawValue) != nil {
            image = Image(systemName: icon.rawValue)
        } else {
            image = Image(icon.rawValue)
        }
        
        return Group {
            if let height = height {
                image
                    .resizable()
                    .scaledToFit()
                    .frame(height: height)
            } else if let font = font {
                image
                    .font(font)
            }
        }
        .foregroundColor(color)
    }
}
