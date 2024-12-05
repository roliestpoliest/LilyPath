//
//  WaterPointConversion.swift
//  LilyPath
//
//  Created by Chelsea Nguyen on 12/5/24.
//

import SwiftUI

struct WaterPointConversion {
    static let usingSteps = 1 // 1 step = 1 water point
    static let usingGems = 2000 // 1 gem = 2000 water point
}

// MARK: functions related to adding more water points
func onConvert(currencyModels: [CurrencyModel], steps: Int) {
    guard let currencyModel = currencyModels.first else {
        print("No CurrencyModel found.")
        return
    }
        
    currencyModel.waterPoints += steps * WaterPointConversion.usingSteps
    currencyModel.convertedDailySteps += steps * WaterPointConversion.usingSteps
}

func getUnconvertedUserDailySteps(currencyModels: [CurrencyModel], healthManager: HealthManager) async -> Int {
    guard let currencyModel = currencyModels.first else {
        print("No CurrencyModel found.")
        return 0
    }

    let startDate = Calendar.current.startOfDay(for: Date())
    
    do {
        let dailySteps = try await fetchDailySteps(from: startDate, healthManager: healthManager)
        return dailySteps - currencyModel.convertedDailySteps
    } catch {
        print("Failed to fetch daily steps: \(error)")
        return 0
    }
}

func fetchDailySteps(from startDate: Date, healthManager: HealthManager) async throws -> Int {
    return try await withCheckedThrowingContinuation { continuation in
        healthManager.fetchHourlySteps(for: startDate) { dataPoints in
            let totalSteps = dataPoints.reduce(0) { $0 + Int($1.value) }
            continuation.resume(returning: totalSteps)
        }
    }
}

func onBuy(currencyModels: [CurrencyModel], gems: Int) {
    guard let currencyModel = currencyModels.first else {
        print("No CurrencyModel found.")
        return
    }
    
    currencyModel.gems -= gems
    currencyModel.waterPoints += (gems * WaterPointConversion.usingGems)
}
