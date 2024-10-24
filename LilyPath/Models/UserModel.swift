//
//  UserModel.swift
//  LilyPath
//
//  Created by Chelsea Nguyen on 10/23/24.
//

import Foundation

class UserModel: ObservableObject {
    static let shared = UserModel()

    @Published var waterPoints: Int = 0
    @Published var gems: Int = 0
    @Published var level: Int = 1
    @Published var xpProgress: Double = 0.0

    private init() {
        initializeStartingData()
    }

    // TODO: Replace with actual user data
    private func initializeStartingData() {
        waterPoints = 13000
        gems = 12
        level = 1
        xpProgress = 0.5
    }

    func updateWaterPoints(by amount: Int = -1000) {
        waterPoints += amount
        
        gainXP(0.05)
    }

    func updateGems(by amount: Int) {
        gems += amount
    }

    func gainXP(_ amount: Double) {
        xpProgress += amount
        if xpProgress >= 1.0 { levelUp() }
    }

    private func levelUp() {
        level += 1
        xpProgress = 0.0
    }
}
