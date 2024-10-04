//
//  TaskModel.swift
//  LilyPath
//
//  Created by Chelsea Nguyen on 10/4/24.
//

import Foundation

enum Task {
    case walk(Int)
    case climb(Int)
    case sleeps(Int)
    case stand(Int)
    
    private func formatNumberWithCommas(_ number: Int) -> String {
        let numberFormatter = NumberFormatter()
        numberFormatter.numberStyle = .decimal
        return numberFormatter.string(from: NSNumber(value: number)) ?? "\(number)"
    }
    
    func description() -> String {
        switch self {
        case .walk(let steps):
            return "Walk \(formatNumberWithCommas(steps)) steps"
        case .climb(let flights):
            return "Climb \(flights) flights of stairs"
        case .sleeps(let hours):
            return "Get \(hours) hours of sleep"
        case .stand(let hours):
            return "Stand for \(hours) hours"
        }
    }
    
    func goal() -> Int {
        switch self {
        case .walk(let steps):
            return steps
        case .climb(let flights):
            return flights
        case .sleeps(let hours):
            return hours
        case .stand(let hours):
            return hours
        }
    }
}

struct TaskModel {
    let taskName: String
    let taskGoal: Int
    let taskWaterPointsReward: Int
    let taskGemsReward: Int
}
