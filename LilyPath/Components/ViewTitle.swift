//
//  ViewTitle.swift
//  LilyPath
//
//  Created by Chelsea Nguyen on 10/4/24.
//

import SwiftUI

struct ViewTitle: View {
    @State var title: String
    
    var body: some View {
        Text(title)
            .font(.viewTitle)
            .foregroundColor(.customBrown)
            .frame(maxWidth: .infinity, alignment: .leading)
            .padding(.vertical)
    }
}
