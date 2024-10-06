//
//  IconImage.swift
//  LilyPath
//
//  Created by Chelsea Nguyen on 10/5/24.
//

import SwiftUI

struct IconImage: View {
    let icon: Icon
    let height: CGFloat
    let color: Color

    var body: some View {
        let image: Image
        
        if let _ = UIImage(systemName: icon.rawValue) {
            image = Image(systemName: icon.rawValue)
        } else {
            image = Image(icon.rawValue)
        }
        
        return image
            .resizable()
            .scaledToFit()
            .frame(height: height)
            .foregroundColor(color)
    }
}
