//
//  ThemeColors.swift
//  LilyPath
//
//  Created by Chelsea Nguyen on 10/2/24.
//

import SwiftUI

extension Color {
    static let mainBackground = Color(hex: "#EDE8DC")
    static let lightGreen = Color(hex: "#C1CFA1")
    static let darkGreen = Color(hex: "#859A68")
    static let darkerGreen = Color(hex: "#607543")
    static let lightBlue = Color(hex: "#DEE6EB")
    static let waterBlue = Color(hex: "#A9B1CD")
    static let darkerBlue = Color(hex: "#6F7AA2")
    static let customBrown = Color(hex: "#674430")
    static let customPink = Color(hex: "#D0B0B0")
    static let redButton = Color(hex: "#A45B5B")
    static let greyDarkenBg = Color(hex: "#5E5E5E").opacity(0.3)
}

extension Color {
    init(hex: String) {
        // Trim hex string to remove unwanted characters like "#" or "0x"
        let hex = hex.trimmingCharacters(in: CharacterSet.alphanumerics.inverted)
        
        var int: UInt64 = 0
        Scanner(string: hex).scanHexInt64(&int)
        
        let a, r, g, b: UInt64
        
        // Switch based on the length of the hex code
        switch hex.count {
        case 3: // RGB (12-bit)
            (a, r, g, b) = (255, (int >> 8) * 17, (int >> 4 & 0xF) * 17, (int & 0xF) * 17)
        case 6: // RGB (24-bit)
            (a, r, g, b) = (255, int >> 16, int >> 8 & 0xFF, int & 0xFF)
        case 8: // ARGB (32-bit)
            (a, r, g, b) = (int >> 24, int >> 16 & 0xFF, int >> 8 & 0xFF, int & 0xFF)
        default:
            (a, r, g, b) = (255, 0, 0, 0) // Default to black if the hex is invalid
        }
        
        // Initialize the Color using the computed values
        self.init(
            .sRGB,
            red: Double(r) / 255,
            green: Double(g) / 255,
            blue: Double(b) / 255,
            opacity: Double(a) / 255
        )
    }
}
