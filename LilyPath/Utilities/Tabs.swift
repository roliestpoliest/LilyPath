//
//  Tabs.swift
//  LilyPath
//
//  Created by Chelsea Nguyen on 10/7/24.
//

enum Tabs: String, CaseIterable {
    case garden = "Garden"
    case home = "Home"
    case stats = "Stats"

    var icon: Icon {
        switch self {
        case .garden:
            return .garden
        case .home:
            return .home
        case .stats:
            return .stats
        }
    }
}
