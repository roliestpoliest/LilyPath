//
//  ViewTitle.swift
//  LilyPath
//
//  Created by Chelsea Nguyen on 10/4/24.
//

import SwiftUI

struct ViewTitle: View {
    let title: String
    
    var body: some View {
        Text(title)
            .font(.viewTitle)
            .foregroundColor(.customBrown)
            .frame(maxWidth: .infinity, alignment: .leading)
            .padding(.vertical)
    }
}

#Preview {
    ViewTitle(title: "View Title")
        .background(Color.mainBackground)
}
