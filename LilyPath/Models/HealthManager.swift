//
//  HealthManager.swift
//  LilyPath
//
//  Created by Carolyn Heron on 10/21/24.
//

import Charts
import Foundation
import HealthKit
import SwiftUI

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
    // MARK: - Start of Day, Week, Month

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
        let components = calendar.dateComponents([.year, .month], from: Date())
        return calendar.date(from: components) ?? Date()  // Fallback to current date if not available
    }

    // MARK: - One Month, Week, Day Ago

    static var oneMonthAgo: Date {
        let calendar = Calendar.current
        let oneMonth = calendar.date(byAdding: .month, value: -1, to: Date())!
        return calendar.startOfDay(for: oneMonth)
    }

    static var oneWeekAgo: Date {
        let calendar = Calendar.current
        let oneWeek = calendar.date(byAdding: .day, value: -7, to: Date())!
        return calendar.startOfDay(for: oneWeek)
    }

    static var oneDayAgo: Date {
        let calendar = Calendar.current
        let oneDay = calendar.date(byAdding: .day, value: -1, to: Date())!
        return calendar.startOfDay(for: oneDay)
    }

    // MARK: - End of Day, Week, Month

    // End of the current day
    static var endOfDay: Date {
        let calendar = Calendar.current
        return calendar.date(
            bySettingHour: 23, minute: 59, second: 59, of: Date()) ?? Date()
    }

    // End of the current week (assuming the week starts on Sunday)
    static var endOfWeek: Date {
        let calendar = Calendar.current
        let startOfWeek =
            calendar.dateInterval(of: .weekOfYear, for: Date())?.start ?? Date()
        return calendar.date(byAdding: .day, value: 6, to: startOfWeek)?
            .endOfDay ?? Date.endOfDay
    }

    // End of the current month
    static var endOfMonth: Date {
        let calendar = Calendar.current
        let startOfMonth =
            calendar.dateInterval(of: .month, for: Date())?.start ?? Date()
        let range =
            calendar.range(of: .day, in: .month, for: startOfMonth) ?? 1..<1
        let lastDay = range.count
        return calendar.date(bySetting: .day, value: lastDay, of: startOfMonth)?
            .endOfDay ?? Date.endOfDay
    }

    // MARK: - Helper Function for End of Day
    var endOfDay: Date {
        let calendar = Calendar.current
        return calendar.date(
            bySettingHour: 23, minute: 59, second: 59, of: self) ?? self
    }
}

extension HealthManager {
    // MARK: - HealthManager: Fetch Monthly Data
    func fetchMonthlySteps(
        for startDate: Date, completion: @escaping ([HealthDataPoint]) -> Void
    ) {
        let stepsType = HKQuantityType(.stepCount)
        let interval = DateComponents(day: 1)  // Set the interval to daily

        let calendar = Calendar.current
        let startOfMonth =
            calendar.date(
                from: calendar.dateComponents([.year, .month], from: startDate))
            ?? Date.startOfMonth
        let endOfMonth =
            calendar.date(
                from: DateComponents(
                    year: calendar.component(.year, from: startOfMonth),
                    month: calendar.component(.month, from: startOfMonth),
                    day: calendar.range(
                        of: .day, in: .month, for: startOfMonth)?.count))?
            .endOfDay ?? Date.endOfDay

        let query = HKStatisticsCollectionQuery(
            quantityType: stepsType,
            quantitySamplePredicate: HKQuery.predicateForSamples(
                withStart: startOfMonth, end: endOfMonth,
                options: .strictStartDate),
            anchorDate: startOfMonth,
            intervalComponents: interval
        )

        query.initialResultsHandler = { _, results, error in
            guard let result = results else {
                completion([])
                return
            }

            var monthlySteps = [HealthDataPoint]()
            let now = Date()

            // Enumerate through the existing statistics from startOfMonth to now
            result.enumerateStatistics(from: startOfMonth, to: now) {
                statistics, _ in
                let steps =
                    statistics.sumQuantity()?.doubleValue(for: .count()) ?? 0.0
                let dataPoint = HealthDataPoint(
                    date: statistics.startDate, value: steps)
                monthlySteps.append(dataPoint)
            }

            // For future days (after the current date), add 0 steps for the remaining days of the month
            var futureDay = calendar.date(
                byAdding: .day, value: monthlySteps.count, to: startOfMonth)

            while let future = futureDay, future <= endOfMonth {
                if future > now {
                    monthlySteps.append(HealthDataPoint(date: future, value: 0))
                }
                futureDay = calendar.date(byAdding: .day, value: 1, to: future)
            }

            completion(monthlySteps)
        }

        HKHealthStore().execute(query)
    }

