//
//  UserPlant.swift
//  LilyPath
//
//  Created by Chelsea Nguyen on 9/30/24.
//

import SwiftUI

class UserPlantManager: ObservableObject {
    static let shared = UserPlantManager()

    @Published var userPlants: [UserPlantModel] = []

    private init() {
        // TODO: replace with actual user plants
        userPlants = [
            UserPlantModel(
                basePlant: .peony,
                completionDate: Calendar.current.date(byAdding: .day, value: -3, to: Date()),
                currentStage: 1,
                stepsCollected: 1000,
                lastWateredDate: Calendar.current.date(byAdding: .day, value: -8, to: Date()),
                status: .completed
            ),
            UserPlantModel(
                basePlant: .lily,
                completionDate: Date(),
                currentStage: 4,
                stepsCollected: 1000,
                lastWateredDate: Date(),
                status: .completed
            )
        ]
    }

    func updatePlantStats(for timePeriod: TimePeriod) {
        PlantStatsModel.seedsPlanted.count =
            filteredPlants(for: "seedsPlanted", within: timePeriod).count
        PlantStatsModel.plantsCompleted.count =
            filteredPlants(for: "plantsCompleted", within: timePeriod).count
        PlantStatsModel.plantsWatered.count =
            filteredPlants(for: "plantsWatered", within: timePeriod).count
    }

    func filteredPlants(for plantStat: String, within timePeriod: TimePeriod) -> [UserPlantModel] {
        let now = Date()
        let calendar = Calendar.current
        let startDate: Date

        switch timePeriod {
        case .daily:
            startDate = calendar.startOfDay(for: now)
        case .weekly:
            startDate = calendar.date(
                from: calendar.dateComponents([.yearForWeekOfYear, .weekOfYear], from: now)
            ) ?? now
        case .monthly:
            startDate = calendar.date(
                from: calendar.dateComponents([.year, .month], from: now)
            ) ?? now
        }

        let filtered = userPlants.filter { plant in
            switch plantStat {
            case "seedsPlanted":
                return plant.plantDate >= startDate
            case "plantsCompleted":
                return plant.completionDate != nil && plant.completionDate! >= startDate
            case "plantsWatered":
                return plant.lastWateredDate != nil && plant.lastWateredDate! >= startDate
            default:
                return false
            }
        }

        return filtered.sorted {
            let calendar = Calendar.current
            
            let firstDate = relevantDate(for: $0, stat: plantStat)
                .map { date in calendar.startOfDay(for: date) } ?? Date.distantPast
            let secondDate = relevantDate(for: $1, stat: plantStat)
                .map { date in calendar.startOfDay(for: date) } ?? Date.distantPast

            if firstDate == secondDate {
                return $0.basePlant.species < $1.basePlant.species
            } else {
                return firstDate < secondDate
            }
        }
    }

    private func relevantDate(for plant: UserPlantModel, stat: String) -> Date? {
        switch stat {
        case "seedsPlanted":
            return plant.plantDate
        case "plantsCompleted":
            return plant.completionDate
        case "plantsWatered":
            return plant.lastWateredDate
        default:
            return nil
        }
    }
}

class UserPlantModel: Identifiable {
    let id = UUID()
    let basePlant: BasePlantModel
    var plantDate: Date
    var completionDate: Date?
    var currentStage: Int
    var stepsCollected: Int
    var watersCollected: Int
    var lastWateredDate: Date?
    var numberOfRevives: Int
    var isCurrent: Bool
    var status: PlantStatus

    var overallProgress: Double {
        guard currentStage > 0, currentStage <= basePlant.stageStepGoals.count
        else {
            return 0
        }
        return Double(stepsCollected) / Double(basePlant.stepGoal)
    }

    var stepsInCurrentStage: Int {
        guard currentStage > 1, currentStage <= basePlant.stageStepGoals.count
        else {
            return stepsCollected
        }
        let previousStagesSteps = basePlant.stageStepGoals.prefix(
            currentStage - 1
        ).reduce(0, +)
        return stepsCollected - previousStagesSteps
    }

    var currentStageGoal: Int {
        guard currentStage > 0, currentStage <= basePlant.stageStepGoals.count
        else {
            return -1
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

    enum PlantStatus: String {
        case growing = "Growing"
        case completed = "Completed"
        case wilted = "Wilted"
    }

    init(
        basePlant: BasePlantModel,
        plantDate: Date = Date(),
        completionDate: Date? = nil,
        currentStage: Int = 1,
        stepsCollected: Int = 0,
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
        self.stepsCollected = stepsCollected
        self.watersCollected = watersCollected
        self.lastWateredDate = lastWateredDate
        self.numberOfRevives = numberOfRevives
        self.isCurrent = isCurrent
        self.status = status
    }
}
