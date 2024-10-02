//
//  ThemeColors.swift
//  LilyPath
//
//  Created by Chelsea Nguyen on 10/2/24.
//

import SwiftUI

extension Color {
    static let mainBackground = Color(hex: "EDE8DC")
    static let lightGreen = Color(hex: "C1CFA1")
    static let darkGreen = Color(hex: "859A68")
    static let darkerGreen = Color(hex: "607543")
    static let lightBlue = Color(hex: "DEE6EB")
    static let waterBlue = Color(hex: "A9B1CD")
    static let darkerBlue = Color(hex: "6F7AA2")
    static let brown = Color(hex: "674430")
    static let pink = Color(hex: "D0B0B0")
    static let redButton = Color(hex: "A45B5B")
    static let greyDarkenBg = Color(hex: "5E5E5E").opacity(0.3)
}

extension Color {
    init(hex: String) {
        let scanner = Scanner(string: hex)
        _ = scanner.scanString("#")
        
        var hexNumber: UInt64 = 0
        scanner.scanHexInt64(&hexNumber)
        
        let r = Double((hexNumber & 0xff0000) >> 16) / 255
        let g = Double((hexNumber & 0x00ff00) >> 8) / 255
        let b = Double(hexNumber & 0x0000ff) / 255
        
        self.init(red: r, green: g, blue: b)
    }
}
