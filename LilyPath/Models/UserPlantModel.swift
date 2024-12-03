import SwiftUI
import SwiftData

@Model
class UserPlantModel: ObservableObject, Identifiable {
    enum PlantStatus: String, Codable {
        case growing = "Growing"
        case completed = "Completed"
        case wilted = "Wilted"
    }
    
    // Properties
    var id: UUID
    var basePlant: BasePlantModel // Reference to the immutable base plant
    var plantDate: Date
    var completionDate: Date?
    var lastWateredDate: Date?
    var currentStage: Int
    var watersCollected: Int
    var numberOfRevives: Int
    var status: PlantStatus
    var isCurrent: Bool
    
    // Computed Properties
    var stepsCollected: Int {
        return watersCollected * 1000
    }
    
    var overallProgress: Double {
        guard basePlant.overallStepGoal > 0 else {
            return 0
        }
        
        return min(
            Double(stepsCollected) / Double(basePlant.overallStepGoal), 1.0
        )
    }
    
    var stageProgress: Double {
        guard currentStageGoal > 0 else {
            return 0
        }
        
        return min(
            Double(stepsInCurrentStage) / Double(currentStageGoal), 1.0
        )
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
    
    // Initializer
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
        self.id = UUID()
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
    
    // Methods
    func waterPlant() {
        guard currentStage < basePlant.stageStepGoals.count else { return }
        
        watersCollected += 1
        lastWateredDate = Date()
        
        print("Watered \(basePlant.species) - \(watersCollected) waters")
        
        // Notify that this plant's state has changed
        objectWillChange.send()
        
        checkNextStage()
    }
    
    func checkNextStage() {
        if stepsInCurrentStage >= currentStageGoal {
            currentStage += 1
            
            if currentStage == basePlant.stageStepGoals.count {
                status = .completed
                completionDate = Date()
            }
        }
    }
}
