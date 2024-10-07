//
//  PlantPopUp.swift
//  LilyPath
//
//  Created by Carolyn Heron on 10/5/24.
//

import SwiftUI

// TODO: disable view behind the pop
// TODO: blur/darken background
// TODO: add popup functionality

enum PopUpType: String {
    case purchase = "Purchase"
    case locked = "Womp Womp"
    case wilt = "Uh oh!"
    case levelUp = "Level Up!"
}

struct PlantPopUp: View {
    @State private var showPopUp = true
    
    var popUpType: PopUpType
    var plantModel: BasePlantModel
    
    var body: some View {
        ZStack {
            //            Color.black.opacity(0.4)
            //                .edgesIgnoringSafeArea(.all)
            //                .allowsHitTesting(false) // Disable interactions with the background
            
            VStack {
                pinkHeader
                
                Spacer()
                switch popUpType {
                case .purchase:
                    HStack (spacing: 30) {
                        plantImage(image: plantModel.stageImages[4])
                        
                        VStack(spacing: 15) {
                            Text(plantModel.species)
                                .font(Font.popupBody)
                                .foregroundColor(Color.customBrown)
                            
                            actionButton(text: String(plantModel.price), icon: .gem){
                                print("Purchase button tapped")
                            }
                            
                        }
                    }
                case .locked:
                    HStack (spacing: 20) {
                        plantImage(image: plantModel.stageImages[4])
                        
                        VStack(alignment: .center, spacing: 15) {
                            Text("\(plantModel.species) is locked!\nUnlock at level \(plantModel.requiredLevelToBuy)")
                                .multilineTextAlignment(.center)
                                .font(Font.popupBody)
                                .foregroundColor(Color.customBrown)
                        }
                    }
                    
                case .wilt:
                    HStack (spacing: 10) {
                        plantImage(image: plantModel.stageImages[4])
                            .brightness(0.15)
                            .saturation(0.4)
                            .colorMultiply(Color(hex: "bd8b68"))

                        
                        VStack(spacing: 15) {
                            Text("Your \(plantModel.species) is wilting!")
                                .multilineTextAlignment(.center)
                                .font(Font.popupBody)
                                .foregroundColor(Color.customBrown)
                            
                            actionButton(text: "-1000", secondText: "Revive?", icon: .waterDrop) {
                                print("Revive button tapped")
                            }
                        }
                    }
                    
                case .levelUp:
                    HStack (spacing: 10) {
                        plantImage(image: plantModel.stageImages[4])
                        
                        VStack(spacing: 15) {
                            Text("Your \(plantModel.species) is growing!")
                                .multilineTextAlignment(.center)
                                .font(Font.popupBody)
                                .foregroundColor(Color.customBrown)
                            
                            actionButton(text: "+1", icon: .gem){
                                print("Level Up button tapped")
                            }
                        }
                    }
                    
                }
                Spacer()
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
        //        .frame(maxWidth: .infinity, maxHeight: .infinity)
        //        .background(Color.black.opacity(0.4))
        .zIndex(1)
    }
    
    private var pinkHeader: some View {
        ZStack {
            UnevenRoundedRectangle(topLeadingRadius: 17, bottomLeadingRadius: 0, bottomTrailingRadius: 0, topTrailingRadius: 17)
                .fill(Color.customPink)
                .shadow(color: .black.opacity(0.5), radius: 3, x: 0, y: 3)
            ZStack {
                Text(popUpType.rawValue.uppercased())
                    .font(Font.popupTitle)
                    .foregroundColor(Color.customBrown)
                
                HStack {
                    Spacer()
                    Button(action: {
                        print("Close button tapped")
                        showPopUp.toggle()
                    }) {
                        IconImage(icon: .x, height: 20, color: .darkPink)
                    }
                }
            }
            .padding()
        }
        .frame(height: 50)
    }
    
    private func plantImage(image: String) -> some View {
        Image(image)
            .resizable()
            .aspectRatio(contentMode: .fit)
            .frame(width: 75, height: 75)
        
    }
    
    private func actionButton(text: String, secondText: String? = nil, icon: Icon, action: @escaping () -> Void) -> some View {
        Button(action: action) {
            HStack(spacing: 10) {
                if let secondText = secondText {
                    Text(secondText)
                        .font(.popupDetails)
                        .foregroundColor(.white)
                }
                IconImage(icon: icon, height: 20, color: .waterBlue)
                Text(text)
                    .font(.popupDetails)
                    .foregroundColor(.white)
            }
            .padding(.vertical, 10)
            .padding(.horizontal, 20)
            .background(Color.customBrown)
        }
        .clipShape(Capsule())
        .shadow(color: .black.opacity(0.5), radius: 3, x: 0, y: 3)
        .buttonStyle(PlainButtonStyle())
    }
}

#Preview {
    ZStack{
        //        The main PlantShopView
        //        PlantShopView(plants: [
        //            BasePlantModel.lily,
        //            BasePlantModel.delphinium,
        //            BasePlantModel.buttercup,
        //            BasePlantModel.rose,
        //            BasePlantModel.chamomile,
        //            BasePlantModel.petunia,
        //            BasePlantModel.carnation,
        //            BasePlantModel.lotus
        //        ])
        //        .padding(.horizontal, 30)
        //        .background(Color.mainBackground)
        
        ScrollView (showsIndicators: false) {
            VStack {
                PlantPopUp(popUpType: PopUpType.purchase, plantModel: BasePlantModel.delphinium)
                    .frame(height: 250)
                PlantPopUp(popUpType: PopUpType.locked, plantModel: BasePlantModel.delphinium)
                    .frame(height: 250)
                PlantPopUp(popUpType: PopUpType.wilt, plantModel: BasePlantModel.lavender)
                    .frame(height: 250)
                PlantPopUp(popUpType: PopUpType.levelUp, plantModel: BasePlantModel.delphinium)
                    .frame(height: 250)
            }
            .padding(.horizontal)
        }
    }
}
