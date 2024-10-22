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
    
    static var oneMonthAgo: Date {
        let calendar = Calendar.current
        let oneMonth = calendar.date(byAdding: .month, value: -1, to: Date())
        return calendar.startOfDay(for: oneMonth!)
    }
}

struct HealthDataPoint: Identifiable {
    let id = UUID()
    let date: Date
    let value: Double
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

extension HealthManager {
    func fetchPastMonthData() async {
        let calendar = Calendar.current
        let startDate = Date.startOfMonth
        let endDate = calendar.date(from: DateComponents(year: calendar.component(.year, from: Date()), month: calendar.component(.month, from: Date()) + 1, day: 0))!
        
        // Fetch steps data
        fetchDailySteps(startDate: startDate) { dailySteps in
            var chartData: [HealthDataPoint] = []
            
            // Iterate through each day from the start of the month to the end of the current month
            var currentDate = startDate
            while currentDate <= endDate {
                let steps = dailySteps[currentDate] ?? 0  // If no data, use 0 for future dates
                chartData.append(HealthDataPoint(date: currentDate, value: steps))
                currentDate = calendar.date(byAdding: .day, value: 1, to: currentDate)!
            }
            
            let sortedChartData = chartData.sorted(by: { $0.date < $1.date })  // Create a sorted local copy
            
            DispatchQueue.main.async {
                self.oneMonthChartData = sortedChartData  // Safely assign the sorted data
            }
        }
    }
}
class HealthManager: ObservableObject {
    let healthStore: HKHealthStore
    @Published var activities: [String: Activity] = [:]
    @Published var oneMonthChartData: [HealthDataPoint] = []
    
    init() {
        self.healthStore = HKHealthStore()
        
        // Define the health data types you want to read
        let steps = HKQuantityType.quantityType(forIdentifier: .stepCount)!
        let calories = HKQuantityType.quantityType(forIdentifier: .activeEnergyBurned)!
        let flightsClimbed = HKQuantityType.quantityType(forIdentifier: .flightsClimbed)!
        let sleepAnalysis = HKObjectType.categoryType(forIdentifier: .sleepAnalysis)!
        let walkingRunningDistance = HKQuantityType.quantityType(forIdentifier: .distanceWalkingRunning)!
        
        let healthTypes: Set = [steps, calories, flightsClimbed, sleepAnalysis, walkingRunningDistance]
        
        // Request HealthKit authorization and fetch data
        Task {
            do {
                try await healthStore.requestAuthorization(toShare: [], read: healthTypes)
                await fetchPastMonthData()  // Fetch past month data after authorization
            } catch {
                print("HealthKit authorization failed: \(error.localizedDescription)")
            }
        }
    }
    
    // Fetch past month data
//    func fetchPastMonthData() async {
//        fetchDailySteps(startDate: .startOfMonth) { dailySteps in
//            let chartData = dailySteps.map { (date, steps) in
//                HealthDataPoint(date: date, value: steps)
//            }
//            
//            DispatchQueue.main.async {
//                self.oneMonthChartData = chartData.sorted(by: { $0.date < $1.date })
//            }
//        }
//    }

