//
//  UserCurrencyBar.swift
//  LilyPath
//
//  Created by Chelsea Nguyen on 10/23/24.
//

//import SwiftUI
//
//struct UserCurrencyBar: View {
////    @ObservedObject private var user = UserModel.shared
//
//    var body: some View {
//        VStack {
//            HStack(spacing: 20) {
//                Spacer()
//                
//                OvalDisplay(
//                    icon: .waterDrop,
//                    value: user.waterPoints
//                )
//                
//                OvalDisplay(
//                    icon: .gem,
//                    value: user.gems
//                )
//            }
//        }
//    }
//}
//
//struct OvalDisplay: View {
//    let icon: Icon
//    let value: Int
//    
//    var body: some View {
//        HStack(spacing: 8) {
//            IconImage(icon: icon, height: 20, color: .waterBlue)
//
//            Text("\(formatNumber(value))")
//                .foregroundColor(.white)
//                .font(.customBody)
//                .lineLimit(1)
//                .minimumScaleFactor(0.5)
//        }
//        .padding(.horizontal, 20)
//        .padding(.vertical, 15)
//        .background(
//            Capsule()
//                .fill(Color.customBrown)
//                .overlay(
//                    Capsule()
//                        .inset(by: 2.5)
//                        .stroke(Color.customPink, lineWidth: 5)
//                )
//                .shadow(radius: ShadowConstants.radius, y: ShadowConstants.yOffset)
//        )
//    }
//
//    private func formatNumber(_ value: Int) -> String {
//        let formatter = NumberFormatter()
//        formatter.numberStyle = .decimal
//        return formatter.string(from: NSNumber(value: value)) ?? "\(value)"
//    }
//}
//
//#Preview {
//    UserCurrencyBar()
//}

import SwiftUI
import SwiftData

struct UserCurrencyBar: View {
    @Query private var currency: [CurrencyModel] // Fetch the single CurrencyModel instance
    
    var body: some View {
        VStack {
            HStack(spacing: 20) {
                Spacer()
                
                if let currentCurrency = currency.first {
                    OvalDisplay(
                        icon: .waterDrop,
                        value: currentCurrency.waterPoints
                    )
                    
                    OvalDisplay(
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

struct OvalDisplay: View {
    let icon: Icon
    let value: Int
    
    var body: some View {
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
        .background(
            Capsule()
                .fill(Color.customBrown)
                .overlay(
                    Capsule()
                        .inset(by: 2.5)
                        .stroke(Color.customPink, lineWidth: 5)
                )
                .shadow(radius: ShadowConstants.radius, y: ShadowConstants.yOffset)
        )
    }
    
    private func formatNumber(_ value: Int) -> String {
        let formatter = NumberFormatter()
        formatter.numberStyle = .decimal
        return formatter.string(from: NSNumber(value: value)) ?? "\(value)"
    }
}

#Preview {
    // Simulate the CurrencyModel for preview
    let mockCurrency = CurrencyModel(waterPoints: 1200, gems: 45)
    UserCurrencyBar()
        .modelContainer(for: [CurrencyModel.self]) // Attach the model container for the preview
}