    func fetchPastMonthData() async {
        let startDate = Date.startOfMonth

        fetchMonthlySteps(for: startDate) { monthlySteps in
            let chartData = monthlySteps.sorted(by: { $0.date < $1.date })

            DispatchQueue.main.async {
                self.oneMonthChartData = chartData
            }
        }
    }

    // MARK: - HealthManager: Fetch Weekly Data
    func fetchWeeklySteps(
        for startDate: Date, completion: @escaping ([HealthDataPoint]) -> Void
    ) {
        let stepsType = HKQuantityType(.stepCount)
        let interval = DateComponents(day: 1)  // Set the interval to daily

        let calendar = Calendar.current
        let startOfWeek =
            calendar.date(
                from: calendar.dateComponents(
                    [.yearForWeekOfYear, .weekOfYear], from: startDate))
            ?? Date.startOfWeek
        let endOfWeek =
            calendar.date(byAdding: .day, value: 6, to: startOfWeek)?.endOfDay
            ?? Date.endOfDay

        let query = HKStatisticsCollectionQuery(
            quantityType: stepsType,
            quantitySamplePredicate: HKQuery.predicateForSamples(
                withStart: startOfWeek, end: endOfWeek,
                options: .strictStartDate),
            anchorDate: startOfWeek,
            intervalComponents: interval
        )

        query.initialResultsHandler = { _, results, error in
            guard let result = results else {
                completion([])
                return
            }

            var weeklySteps = [HealthDataPoint]()
            let now = Date()

            // Enumerate through the existing statistics from startOfWeek to now
            result.enumerateStatistics(from: startOfWeek, to: now) {
                statistics, _ in
                let steps =
                    statistics.sumQuantity()?.doubleValue(for: .count()) ?? 0.0
                let dataPoint = HealthDataPoint(
                    date: statistics.startDate, value: steps)
                weeklySteps.append(dataPoint)
            }

            // For future days (after the current date), add 0 steps for the remaining days of the week
            var futureDay = calendar.date(
                byAdding: .day, value: weeklySteps.count, to: startOfWeek)

            while let future = futureDay, future <= endOfWeek {
                if future > now {
                    weeklySteps.append(HealthDataPoint(date: future, value: 0))
                }
                futureDay = calendar.date(byAdding: .day, value: 1, to: future)
            }

            completion(weeklySteps)
        }

        HKHealthStore().execute(query)
    }

    func fetchPastWeekData() async {
        let startDate = Date.startOfWeek

        fetchWeeklySteps(for: startDate) { weeklySteps in
            let chartData = weeklySteps.sorted(by: { $0.date < $1.date })

            DispatchQueue.main.async {
                self.oneMonthChartData = chartData
            }
        }
    }

    // MARK: - HealthManager: Fetch Daily Data
    func fetchHourlySteps(
        for startDate: Date, completion: @escaping ([HealthDataPoint]) -> Void
    ) {
        let stepsType = HKQuantityType(.stepCount)
        let interval = DateComponents(hour: 1)

        let startOfDay = Calendar.current.startOfDay(for: startDate)
        let endOfDay =
            Calendar.current.date(
                bySettingHour: 23, minute: 59, second: 59, of: startOfDay)
            ?? Date()

        let query = HKStatisticsCollectionQuery(
            quantityType: stepsType,
            quantitySamplePredicate: HKQuery.predicateForSamples(
                withStart: startOfDay, end: endOfDay, options: .strictStartDate),
            anchorDate: startOfDay,
            intervalComponents: interval
        )

        query.initialResultsHandler = { _, results, error in
            guard let result = results else {
                completion([])
                return
            }

            var hourlySteps = [HealthDataPoint]()
            let now = Date()

            result.enumerateStatistics(from: startOfDay, to: now) {
                statistics, _ in
                let steps =
                    statistics.sumQuantity()?.doubleValue(for: .count()) ?? 0.0
                let dataPoint = HealthDataPoint(
                    date: statistics.startDate, value: steps)
                hourlySteps.append(dataPoint)
            }

            // For future hours (after the current time), set the value to 0
            let calendar = Calendar.current
            var futureHour = calendar.date(
                byAdding: .hour, value: hourlySteps.count, to: startOfDay)

            while let future = futureHour, future <= endOfDay {
                if future > now {
                    hourlySteps.append(HealthDataPoint(date: future, value: 0))
                }
                futureHour = calendar.date(
                    byAdding: .hour, value: 1, to: future)
            }

            completion(hourlySteps)
        }

        HKHealthStore().execute(query)
    }

