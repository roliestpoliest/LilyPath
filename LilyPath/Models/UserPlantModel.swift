//
//  UserPlant.swift
//  LilyPath
//
//  Created by Chelsea Nguyen on 9/30/24.
//

import SwiftUI

class UserPlantModel {
    let basePlant: BasePlantModel
    var plantDate: Date
    var completionDate: Date?
    var currentStage: Int
    var stepsCollected: Int
    var watersCollected: Int
    var numberOfRevives: Int
    var isCurrent: Bool
    var currentImage: String {
        let stageIndex = min(currentStage - 1, basePlant.stageImages.count - 1)
        return basePlant.stageImages[stageIndex]
    }
    
    enum PlantStatus: String {
        case growing = "Growing"
        case completed = "Completed"
        case wilted = "Wilted"
        //case revived = "Revived"
    }
    var status: PlantStatus
    
    init(basePlant: BasePlantModel, plantDate: Date = Date(), completionDate: Date? = nil, currentStage: Int = 1, stepsCollected: Int = 0, watersCollected: Int = 0, numberOfRevives: Int = 0, isCurrent: Bool, status: PlantStatus = .growing) {
        self.basePlant = basePlant
        self.plantDate = plantDate
        self.completionDate = completionDate
        self.currentStage = currentStage
        self.stepsCollected = stepsCollected
        self.watersCollected = watersCollected
        self.numberOfRevives = numberOfRevives
        self.isCurrent = isCurrent
        self.status = status
    }
}
