//
//  PlantCard.swift
//  LilyPath
//
//  Created by Carolyn Heron on 10/2/24.
//

//import SwiftUI
//
//struct PlantShopCard: View {
//    var plantModel: BasePlantModel
//    
//    @ObservedObject var userModel = UserModel.shared
//    
//    // TODO: remove on implementation
//    var isLocked: Bool {
//        return false
//    }
//    
//    var body: some View {
//        VStack {
//            ZStack(alignment: .center) {
//                Rectangle()
//                    .fill(Color.customBrown)
//                    .cornerRadius(15)
//                
//                VStack {
//                    Spacer()
//                    
//                    ZStack {
//                        UnevenRoundedRectangle(topLeadingRadius: 8, bottomLeadingRadius: 0, bottomTrailingRadius: 0, topTrailingRadius: 8)
//                            .fill(Color.lightBlue)
//                        
//                        Image(plantModel.stageImages[4])
//                            .resizable()
//                            .aspectRatio(contentMode: .fit)
//                            .frame(width: 62, height: 62)
//                        
//                        UnevenRoundedRectangle(topLeadingRadius: 8, bottomLeadingRadius: 0, bottomTrailingRadius: 0, topTrailingRadius: 8)
//                            .colorMultiply(Color.lockGrey.opacity(isLocked ? 0.4 : 0.0))
//                    }
//                    .frame(width: 125, height: 125)
//                    
//                    Spacer()
//                    
//                    HStack {
//                        if isLocked { Image(systemName: "lock.fill") }
//                        Text(plantModel.species)
//                    }
//                    .font(Font.statsCard)
//                    .foregroundStyle(.white)
//                    .bold()
//                    
//                    Spacer()
//                }
//            }
//            .frame(width: 150, height: 180)
//        }
//        .contentShape(Rectangle())
//    }
//}
//
//#Preview {
//    VStack {
//        HStack {
//            PlantShopCard(plantModel: BasePlantModel.lily, userModel: UserModel.shared)
//            Spacer()
//            PlantShopCard(plantModel: BasePlantModel.lily, userModel: UserModel.shared)
//        }
//        HStack{
//            PlantShopCard(plantModel: BasePlantModel.lavender, userModel: UserModel.shared)
//            Spacer()
//            PlantShopCard(plantModel: BasePlantModel.lavender, userModel: UserModel.shared)
//        }
//        HStack{
//            PlantShopCard(plantModel: BasePlantModel.delphinium, userModel: UserModel.shared)
//            Spacer()
//            PlantShopCard(plantModel: BasePlantModel.delphinium, userModel: UserModel.shared)
//        }
//    }
//    .padding(30)
//}

import SwiftUI
import SwiftData

struct PlantShopCard: View {
    var plantModel: BasePlantModel
    
    @Query private var currencyModels: [CurrencyModel] // Fetch CurrencyModel
    
    // Determine if the plant is locked based on some condition
    var isLocked: Bool {
        return false
    }
    
    var body: some View {
        VStack {
            ZStack(alignment: .center) {
                Rectangle()
                    .fill(Color.customBrown)
                    .cornerRadius(15)
                
                VStack {
                    Spacer()
                    
                    ZStack {
                        UnevenRoundedRectangle(topLeadingRadius: 8, bottomLeadingRadius: 0, bottomTrailingRadius: 0, topTrailingRadius: 8)
                            .fill(Color.lightBlue)
                        
                        Image(plantModel.stageImages[4])
                            .resizable()
                            .aspectRatio(contentMode: .fit)
                            .frame(width: 62, height: 62)
                        
                        UnevenRoundedRectangle(topLeadingRadius: 8, bottomLeadingRadius: 0, bottomTrailingRadius: 0, topTrailingRadius: 8)
                            .colorMultiply(Color.lockGrey.opacity(isLocked ? 0.4 : 0.0))
                    }
                    .frame(width: 125, height: 125)
                    
                    Spacer()
                    
                    HStack {
                        if isLocked { Image(systemName: "lock.fill") }
                        Text(plantModel.species)
                    }
                    .font(Font.statsCard)
                    .foregroundStyle(.white)
                    .bold()
                    
                    Spacer()
                }
            }
            .frame(width: 150, height: 180)
        }
        .contentShape(Rectangle())
    }
}

#Preview {
    VStack {
        HStack {
            PlantShopCard(plantModel: BasePlantModel.lily)
            Spacer()
            PlantShopCard(plantModel: BasePlantModel.lily)
        }
        HStack {
            PlantShopCard(plantModel: BasePlantModel.lavender)
            Spacer()
            PlantShopCard(plantModel: BasePlantModel.lavender)
        }
        HStack {
            PlantShopCard(plantModel: BasePlantModel.delphinium)
            Spacer()
            PlantShopCard(plantModel: BasePlantModel.delphinium)
        }
    }
    .padding(30)
}
