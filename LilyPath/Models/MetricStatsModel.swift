//
//  MetricStatsModel.swift
//  LilyPath
//
//  Created by Chelsea Nguyen on 12/5/24.
//

struct MetricStatsModel {
    var metricType: MetricType
    var value: String

    var icon: Icon {
        switch metricType {
        case .steps: return .steps
        case .calories: return .calories
        case .flightsClimbed: return .climbed
        case .sleep: return .slept
        case .walkingRunningDistance: return .distance
        }
    }

    var displayName: String {
        return metricType.displayName
    }

    var fluentDisplayName: String {
        return metricType.fluentDisplayName
    }
}
