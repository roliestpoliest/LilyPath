//
//  UserPlant.swift
//  LilyPath
//
//  Created by Chelsea Nguyen on 9/30/24.
//

import SwiftUI

struct UserPlant {
    var species: String
    var plantDate: Date = Date()
    var completionDate: Date?
    var stageLevel: Int = 1
    var waters: Int = 0
    var isCurrent: Bool = true
}
