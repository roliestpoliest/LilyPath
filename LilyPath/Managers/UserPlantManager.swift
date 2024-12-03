//
//  UserPlantManager.swift
//  LilyPath
//
//  Created by Chelsea Nguyen on 10/23/24.
//

// TODO: DELETE UNUSED FILE

//class UserPlantManager {
//    static let shared = UserPlantManager()
//
//    private init() { }
//    
//    func fetchUserPlants(context: ModelContext) -> [UserPlantModel] {
//        let fetchDescriptor = FetchDescriptor<UserPlantModel>()
//        do {
//            return try context.fetch(fetchDescriptor)
//        } catch {
//            print("Failed to fetch user plants: \(error)")
//            return []
//        }
//    }
//    
//    func fetchCurrentPlant(context: ModelContext) -> UserPlantModel? {
//        let plants = fetchUserPlants(context: context)
//        return plants.first { $0.isCurrent }
//    }
//    
//    func waterCurrentPlant(context: ModelContext) {
//        guard let currentPlant = fetchCurrentPlant(context: context) else {
//            print("No current plant to water")
//            return
//        }
//        
//        currentPlant.waterPlant()
//
//        do {
//            try context.save()
//            print("Plant watered and saved to the database.")
//        } catch {
//            print("Failed to save changes: \(error)")
//        }
//    }
//    
//    func getUserPlantsSorted(context: ModelContext) -> [UserPlantModel] {
//        fetchUserPlants(context: context).sorted {
//            if $0.currentStage == $1.currentStage {
//                return $0.basePlant.species < $1.basePlant.species
//            } else {
//                return $0.currentStage < $1.currentStage
//            }
//        }
//    }
//    
//    func updatePlantStats(for timePeriod: TimePeriod, context: ModelContext) {
//        ["seedsPlanted", "plantsCompleted", "plantsWatered"].forEach { stat in
//            let count = filteredPlants(for: stat, within: timePeriod, context: context).count
//            updateStatCount(for: stat, to: count)
//        }
//    }
//    
//    private func updateStatCount(for stat: String, to count: Int) {
//        switch stat {
//        case "seedsPlanted": PlantStatsModel.seedsPlanted.count = count
//        case "plantsCompleted": PlantStatsModel.plantsCompleted.count = count
//        case "plantsWatered": PlantStatsModel.plantsWatered.count = count
//        default: break
//        }
//    }
//    
//    func filteredPlants(for stat: String, within timePeriod: TimePeriod, context: ModelContext) -> [UserPlantModel] {
//        let startDate = startDate(for: timePeriod)
//        
//        let plants = fetchUserPlants(context: context)
//        return plants.filter { plant in
//            guard let date = relevantDate(for: plant, stat: stat) else {
//                return false
//            }
//            return date >= startDate
//        }.sorted(by: plantSortPredicate(for: stat))
//    }
//    
//    private func startDate(for timePeriod: TimePeriod) -> Date {
//        let now = Date()
//        let calendar = Calendar.current
//        
//        switch timePeriod {
//        case .daily: return calendar.startOfDay(for: now)
//        case .weekly:
//            return calendar.date(from: calendar.dateComponents([.yearForWeekOfYear, .weekOfYear], from: now)) ?? now
//        case .monthly:
//            return calendar.date(from: calendar.dateComponents([.year, .month], from: now)) ?? now
//        }
//    }
//    
//    private func plantSortPredicate(for stat: String) -> (UserPlantModel, UserPlantModel) -> Bool {
//        { first, second in
//            let calendar = Calendar.current
//            
//            let firstDate = self.relevantDate(for: first, stat: stat)
//                .map { calendar.startOfDay(for: $0) } ?? Date.distantPast
//            let secondDate = self.relevantDate(for: second, stat: stat)
//                .map { calendar.startOfDay(for: $0) } ?? Date.distantPast
//            
//            return firstDate == secondDate
//                ? first.basePlant.species < second.basePlant.species
//                : firstDate < secondDate
//        }
//    }
//    
//    private func relevantDate(for plant: UserPlantModel, stat: String) -> Date? {
//        switch stat {
//        case "seedsPlanted": return plant.plantDate
//        case "plantsCompleted": return plant.completionDate
//        case "plantsWatered": return plant.lastWateredDate
//        default: return nil
//        }
//    }
//}
