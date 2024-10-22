//
//  FormatNumber.swift
//  LilyPath
//
//  Created by Chelsea Nguyen on 10/21/24.
//

import Foundation

func formatNumberWithCommas(_ number: Int) -> String {
    let numberFormatter = NumberFormatter()
    numberFormatter.numberStyle = .decimal
    
    return numberFormatter.string(from: NSNumber(value: number)) ?? "\(number)"
}
