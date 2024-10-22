//
//  HealthManager.swift
//  LilyPath
//
//  Created by Carolyn Heron on 10/21/24.
//

import Charts
import HealthKit
import SwiftUI

extension Double {
    func formattedString() -> String {
        let numberFormatter = NumberFormatter()
        numberFormatter.numberStyle = .decimal
        numberFormatter.maximumFractionDigits = 0

        return numberFormatter.string(from: NSNumber(value: self)) ?? "0"
    }
    
    func rounded(toPlaces places: Int) -> Double {
        let divisor = pow(10.0, Double(places))
        return (self * divisor).rounded() / divisor
    }

}

extension Date {
    // Start of the current day
    static var startOfDay: Date {
        Calendar.current.startOfDay(for: Date())
    }

    // Start of the current week (assuming the week starts on Sunday)
    static var startOfWeek: Date {
        let calendar = Calendar.current
        let currentDate = Date()
        let startOfWeek = calendar.dateInterval(
            of: .weekOfYear, for: currentDate)?.start
        return startOfWeek ?? currentDate  // Fallback to current date if not available
    }

    // Start of the current month
    static var startOfMonth: Date {
        let calendar = Calendar.current
        let currentDate = Date()
        let components = calendar.dateComponents(
            [.year, .month], from: currentDate)
        return calendar.date(from: components) ?? currentDate  // Fallback to current date if not available
    }
}

enum MetricType {
    case steps
    case calories
    case flightsClimbed
    case sleep
    case walkingRunningDistance
}

enum TimeFrame {
    case daily
    case weekly
    case monthly
}

class HealthManager: ObservableObject {
    let healthStore: HKHealthStore
    @Published var activities: [String: Activity] = [:]

    init() {
        self.healthStore = HKHealthStore()
    }

    // Generalized function to fetch data based on metric type and time frame
    func fetchMetricData(for metricType: MetricType, timeFrame: TimeFrame) async {
        let (startDate, endDate, key, title, goal) = getTimeFrameDetails(
            for: metricType, timeFrame: timeFrame
        )
        
        switch metricType {
        case .steps:
            await fetchSteps(from: startDate, to: endDate, for: key, title: title, goal: goal)
        case .calories:
            await fetchCalories(from: startDate, to: endDate, for: key, title: title, goal: goal)
        case .flightsClimbed:
            await fetchFlightsClimbed(from: startDate, to: endDate, for: key, title: title, goal: goal)
        case .sleep:
            await fetchSleep(from: startDate, to: endDate, for: key, title: title, goal: goal)
        case .walkingRunningDistance:
            await fetchWalkingRunningDistance(from: startDate, to: endDate, for: key, title: title, goal: goal)
        }
    }

    // Helper function to get start date, end date, and other details based on the time frame and metric type
    private func getTimeFrameDetails(
        for metricType: MetricType, timeFrame: TimeFrame
    ) -> (Date, Date, String, String, String) {
        let todayEnd = Date()
        let (startDate, keyPrefix, titlePrefix, goal) = getStartDateAndGoal(
            for: timeFrame, metricType: metricType)

        let key = "\(keyPrefix)\(metricType)"
        let title = "\(titlePrefix) \(metricType)"
        return (startDate, todayEnd, key, title, goal)
    }

    // Helper function to determine the start date and goals based on time frame and metric type
    private func getStartDateAndGoal(
        for timeFrame: TimeFrame, metricType: MetricType
    ) -> (Date, String, String, String) {
        switch timeFrame {
        case .daily:
            return (
                Date.startOfDay, "today", "Today's",
                getGoal(for: metricType, timeFrame: .daily)
            )
        case .weekly:
            return (
                Date.startOfWeek, "weekly", "This Week's",
                getGoal(for: metricType, timeFrame: .weekly)
            )
        case .monthly:
            return (
                Date.startOfMonth, "monthly", "This Month's",
                getGoal(for: metricType, timeFrame: .monthly)
            )
        }
    }

