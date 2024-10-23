//
//  MetricType.swift
//  LilyPath
//
//  Created by Carolyn Heron on 10/23/24.
//


enum MetricType: String, CaseIterable, Identifiable {
    case steps
    case calories
    case flightsClimbed
    case sleep
    case walkingRunningDistance
    
    var id: String { self.rawValue }
    
    var displayName: String {
        switch self {
        case .steps:
            return "Steps"
        case .calories:
            return "Calories"
        case .flightsClimbed:
            return "Flights Climbed"
        case .sleep:
            return "Sleep"
        case .walkingRunningDistance:
            return "Distance"
        }
    }
}
