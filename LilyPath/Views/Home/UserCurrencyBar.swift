//
//  UserCurrencyBar.swift
//  LilyPath
//
//  Created by Chelsea Nguyen on 10/23/24.
//

import SwiftData
import SwiftUI

struct UserCurrencyBar: View {
    @Query private var currencyModels: [CurrencyModel]
    
    @EnvironmentObject var healthManager: HealthManager

    @Binding var showPopUp: Bool
    @Binding var unconvertedSteps: Int

    var body: some View {
        VStack {
            HStack(spacing: 20) {
                Spacer()
                
                if let currentCurrency = currencyModels.first {
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
                
                Text("\(formatNumberWithCommas(value))")
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
                    .customShadow()
            )
            
            if canAdd {
                addWaterPointsButton()
            }
        }
    }

    private func addWaterPointsButton() -> some View {
        Button {
            Task {
                unconvertedSteps = await getUnconvertedUserDailySteps(currencyModels: currencyModels, healthManager: healthManager)
                print("Fetched unconverted steps: \(unconvertedSteps)")
                
                showPopUp = true
            }
        } label: {
            ZStack {
                Circle()
                    .fill(Color.white)
                    .frame(width: 39, height: 39)
                
                IconImage(icon: .plus, height: 40, color: .customPink)
                    .bold()
            }
        }
    }
}

#Preview {
    UserCurrencyBar(showPopUp: .constant(false), unconvertedSteps: .constant(10))
        .modelContainer(for: [CurrencyModel.self])
}
