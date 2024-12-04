//
//  PlantStatsDetailView.swift
//  LilyPath
//
//  Created by Chelsea Nguyen on 10/23/24.
//

//import SwiftData
//import SwiftUI
//
//struct PlantStatsDetailView: View {
//    @ObservedObject var stat: PlantStatsModel
//    @Environment(\.modelContext) private var context
//    let timePeriod: TimePeriod
//
//    var body: some View {
//        VStack {
//            ViewTitle(
//                title:
//                    "\(stat.plant.capitalized)s \(stat.action.capitalized): \(stat.count)"
//            )
//            
//            ScrollView {
//                VStack(spacing: 20) {
//                    let filtered = filteredPlants(for: stat.id, within: timePeriod)
//
//                    if filtered.isEmpty {
//                        Text("No \(stat.plant)s \(stat.action) yet")
//                            .font(.headline)
//                            .italic()
//                            .foregroundColor(.gray)
//                    } else {
//                        ForEach(filtered, id: \.id) { plant in
//                            PlantRowView(plant: plant, action: stat.action)
//                        }
//                        .shadow(
//                            radius: ShadowConstants.radius,
//                            y: ShadowConstants.yOffset
//                        )
//                    }
//                }
//            }
//            
//            Spacer()
//        }
//        .frame(maxWidth: .infinity, maxHeight: .infinity)
//        .navigationTitle("\(timePeriod.rawValue.capitalized)")
//        .background(Color.mainBackground)
//    }
//    
//    // MARK: - Helper Functions
//
//    private func filteredPlants(for stat: String, within timePeriod: TimePeriod) -> [UserPlantModel] {
//        let startDate = startDate(for: timePeriod)
//
//        // Fetch all user plants
//        let fetchDescriptor = FetchDescriptor<UserPlantModel>()
//
//        do {
//            let plants = try context.fetch(fetchDescriptor)
//            return plants
//                .filter { plant in
//                    guard let date = relevantDate(for: plant, stat: stat) else {
//                        return false
//                    }
//                    return date >= startDate
//                }
//                .sorted(by: plantSortPredicate(for: stat))
//        } catch {
//            print("Failed to fetch filtered plants: \(error)")
//            return []
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
//
//    private func startDate(for timePeriod: TimePeriod) -> Date {
//        let now = Date()
//        let calendar = Calendar.current
//        
//        switch timePeriod {
//        case .daily:
//            return calendar.startOfDay(for: now)
//        case .weekly:
//            return calendar.date(
//                from: calendar.dateComponents([.yearForWeekOfYear, .weekOfYear], from: now)
//            ) ?? now
//        case .monthly:
//            return calendar.date(
//                from: calendar.dateComponents([.year, .month], from: now)
//            ) ?? now
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
//}
//
//struct PlantRowView: View {
//    let plant: UserPlantModel
//    let action: String
//    
//    var body: some View {
//        HStack {
//            ZStack {
//                Image(plant.currentImage)
//                    .resizable()
//                    .scaledToFit()
//                    .frame(width: 40, height: 40)
//            }
//            .frame(width: 55, height: 55)
//            .background(Color.lightBlue)
//            .cornerRadius(10)
//            
//            VStack(alignment: .leading) {
//                Text(plant.basePlant.species)
//                    .font(.statsCard)
//                    .foregroundColor(.white)
//                
//                Text(statDateText())
//                    .font(.subheadline)
//                    .foregroundColor(.gray)
//            }
//            .padding(.leading, 8)
//            
//            Spacer()
//        }
//        .padding(12)
//        .frame(maxWidth: .infinity)
//        .background(Color.customBrown)
//        .cornerRadius(20)
//    }
//    
//    private func statDateText() -> String {
//        let date: Date?
//        
//        switch action {
//        case "completed":
//            date = plant.completionDate
//        case "watered":
//            date = plant.lastWateredDate
//        default:
//            date = plant.plantDate
//        }
//        
//        return date.map { "\(action.capitalized) on \(formattedDate($0))" }
//        ?? ""
//    }
//    
//    private func formattedDate(_ date: Date) -> String {
//        let formatter = DateFormatter()
//        formatter.dateStyle = .medium
//        return formatter.string(from: date)
//    }
//}
//
//#Preview {
//    PlantStatsDetailView(
//        stat: PlantStatsModel.seedsPlanted,
//        timePeriod: .daily
//    )
//    .background(Color.mainBackground)
//    .padding(.horizontal, 30)
//}
