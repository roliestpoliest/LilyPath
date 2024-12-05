//
//  GenericStatsCard.swift
//  LilyPath
//
//  Created by Chelsea Nguyen on 12/5/24.
//

import SwiftUI

struct GenericStatsCard: View {
    let title: String
    let value: String
    let icon: Icon
    let showChevron: Bool
    
    init(
        title: String,
        value: String,
        icon: Icon,
        showChevron: Bool = false
    ) {
        self.title = title
        self.value = value
        self.icon = icon
        self.showChevron = showChevron
    }
    
    var body: some View {
        HStack {
            ZStack {
                IconImage(icon: icon, font: .statsIcon, color: .darkerBlue)
            }
            .frame(width: 55, height: 55)
            .background(Color.lightBlue)
            .cornerRadius(10)
            
            VStack(alignment: .leading) {
                Text("\(value) \(title.lowercased())")
                    .font(.statsCard)
                    .foregroundColor(.white)
                    .multilineTextAlignment(.leading)
            }
            
            Spacer()
            
            if showChevron {
                Image(systemName: "chevron.right")
                    .font(.statsCard)
                    .foregroundColor(.white)
            }
        }
        .padding(12)
        .frame(maxWidth: .infinity, maxHeight: 80)
        .background(Color.customBrown)
        .clipShape(RoundedRectangle(cornerRadius: 20))
    }
}

#Preview {
    GenericStatsCard(
        title: "Steps",
        value: "10,000",
        icon: .steps,
        showChevron: true
    )
}

