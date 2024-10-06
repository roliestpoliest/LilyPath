//
//  PlantPopUp.swift
//  LilyPath
//
//  Created by Carolyn Heron on 10/5/24.
//

import SwiftUI

enum PopUpType: String {
    case purchase = "Purchase"
    case locked = "Womp Womp"
    case wilt = "Uh oh!"
    case levelUp = "Level Up!"
}

struct PlantPopUp: View {
    @State private var showPopOver = true
    
    var PopUpType: PopUpType
    var PlantModel: BasePlantModel
    
    var body: some View {
        ZStack {
            VStack {
                ZStack {
                    UnevenRoundedRectangle(topLeadingRadius: 17, bottomLeadingRadius: 0, bottomTrailingRadius: 0, topTrailingRadius: 17)
                        .fill(Color.customPink)
                        .shadow(color: .black.opacity(0.5), radius: 3, x: 0, y: 3)
                    
                    ZStack {
                        Text(PopUpType.rawValue.uppercased())
                            .font(Font.popupTitle)
                            .foregroundColor(Color.customBrown)
                        
                        HStack {
                            Spacer()
                            IconImage(icon: .x, height: 20, color: .darkPink)
                        }
                    }
                    .padding()
                }
                .frame(height: 50)
                
                HStack (spacing: 30) {
                    Image(PlantModel.stageImages[4])
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .frame(width: 75, height: 75)
                    
                    VStack(spacing: 15) {
                        Text(PlantModel.species)
                            .font(Font.popupBody)
                            .foregroundColor(Color.customBrown)
                        
                        HStack(spacing: 10) {
                            IconImage(icon: .gem, height: 20, color: .waterBlue)
                            
                            Text(String(PlantModel.price))
                                .font(.popupDetails)
                                .foregroundColor(.white)
                            
                        }
                        .padding(.vertical, 10)
                        .padding(.horizontal, 20)
                        .background(Color.customBrown)
                        .cornerRadius(20)
                        .shadow(color: .black.opacity(0.5), radius: 3, x: 0, y: 3)
                        
                    }
                }
                .padding(32)
            }
            .frame(width: 275, height: 200)
            .padding()
            .background(Color.mainBackground)
            .cornerRadius(25)
            .overlay(
                RoundedRectangle(cornerRadius: 25)
                    .stroke(Color.customBrown, lineWidth: 5)
            )
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(Color.black.opacity(0.4))
        .zIndex(1)
        
    }
}

#Preview {
    ZStack {
        PlantShopView(plants: [
            BasePlantModel.lily,
            BasePlantModel.delphinium,
            BasePlantModel.buttercup,
            BasePlantModel.rose,
            BasePlantModel.chamomile,
            BasePlantModel.petunia,
            BasePlantModel.carnation,
            BasePlantModel.lotus
        ])
        .padding(.horizontal, 30)
        .background(Color.mainBackground)
        
        
        PlantPopUp(PopUpType: PopUpType.purchase, PlantModel: BasePlantModel.delphinium)
    }
}
