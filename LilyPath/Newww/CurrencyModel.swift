//
//  CurrencyModel.swift
//  LilyPath
//
//  Created by Carolyn Heron on 12/1/24.
//


import Foundation
import SwiftData

@Model
class CurrencyModel: Identifiable {
    var id: String
    var waterPoints: Int
    var gems: Int
    
    init(waterPoints: Int = 0, gems: Int = 0) {
        self.id = UUID().uuidString
        self.waterPoints = waterPoints
        self.gems = gems
    }
}