    // Generalized function to fetch data based on metric type and time frame
    func fetchMetricData(for metricType: MetricType, timeFrame: TimeFrame) async
    {
        let (startDate, endDate, key, title, goal) = getTimeFrameDetails(
            for: metricType, timeFrame: timeFrame
        )

        switch metricType {
        case .steps:
            await fetchSteps(
                from: startDate, to: endDate, for: key, title: title, goal: goal
            )
        case .calories:
            await fetchCalories(
                from: startDate, to: endDate, for: key, title: title, goal: goal
            )
        case .flightsClimbed:
            await fetchFlightsClimbed(
                from: startDate, to: endDate, for: key, title: title, goal: goal
            )
        case .sleep:
            await fetchSleep(
                from: startDate, to: endDate, for: key, title: title, goal: goal
            )
        case .walkingRunningDistance:
            await fetchWalkingRunningDistance(
                from: startDate, to: endDate, for: key, title: title, goal: goal
            )
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
    
    func fetchDailySteps(startDate: Date, completion: @escaping ([Date: Double]) -> Void) {
        let stepsType = HKQuantityType.quantityType(forIdentifier: .stepCount)!
        let interval = DateComponents(day: 1)
        let query = HKStatisticsCollectionQuery(
            quantityType: stepsType,
            quantitySamplePredicate: nil,  // You can set a predicate if needed
            anchorDate: startDate,
            intervalComponents: interval
        )
        
        query.initialResultsHandler = { query, results, error in
            guard let result = results, error == nil else {
                print("Error fetching steps: \(error?.localizedDescription ?? "Unknown error")")
                completion([:])  // Return an empty dictionary on error
                return
            }
            
            var dailySteps: [Date: Double] = [:]
            
            result.enumerateStatistics(from: startDate, to: Date()) { statistics, _ in
                // Get the total steps for the day
                if let sum = statistics.sumQuantity() {
                    let steps = sum.doubleValue(for: HKUnit.count())
                    dailySteps[statistics.startDate] = steps
                } else {
                    dailySteps[statistics.startDate] = 0.0
                }
            }
            
            // Call the completion handler with the dictionary of daily steps
            completion(dailySteps)
        }
        
        HKHealthStore().execute(query)
    }
    

    // MARK: - General Fetch Functions for each type
    func fetchSteps(
        from startDate: Date, to endDate: Date, for key: String, title: String,
        goal: String
    ) async {
        await withCheckedContinuation { continuation in
            guard
                let stepsType = HKQuantityType.quantityType(
                    forIdentifier: .stepCount)
            else {
                print("Error: Step count type not available.")
                continuation.resume()
                return
            }

            let predicate = HKQuery.predicateForSamples(
                withStart: startDate, end: endDate, options: .strictStartDate)

            let query = HKStatisticsQuery(
                quantityType: stepsType, quantitySamplePredicate: predicate,
                options: .cumulativeSum
            ) { _, result, error in
                guard let result = result, let quantity = result.sumQuantity(),
                    error == nil
                else {
                    print(
                        "Error fetching steps: \(error?.localizedDescription ?? "No data available")"
                    )
                    continuation.resume()
                    return
                }

                let stepCount = quantity.doubleValue(for: HKUnit.count())
                let activity = Activity(
                    id: UUID().uuidString.hashValue, title: title,
                    subtitle: goal, image: "figure.walk",
                    amount: stepCount.formattedString())

                DispatchQueue.main.async {
                    self.activities[key] = activity
                }

                print("\(title): \(stepCount.formattedString())")
                continuation.resume()
            }

            HKHealthStore().execute(query)
        }
    }

    func fetchCalories(
        from startDate: Date, to endDate: Date, for key: String, title: String,
        goal: String
    ) async {
        await withCheckedContinuation { continuation in
            guard
                let caloriesType = HKQuantityType.quantityType(
                    forIdentifier: .activeEnergyBurned)
            else {
                print("Error: Active energy burned type not available.")
                continuation.resume()
                return
            }

            let predicate = HKQuery.predicateForSamples(
                withStart: startDate, end: endDate, options: .strictStartDate)

            let query = HKStatisticsQuery(
                quantityType: caloriesType, quantitySamplePredicate: predicate,
                options: .cumulativeSum
            ) { _, result, error in
                guard let result = result, let quantity = result.sumQuantity(),
                    error == nil
                else {
                    print(
                        "Error fetching calories: \(error?.localizedDescription ?? "No data available")"
                    )
                    continuation.resume()
                    return
                }

                let calorieCount = quantity.doubleValue(
                    for: HKUnit.kilocalorie())
                let activity = Activity(
                    id: UUID().uuidString.hashValue, title: title,
                    subtitle: goal, image: "flame.fill",
                    amount: calorieCount.formattedString())

                DispatchQueue.main.async {
                    self.activities[key] = activity
                }

                print("\(title): \(calorieCount.formattedString())")
                continuation.resume()
            }

            HKHealthStore().execute(query)
        }
    }

    func fetchFlightsClimbed(
        from startDate: Date, to endDate: Date, for key: String, title: String,
        goal: String
    ) async {
        await withCheckedContinuation { continuation in
            guard
                let flightsClimbedType = HKQuantityType.quantityType(
                    forIdentifier: .flightsClimbed)
            else {
                print("Error: Flights climbed type not available.")
                continuation.resume()
                return
            }

            let predicate = HKQuery.predicateForSamples(
                withStart: startDate, end: endDate, options: .strictStartDate)

            let query = HKStatisticsQuery(
                quantityType: flightsClimbedType,
                quantitySamplePredicate: predicate, options: .cumulativeSum
            ) { _, result, error in
                guard let result = result, let quantity = result.sumQuantity(),
                    error == nil
                else {
                    print(
                        "Error fetching flights climbed: \(error?.localizedDescription ?? "No data available")"
                    )
                    continuation.resume()
                    return
                }

                let flights = quantity.doubleValue(for: HKUnit.count())
                let activity = Activity(
                    id: UUID().uuidString.hashValue, title: title,
                    subtitle: goal, image: "figure.stairs",
                    amount: flights.formattedString())

                DispatchQueue.main.async {
                    self.activities[key] = activity
                }

                print("\(title): \(flights.formattedString())")
                continuation.resume()
            }

            HKHealthStore().execute(query)
        }
    }

    func fetchSleep(
        from startDate: Date, to endDate: Date, for key: String, title: String,
        goal: String
    ) async {
        await withCheckedContinuation { continuation in
            guard
                let sleepType = HKObjectType.categoryType(
                    forIdentifier: .sleepAnalysis)
            else {
                print("Error: Sleep analysis type not available.")
                continuation.resume()
                return
            }

            let predicate = HKQuery.predicateForSamples(
                withStart: startDate, end: endDate, options: .strictStartDate)

            let query = HKSampleQuery(
                sampleType: sleepType, predicate: predicate,
                limit: HKObjectQueryNoLimit, sortDescriptors: nil
            ) { _, samples, error in
                guard let samples = samples as? [HKCategorySample], error == nil
                else {
                    print(
                        "Error fetching sleep: \(error?.localizedDescription ?? "No data available")"
                    )
                    continuation.resume()
                    return
                }

                let asleepSamples = samples.filter { sample in
                    sample.value == HKCategoryValueSleepAnalysis.inBed.rawValue
                }

                let sleepMinutes = asleepSamples.reduce(0) { total, sample in
                    total + sample.endDate.timeIntervalSince(sample.startDate)
                        / 60
                }

                let totalSleepHours = (sleepMinutes / 60.0).rounded(toPlaces: 2)
                let activity = Activity(
                    id: UUID().uuidString.hashValue, title: title,
                    subtitle: goal, image: "bed.double.fill",
                    amount: "\(totalSleepHours) hrs")

                DispatchQueue.main.async {
                    self.activities[key] = activity
                }

                print("\(title): \(totalSleepHours) hrs")
                continuation.resume()
            }

            HKHealthStore().execute(query)
        }
    }

    func fetchWalkingRunningDistance(
        from startDate: Date, to endDate: Date, for key: String, title: String,
        goal: String
    ) async {
        await withCheckedContinuation { continuation in
            guard
                let walkingRunningDistanceType = HKQuantityType.quantityType(
                    forIdentifier: .distanceWalkingRunning)
            else {
                print("Error: Walking + Running distance type not available.")
                continuation.resume()
                return
            }

            let predicate = HKQuery.predicateForSamples(
                withStart: startDate, end: endDate, options: .strictStartDate)

            let query = HKStatisticsQuery(
                quantityType: walkingRunningDistanceType,
                quantitySamplePredicate: predicate, options: .cumulativeSum
            ) { _, result, error in
                guard let result = result, let quantity = result.sumQuantity(),
                    error == nil
                else {
                    print(
                        "Error fetching walking + running distance: \(error?.localizedDescription ?? "No data available")"
                    )
                    continuation.resume()
                    return
                }

                let distance = quantity.doubleValue(for: HKUnit.mile())
                let activity = Activity(
                    id: UUID().uuidString.hashValue, title: title,
                    subtitle: goal, image: "figure.walk",
                    amount: distance.formattedString() + " mi")

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
