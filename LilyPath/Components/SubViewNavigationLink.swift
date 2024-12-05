//
//  SubViewNavigationLink.swift
//  LilyPath
//
//  Created by Chelsea Nguyen on 12/5/24.
//

import SwiftUI

struct SubViewNavigationLink<Destination: View, Content: View>: View {
    let title: String
    let destination: Destination
    let content: () -> Content
    let onAppearAction: (() -> Void)?

    init(
        title: String,
        destination: Destination,
        onAppearAction: (() -> Void)? = nil,
        @ViewBuilder content: @escaping () -> Content
    ) {
        self.title = title
        self.destination = destination
        self.content = content
        self.onAppearAction = onAppearAction
    }
    
    var body: some View {
        NavigationLink(destination: destination) {
            VStack(alignment: .leading, spacing: 10) {
                HStack {
                    ViewTitle(title: title)
                    
                    Spacer()
                    
                    Image(systemName: "chevron.right")
                }
                .font(.viewTitle)
                .foregroundColor(.customBrown)
                .frame(maxWidth: .infinity, alignment: .leading)
                
                content()
            }
        }
        .onAppear {
            onAppearAction?()
        }
    }
}
