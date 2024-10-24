//
//  UserPlant.swift
//  LilyPath
//
//  Created by Chelsea Nguyen on 9/30/24.
//

import SwiftUI

class UserPlantModel: Identifiable {
    enum PlantStatus: String {
        case growing = "Growing"
        case completed = "Completed"
        case wilted = "Wilted"
    }
    
    let id = UUID()
    let basePlant: BasePlantModel
    var plantDate: Date
    var completionDate: Date?
    var lastWateredDate: Date?
    var currentStage: Int
    var watersCollected: Int
    var numberOfRevives: Int
    var status: PlantStatus
    var isCurrent: Bool
    
    // 1 water = 1000 water points = 1000 steps
    var stepsCollected: Int {
        return watersCollected * 1000
    }
    
    var overallProgress: Double {
        guard basePlant.overallStepGoal > 0 else {
            return 0
        }
        
        return min(
            Double(stepsCollected) / Double(basePlant.overallStepGoal), 1.0)
    }
    
    var stepsInCurrentStage: Int {
        guard currentStage > 1 else {
            return stepsCollected
        }
        
        let previousStagesSteps = basePlant.stageStepGoals.prefix(
            currentStage - 1
        ).reduce(0, +)
        
        return max(stepsCollected - previousStagesSteps, 0)
    }
    
    var currentStageGoal: Int {
        guard currentStage > 0, currentStage <= basePlant.stageStepGoals.count
        else {
            return 0
        }
        
        return basePlant.stageStepGoals[currentStage - 1]
    }
    
    var currentImage: String {
        guard currentStage > 0, currentStage <= basePlant.stageImages.count
        else {
            return "Wilt"
        }
        
        return basePlant.stageImages[currentStage - 1]
    }
    
    init(
        basePlant: BasePlantModel,
        plantDate: Date = Date(),
        completionDate: Date? = nil,
        currentStage: Int = 1,
        watersCollected: Int = 0,
        lastWateredDate: Date? = nil,
        numberOfRevives: Int = 0,
        isCurrent: Bool = true,
        status: PlantStatus = .growing
    ) {
        self.basePlant = basePlant
        self.plantDate = plantDate
        self.completionDate = completionDate
        self.currentStage = currentStage
        self.watersCollected = watersCollected
        self.lastWateredDate = lastWateredDate
        self.numberOfRevives = numberOfRevives
        self.isCurrent = isCurrent
        self.status = status
    }
}
