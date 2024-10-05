//
//  PlantPopUp.swift
//  LilyPath
//
//  Created by Carolyn Heron on 10/5/24.
//

import SwiftUI

enum PopUpType: String {
    case purchase = "Purchase"
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
                        HStack{
                            Spacer()
                            Text("❌")
                        }
                    }
                    .padding()
                }
                .frame(maxWidth: 250, maxHeight: 50)
                
                HStack (spacing: 30){
                    Image(PlantModel.stageImages[4])
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .frame(width: 75, height: 75)

                    VStack(spacing: 15){
                        Text(PlantModel.species)
                            .font(Font.popupBody)
                            .foregroundColor(Color.customBrown)
                        Text("💎 \(PlantModel.price)")
                            .font(Font.popupDetails)
                            .foregroundColor(.white)
                            .padding(.vertical, 10)
                            .padding(.horizontal, 20)
                            .background(Color.customBrown)
                            .cornerRadius(20)
                            .shadow(color: .black.opacity(0.5), radius: 3, x: 0, y: 3)
                    }
                }
                .padding(32)
            }
            .padding()
            .background(Color.mainBackground)
            .cornerRadius(25)
            .overlay(
                RoundedRectangle(cornerRadius: 25)
                    .stroke(Color.customBrown, lineWidth: 5)
            )
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(Color.black.opacity(0.4)) // overlay effect
        .zIndex(1) // Ensure it stays on top of other views

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