    // Helper function to return goal strings based on the metric type and time frame
    private func getGoal(for metricType: MetricType, timeFrame: TimeFrame)
        -> String
    {
        switch metricType {
        case .steps:
            switch timeFrame {
            case .daily: return "10,000"
            case .weekly: return "70,000"
            case .monthly: return "300,000"
            }
        case .calories:
            switch timeFrame {
            case .daily: return "500 kcal"
            case .weekly: return "3500 kcal"
            case .monthly: return "20,000 kcal"
            }
        case .flightsClimbed:
            switch timeFrame {
            case .daily: return "10 flights"
            case .weekly: return "70 flights"
            case .monthly: return "300 flights"
            }
        case .sleep:
            switch timeFrame {
            case .daily: return "8 hrs"
            case .weekly: return "56 hrs"
            case .monthly: return "240 hrs"
            }
        case .walkingRunningDistance:
            switch timeFrame {
            case .daily: return "5 miles"
            case .weekly: return "35 miles"
            case .monthly: return "150 miles"
            }
        }
    }

    // MARK: - General Fetch Functions for each type

    private func fetchSteps(
        from startDate: Date, to endDate: Date, for key: String, title: String, goal: String
    ) async {
        await withCheckedContinuation { continuation in
            guard let stepsType = HKQuantityType.quantityType(forIdentifier: .stepCount) else {
                print("Error: Step count type not available.")
                continuation.resume()
                return
            }
            
            let predicate = HKQuery.predicateForSamples(withStart: startDate, end: endDate, options: .strictStartDate)
            
            let query = HKStatisticsQuery(quantityType: stepsType, quantitySamplePredicate: predicate, options: .cumulativeSum) { _, result, error in
                guard let result = result, let quantity = result.sumQuantity(), error == nil else {
                    print("Error fetching steps: \(error?.localizedDescription ?? "No data available")")
                    continuation.resume()
                    return
                }
                
                let stepCount = quantity.doubleValue(for: HKUnit.count())
                let activity = Activity(id: UUID().uuidString.hashValue, title: title, subtitle: goal, image: "figure.walk", amount: stepCount.formattedString())
                
                DispatchQueue.main.async {
                    self.activities[key] = activity
                }
                
                print("\(title): \(stepCount.formattedString())")
                continuation.resume()
            }
            
            HKHealthStore().execute(query)
        }
    }
    
    private func fetchCalories(
        from startDate: Date, to endDate: Date, for key: String, title: String, goal: String
    ) async {
        await withCheckedContinuation { continuation in
            guard let caloriesType = HKQuantityType.quantityType(forIdentifier: .activeEnergyBurned) else {
                print("Error: Active energy burned type not available.")
                continuation.resume()
                return
            }
            
            let predicate = HKQuery.predicateForSamples(withStart: startDate, end: endDate, options: .strictStartDate)
            
            let query = HKStatisticsQuery(quantityType: caloriesType, quantitySamplePredicate: predicate, options: .cumulativeSum) { _, result, error in
                guard let result = result, let quantity = result.sumQuantity(), error == nil else {
                    print("Error fetching calories: \(error?.localizedDescription ?? "No data available")")
                    continuation.resume()
                    return
                }
                
                let calorieCount = quantity.doubleValue(for: HKUnit.kilocalorie())
                let activity = Activity(id: UUID().uuidString.hashValue, title: title, subtitle: goal, image: "flame.fill", amount: calorieCount.formattedString())
                
                DispatchQueue.main.async {
                    self.activities[key] = activity
                }
                
                print("\(title): \(calorieCount.formattedString())")
                continuation.resume()
            }
            
            HKHealthStore().execute(query)
        }
    }
    
    private func fetchFlightsClimbed(
        from startDate: Date, to endDate: Date, for key: String, title: String, goal: String
    ) async {
        await withCheckedContinuation { continuation in
            guard let flightsClimbedType = HKQuantityType.quantityType(forIdentifier: .flightsClimbed) else {
                print("Error: Flights climbed type not available.")
                continuation.resume()
                return
            }
            
            let predicate = HKQuery.predicateForSamples(withStart: startDate, end: endDate, options: .strictStartDate)
            
            let query = HKStatisticsQuery(quantityType: flightsClimbedType, quantitySamplePredicate: predicate, options: .cumulativeSum) { _, result, error in
                guard let result = result, let quantity = result.sumQuantity(), error == nil else {
                    print("Error fetching flights climbed: \(error?.localizedDescription ?? "No data available")")
                    continuation.resume()
                    return
                }
                
                let flights = quantity.doubleValue(for: HKUnit.count())
                let activity = Activity(id: UUID().uuidString.hashValue, title: title, subtitle: goal, image: "figure.stairs", amount: flights.formattedString())
                
                DispatchQueue.main.async {
                    self.activities[key] = activity
                }
                
                print("\(title): \(flights.formattedString())")
                continuation.resume()
            }
            
            HKHealthStore().execute(query)
        }
    }
    
