//
//  UserPlantManager.swift
//  LilyPath
//
//  Created by Chelsea Nguyen on 10/23/24.
//

import Foundation

class UserPlantManager: ObservableObject {
    static let shared = UserPlantManager()

    @Published var userPlants: [UserPlantModel] = []

    private init() {
        // TODO: Replace with actual user plants
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
        ["seedsPlanted", "plantsCompleted", "plantsWatered"].forEach { stat in
            let count = filteredPlants(for: stat, within: timePeriod).count
            updateStatCount(for: stat, to: count)
        }
    }

    private func updateStatCount(for stat: String, to count: Int) {
        switch stat {
        case "seedsPlanted": PlantStatsModel.seedsPlanted.count = count
        case "plantsCompleted": PlantStatsModel.plantsCompleted.count = count
        case "plantsWatered": PlantStatsModel.plantsWatered.count = count
        default: break
        }
    }

    func filteredPlants(for stat: String, within timePeriod: TimePeriod) -> [UserPlantModel] {
        let startDate = startDate(for: timePeriod)

        let filtered = userPlants.filter { plant in
            guard let date = relevantDate(for: plant, stat: stat) else { return false }
            return date >= startDate
        }

        return filtered.sorted(by: plantSortPredicate(for: stat))
    }

    private func startDate(for timePeriod: TimePeriod) -> Date {
        let now = Date()
        let calendar = Calendar.current

        switch timePeriod {
        case .daily: return calendar.startOfDay(for: now)
        case .weekly:
            return calendar.date(from: calendar.dateComponents([.yearForWeekOfYear, .weekOfYear], from: now)) ?? now
        case .monthly:
            return calendar.date(from: calendar.dateComponents([.year, .month], from: now)) ?? now
        }
    }
    
    private func plantSortPredicate(for stat: String) -> (UserPlantModel, UserPlantModel) -> Bool {
        { first, second in
            let calendar = Calendar.current

            let firstDate = self.relevantDate(for: first, stat: stat)
                .map { date in calendar.startOfDay(for: date) } ?? Date.distantPast
            let secondDate = self.relevantDate(for: second, stat: stat)
                .map { date in calendar.startOfDay(for: date) } ?? Date.distantPast

            return firstDate == secondDate
                ? first.basePlant.species < second.basePlant.species
                : firstDate < secondDate
        }
    }

    private func relevantDate(for plant: UserPlantModel, stat: String) -> Date? {
        switch stat {
        case "seedsPlanted": return plant.plantDate
        case "plantsCompleted": return plant.completionDate
        case "plantsWatered": return plant.lastWateredDate
        default: return nil
        }
    }
}
