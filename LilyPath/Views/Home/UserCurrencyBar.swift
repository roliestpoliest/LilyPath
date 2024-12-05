//
//  UserCurrencyBar.swift
//  LilyPath
//
//  Created by Chelsea Nguyen on 10/23/24.
//

import SwiftData
import SwiftUI

struct UserCurrencyBar: View {
    @Query private var currency: [CurrencyModel]
    @Binding var showPopUp: Bool

    var body: some View {
        VStack {
            HStack(spacing: 20) {
                Spacer()
                
                if let currentCurrency = currency.first {
                    ovalCurrencyDisplay(
                        icon: .waterDrop,
                        value: currentCurrency.waterPoints,
                        canAdd: true
                    )
                    
                    ovalCurrencyDisplay(
                        icon: .gem,
                        value: currentCurrency.gems
                    )
                } else {
                    Text("No currency data available")
                        .foregroundColor(.white)
                        .font(.customBody)
                }
            }
        }
    }
    
    private func ovalCurrencyDisplay(icon: Icon, value: Int, canAdd: Bool = false) -> some View {
        ZStack(alignment: .trailing) {
            HStack(spacing: 8) {
                IconImage(icon: icon, height: 20, color: .waterBlue)
                
                Text("\(formatNumber(value))")
                    .foregroundColor(.white)
                    .font(.customBody)
                    .lineLimit(1)
                    .minimumScaleFactor(0.5)
            }
            .padding(.horizontal, 20)
            .padding(.vertical, 15)
            .padding(.trailing, canAdd ? 30 : 0)
            .background(
                Capsule()
                    .fill(Color.customBrown)
                    .overlay(
                        Capsule()
                            .inset(by: 2.5)
                            .stroke(Color.customPink, lineWidth: 5)
                    )
                    .shadow(
                        radius: ShadowConstants.radius,
                        y: ShadowConstants.yOffset)
            )
            
            if canAdd {
                addWaterPointsButton()
            }
        }
    }

    private func addWaterPointsButton() -> some View {
        Button {
            showPopUp = true
            print("Tapped add water points")
        } label: {
            ZStack {
                Circle()
                    .fill(Color.white)
                    .frame(width: 39, height: 39)
                
                IconImage(icon: .plus, height: 40, color: .customPink)
            }
        }
    }
    
    private func formatNumber(_ value: Int) -> String {
        let formatter = NumberFormatter()
        formatter.numberStyle = .decimal
        return formatter.string(from: NSNumber(value: value)) ?? "\(value)"
    }
}

func onConvert(currencyModels: [CurrencyModel], steps: Int) {
    guard let currencyModel = currencyModels.first else {
        print("No CurrencyModel found.")
        return
    }
    
    // TODO: keep track of how many daily steps were converted
    currencyModel.waterPoints += steps
}

func onBuy(currencyModels: [CurrencyModel]) {
    guard let currencyModel = currencyModels.first else {
        print("No CurrencyModel found.")
        return
    }
    
    currencyModel.gems -= 1
    currencyModel.waterPoints += 3000
}

#Preview {
    UserCurrencyBar(showPopUp: .constant(false))
        .modelContainer(for: [CurrencyModel.self])
}
