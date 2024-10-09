//
//  ViewTitle.swift
//  LilyPath
//
//  Created by Chelsea Nguyen on 10/4/24.
//

import SwiftUI

struct ViewTitle: View {
    let title: String
    var isNavTitle: Bool = false
    
    var body: some View {
        Text(title)
            .font(.viewTitle)
            .foregroundColor(.customBrown)
            .frame(maxWidth: .infinity, alignment: .leading)
            .padding(.vertical)
            .padding(.top, isNavTitle ? 40 : 0)
    }
}

#Preview {
    ViewTitle(title: "View Title")
        .background(Color.mainBackground)
    
    ViewTitle(title: "Nav View Title", isNavTitle: true)
        .background(Color.mainBackground)
}