    func fetchPastDayData() async {
        let startDate = Date.startOfDay

        fetchHourlySteps(for: startDate) { hourlySteps in
            let chartData = hourlySteps.sorted(by: { $0.date < $1.date })

            DispatchQueue.main.async {
                self.oneMonthChartData = chartData
            }
        }
    }

    // MARK: - HealthManager: Helper Functions
    private func processChartData(_ steps: [HealthDataPoint]) {
        let sortedData = steps.sorted(by: { $0.date < $1.date })
        DispatchQueue.main.async {
            self.oneMonthChartData = sortedData
        }
    }

    func fetchDailySteps(
        startDate: Date, completion: @escaping ([HealthDataPoint]) -> Void
    ) {
        let stepsType = HKQuantityType(.stepCount)
        let interval = DateComponents(day: 1)

        let query = HKStatisticsCollectionQuery(
            quantityType: stepsType,
            quantitySamplePredicate: HKQuery.predicateForSamples(
                withStart: startDate, end: Date(), options: .strictStartDate),
            anchorDate: startDate,
            intervalComponents: interval
        )

        query.initialResultsHandler = { _, results, error in
            guard let result = results else {
                completion([])
                return
            }

            var dailySteps = [HealthDataPoint]()
            result.enumerateStatistics(from: startDate, to: Date()) {
                statistics, _ in
                let steps =
                    statistics.sumQuantity()?.doubleValue(for: .count()) ?? 0.0
                dailySteps.append(
                    HealthDataPoint(date: statistics.startDate, value: steps))
            }
            completion(dailySteps)
        }

        HKHealthStore().execute(query)
    }
}

class HealthManager: ObservableObject {
    let healthStore: HKHealthStore
    @Published var activities: [String: Activity] = [:]
    @Published var oneMonthChartData: [HealthDataPoint] = []
    @Published var oneWeekChartData: [HealthDataPoint] = []
    @Published var oneDayChartData: [HealthDataPoint] = []

    init() {
        self.healthStore = HKHealthStore()

        // Define the health data types you want to read
        let steps = HKQuantityType.quantityType(forIdentifier: .stepCount)!
        let calories = HKQuantityType.quantityType(
            forIdentifier: .activeEnergyBurned)!
        let flightsClimbed = HKQuantityType.quantityType(
            forIdentifier: .flightsClimbed)!
        let sleepAnalysis = HKObjectType.categoryType(
            forIdentifier: .sleepAnalysis)!
        let walkingRunningDistance = HKQuantityType.quantityType(
            forIdentifier: .distanceWalkingRunning)!

        let healthTypes: Set = [
            steps, calories, flightsClimbed, sleepAnalysis,
            walkingRunningDistance,
        ]

        // Request HealthKit authorization and fetch data
        Task {
            do {
                try await healthStore.requestAuthorization(
                    toShare: [], read: healthTypes)
                await fetchPastMonthData()  // Fetch past month data after authorization
            } catch {
                print(
                    "HealthKit authorization failed: \(error.localizedDescription)"
                )
            }
        }
    }

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

    func fetchDailySteps(
        startDate: Date, completion: @escaping ([Date: Double]) -> Void
    ) {
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
                print(
                    "Error fetching steps: \(error?.localizedDescription ?? "Unknown error")"
                )
                completion([:])  // Return an empty dictionary on error
                return
            }

            var dailySteps: [Date: Double] = [:]

            result.enumerateStatistics(from: startDate, to: Date()) {
                statistics, _ in
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
