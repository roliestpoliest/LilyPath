//
//  PlantCard.swift
//  LilyPath
//
//  Created by Carolyn Heron on 10/2/24.
//

import SwiftUI

struct PlantCard: View {
    var plantName: String
    var plantImage: String
    var locked: Bool
    
    var body: some View {        
        VStack {
            ZStack (alignment:.center){
                Rectangle()
                    .fill(Color.customBrown)
                    .cornerRadius(15)
                
                VStack {
                    Spacer()
                    
                    ZStack{
                        UnevenRoundedRectangle(topLeadingRadius: 8, bottomLeadingRadius: 0, bottomTrailingRadius: 0, topTrailingRadius: 8)
                            .fill(Color.lightBlue)
                        
                        Image(plantImage)
                            .resizable()
                            .aspectRatio(contentMode: .fit)
                            .frame(width: 62, height: 62)
                        
                        UnevenRoundedRectangle(topLeadingRadius: 8, bottomLeadingRadius: 0, bottomTrailingRadius: 0, topTrailingRadius: 8)
                            .colorMultiply(Color.lockGrey.opacity(locked ? 0.3 : 0.0))
                    }
                    
                    .frame(width: 125, height: 125)
                    
                    Spacer()
                    
                    HStack {
                        if locked { Image(systemName: "lock.fill") }
                        Text(plantName)
                    }
                    .font(Font.statsCard)
                    .foregroundStyle(.white)
                    .bold()
                    
                    Spacer()
                }
            }
            .frame(width: 150, height: 180)
        }
    }
}

#Preview {
    PlantCard(plantName: "Delphinium", plantImage: "Delphinium Stage 5", locked: true)
}
