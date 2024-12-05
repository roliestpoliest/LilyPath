//
//  StatsCard.swift
//  LilyPath
//
//  Created by Chelsea Nguyen on 12/5/24.
//

import SwiftUI

struct StatsCard: View {
    let title: String
    let value: String
    let icon: Icon
    
    var body: some View {
        HStack {
            ZStack {
                IconImage(icon: icon, font: .statsIcon, color: .darkerBlue)
            }
            .frame(width: 55, height: 55)
            .background(Color.lightBlue)
            .cornerRadius(10)
            .padding(.leading, 10)
            
            VStack(alignment: .leading) {
                Text("\(value) \(title.lowercased())")
                    .font(.currentPlant)
                    .foregroundColor(.white)
            }
            .padding(.leading, 10)
            
            Spacer()
        }
        .padding(20)
        .frame(maxWidth: .infinity, minHeight: 110)
        .background(
            RoundedRectangle(cornerRadius: 20)
                .fill(Color.customBrown)
                .overlay(
                    RoundedRectangle(cornerRadius: 20)
                        .inset(by: 3)
                        .stroke(Color.darkerBlue, lineWidth: 6)
                )
        )
    }
}
