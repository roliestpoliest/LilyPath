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
    
    var body: some View {
        VStack {
            HStack(spacing: 20) {
                Spacer()
                
                if let currentCurrency = currency.first {
                    OvalCurrencyDisplay(
                        icon: .waterDrop,
                        value: currentCurrency.waterPoints,
                        canAdd: true
                    )
                    
                    OvalCurrencyDisplay(
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
}

struct OvalCurrencyDisplay: View {
    let icon: Icon
    let value: Int
    let canAdd: Bool
    
    init(icon: Icon, value: Int, canAdd: Bool = false) {
        self.icon = icon
        self.value = value
        self.canAdd = canAdd
    }
    
    var body: some View {
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
                Button {
                    print("Tapped add water points")
                } label: {
                    IconImage(icon: .plus, height: 40, color: .customPink)
                        .background(Color.white)
                        .clipShape(Circle())
                }
            }
        }
    }
    
    private func formatNumber(_ value: Int) -> String {
        let formatter = NumberFormatter()
        formatter.numberStyle = .decimal
        return formatter.string(from: NSNumber(value: value)) ?? "\(value)"
    }
}

#Preview {
    let mockCurrency = CurrencyModel(waterPoints: 1200, gems: 45)
    
    UserCurrencyBar()
        .modelContainer(for: [CurrencyModel.self])
}
