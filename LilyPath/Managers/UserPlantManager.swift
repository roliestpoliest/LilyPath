//
//  UserPlantManager.swift
//  LilyPath
//
//  Created by Chelsea Nguyen on 10/23/24.
//

import Foundation

class UserPlantManager: ObservableObject {
    static let shared = UserPlantManager()
    
    @Published var userPlants: [UserPlantModel] = [] {
        didSet {
            updateCurrentPlant()
        }
    }
    
    @Published var currentPlant: UserPlantModel?
    
    private init() {
        // TODO: Replace with actual user plants
        userPlants = [
            UserPlantModel(
                basePlant: .buttercup,
                plantDate: Calendar.current.date(
                    byAdding: .day, value: -2, to: Date()) ?? Date(),
                completionDate: Date(),
                currentStage: 5,
                watersCollected: [3, 4, 5, 6, 0].reduce(0, +),
                lastWateredDate: Date(),
                isCurrent: false,
                status: .completed
            ),
            UserPlantModel(
                basePlant: .lily,
                plantDate: Calendar.current.date(
                    byAdding: .day, value: -10, to: Date()) ?? Date(),
                completionDate: Calendar.current.date(
                    byAdding: .day, value: -8, to: Date()),
                currentStage: 5,
                watersCollected: [2, 3, 4, 5, 0].reduce(0, +),
                lastWateredDate: Calendar.current.date(
                    byAdding: .day, value: -8, to: Date()),
                isCurrent: false,
                status: .completed
            ),
            UserPlantModel(
                basePlant: .carnation,
                currentStage: 2,
                watersCollected: [3, 2].reduce(0, +),
                lastWateredDate: Calendar.current.date(
                    byAdding: .day, value: -2, to: Date()),
                isCurrent: false,
                status: .growing
            ),
            UserPlantModel(
                basePlant: .petunia,
                completionDate: nil,
                currentStage: 1,
                watersCollected: 1,
                lastWateredDate: Date(),
                isCurrent: true,
                status: .growing
            ),
        ]
    }
    
    private func updateCurrentPlant() {
        currentPlant = userPlants.first { $0.isCurrent }
    }
    
    func waterCurrentPlant() {
        guard let currentPlant = currentPlant else {
            print("No current plant to water")
            return
        }
        
        currentPlant.waterPlant()
        
        objectWillChange.send()
    }
    
    // Sort user plants by stage then species name
    func getUserPlantsSorted() -> [UserPlantModel] {
        userPlants.sorted {
            if $0.currentStage == $1.currentStage {
                return $0.basePlant.species < $1.basePlant.species
            } else {
                return $0.currentStage < $1.currentStage
            }
        }
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
    
    func filteredPlants(for stat: String, within timePeriod: TimePeriod)
    -> [UserPlantModel]
    {
        let startDate = startDate(for: timePeriod)
        
        let filtered = userPlants.filter { plant in
            guard let date = relevantDate(for: plant, stat: stat) else {
                return false
            }
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
            return calendar.date(
                from: calendar.dateComponents(
                    [.yearForWeekOfYear, .weekOfYear], from: now)) ?? now
        case .monthly:
            return calendar.date(
                from: calendar.dateComponents([.year, .month], from: now))
            ?? now
        }
    }
    
    private func plantSortPredicate(for stat: String) -> (
        UserPlantModel, UserPlantModel
    ) -> Bool {
        { first, second in
            let calendar = Calendar.current
            
            let firstDate =
            self.relevantDate(for: first, stat: stat)
                .map { date in calendar.startOfDay(for: date) }
            ?? Date.distantPast
            let secondDate =
            self.relevantDate(for: second, stat: stat)
                .map { date in calendar.startOfDay(for: date) }
            ?? Date.distantPast
            
            return firstDate == secondDate
            ? first.basePlant.species < second.basePlant.species
            : firstDate < secondDate
        }
    }
    
    private func relevantDate(for plant: UserPlantModel, stat: String) -> Date?
    {
        switch stat {
        case "seedsPlanted": return plant.plantDate
        case "plantsCompleted": return plant.completionDate
        case "plantsWatered": return plant.lastWateredDate
        default: return nil
        }
    }
}
