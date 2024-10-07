//
//  UserPlant.swift
//  LilyPath
//
//  Created by Chelsea Nguyen on 9/30/24.
//

import SwiftUI

class UserPlantModel:Identifiable {
    let id = UUID()
    let basePlant: BasePlantModel
    var plantDate: Date
    var completionDate: Date?
    var currentStage: Int
    var stepsCollected: Int
    var watersCollected: Int
    var numberOfRevives: Int
    var isCurrent: Bool
    var stepsInCurrentStage: Int {
        guard currentStage > 1, currentStage <= basePlant.stageStepGoals.count else {
            return stepsCollected
        }
        let previousStagesSteps = basePlant.stageStepGoals.prefix(currentStage - 1).reduce(0, +)
        return stepsCollected - previousStagesSteps
    }
    var currentStageGoal: Int {
        guard currentStage > 0, currentStage <= basePlant.stageStepGoals.count else {
            return -1
        }
        return basePlant.stageStepGoals[currentStage - 1]

    }
    var currentImage: String {
        guard currentStage > 0, currentStage <= basePlant.stageImages.count else {
            return "Wilt"
        }
        return basePlant.stageImages[currentStage - 1]
    }
    enum PlantStatus: String {
        case growing = "Growing"
        case completed = "Completed"
        case wilted = "Wilted"
        //case revived = "Revived"
    }
    var status: PlantStatus
    
    init(basePlant: BasePlantModel, plantDate: Date = Date(), completionDate: Date? = nil, currentStage: Int = 1, stepsCollected: Int = 0, watersCollected: Int = 0, numberOfRevives: Int = 0, isCurrent: Bool = true, status: PlantStatus = .growing) {
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