    private func fetchSleep(
        from startDate: Date, to endDate: Date, for key: String, title: String, goal: String
    ) async {
        await withCheckedContinuation { continuation in
            guard let sleepType = HKObjectType.categoryType(forIdentifier: .sleepAnalysis) else {
                print("Error: Sleep analysis type not available.")
                continuation.resume()
                return
            }
            
            let predicate = HKQuery.predicateForSamples(withStart: startDate, end: endDate, options: .strictStartDate)
            
            let query = HKSampleQuery(sampleType: sleepType, predicate: predicate, limit: HKObjectQueryNoLimit, sortDescriptors: nil) { _, samples, error in
                guard let samples = samples as? [HKCategorySample], error == nil else {
                    print("Error fetching sleep: \(error?.localizedDescription ?? "No data available")")
                    continuation.resume()
                    return
                }
                
                let asleepSamples = samples.filter { sample in
                    sample.value == HKCategoryValueSleepAnalysis.inBed.rawValue
                }
                
                let sleepMinutes = asleepSamples.reduce(0) { total, sample in
                    total + sample.endDate.timeIntervalSince(sample.startDate) / 60
                }
                
                let totalSleepHours = (sleepMinutes / 60.0).rounded(toPlaces: 2)
                let activity = Activity(id: UUID().uuidString.hashValue, title: title, subtitle: goal, image: "bed.double.fill", amount: "\(totalSleepHours) hrs")
                
                DispatchQueue.main.async {
                    self.activities[key] = activity
                }
                
                print("\(title): \(totalSleepHours) hrs")
                continuation.resume()
            }
            
            HKHealthStore().execute(query)
        }
    }
    
    private func fetchWalkingRunningDistance(
        from startDate: Date, to endDate: Date, for key: String, title: String, goal: String
    ) async {
        await withCheckedContinuation { continuation in
            guard let walkingRunningDistanceType = HKQuantityType.quantityType(forIdentifier: .distanceWalkingRunning) else {
                print("Error: Walking + Running distance type not available.")
                continuation.resume()
                return
            }
            
            let predicate = HKQuery.predicateForSamples(withStart: startDate, end: endDate, options: .strictStartDate)
            
            let query = HKStatisticsQuery(quantityType: walkingRunningDistanceType, quantitySamplePredicate: predicate, options: .cumulativeSum) { _, result, error in
                guard let result = result, let quantity = result.sumQuantity(), error == nil else {
                    print("Error fetching walking + running distance: \(error?.localizedDescription ?? "No data available")")
                    continuation.resume()
                    return
                }
                
                let distance = quantity.doubleValue(for: HKUnit.mile())
                let activity = Activity(id: UUID().uuidString.hashValue, title: title, subtitle: goal, image: "figure.walk", amount: distance.formattedString() + " mi")
                
                DispatchQueue.main.async {
                    self.activities[key] = activity
                }
                
                print("\(title): \(distance.formattedString()) mi")
                continuation.resume()
            }
            
            HKHealthStore().execute(query)
        }
    }
}

struct ActivityCard: View {
    @State var activity: Activity
    var body: some View {
        ZStack {
            Color(uiColor: .systemGray6)
                .cornerRadius(20)

            VStack(spacing: 10) {
                HStack(alignment: .top) {
                    VStack(alignment: .leading, spacing: 5) {
                        Text(activity.title)
                            .font(.system(size: 12))
                        Text(activity.subtitle)
                            .font(.system(size: 10))
                            .foregroundColor(.gray)
                    }

                    Image(systemName: activity.image)
                        .foregroundColor(.green)

                }
                .padding()

                Text(activity.amount)
                    .font(.system(size: 24))
            }
            .padding()
            .cornerRadius(15)
        }
    }
}
