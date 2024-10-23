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
        let calendar = Calendar.current
        return calendar.startOfDay(for: Date())
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
        // Return 12 AM of the next day
        return calendar.date(byAdding: .day, value: 1, to: startOfDay) ?? Date()
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
    // MARK: - Fetch Monthly Data for Steps
    func fetchMonthlySteps(
        for startDate: Date, completion: @escaping ([HealthDataPoint]) -> Void
    ) {
        let stepsType = HKQuantityType(.stepCount)
        fetchMonthlyData(
            for: stepsType, startDate: startDate, completion: completion)
    }

    // MARK: - Fetch Monthly Data for Calories
    func fetchMonthlyCalories(
        for startDate: Date, completion: @escaping ([HealthDataPoint]) -> Void
    ) {
        let caloriesType = HKQuantityType(.activeEnergyBurned)
        fetchMonthlyData(
            for: caloriesType, startDate: startDate, completion: completion)
    }

    // MARK: - Fetch Monthly Data for Flights Climbed
    func fetchMonthlyFlightsClimbed(
        for startDate: Date, completion: @escaping ([HealthDataPoint]) -> Void
    ) {
        let flightsClimbedType = HKQuantityType(.flightsClimbed)
        fetchMonthlyData(
            for: flightsClimbedType, startDate: startDate,
            completion: completion)
    }

    // MARK: - Fetch Monthly Data for Walking/Running Distance
    func fetchMonthlyWalkingRunningDistance(
        for startDate: Date, completion: @escaping ([HealthDataPoint]) -> Void
    ) {
        let walkingRunningDistanceType = HKQuantityType(.distanceWalkingRunning)
        fetchMonthlyData(
            for: walkingRunningDistanceType, startDate: startDate,
            completion: completion)
    }

    // MARK: - Fetch Monthly Data for Sleep
    func fetchMonthlySleep(
        for startDate: Date, completion: @escaping ([HealthDataPoint]) -> Void
    ) {
        guard
            let sleepType = HKObjectType.categoryType(
                forIdentifier: .sleepAnalysis)
        else {
            completion([])
            return
        }

        let calendar = Calendar.current
        let startOfMonth =
            calendar.date(
                from: calendar.dateComponents([.year, .month], from: startDate))
            ?? Date.startOfMonth
        let endOfMonth =
            calendar.date(byAdding: .month, value: 1, to: startOfMonth)?
            .addingTimeInterval(-1) ?? Date.endOfMonth

        let predicate = HKQuery.predicateForSamples(
            withStart: startOfMonth, end: endOfMonth, options: .strictStartDate)

        let query = HKSampleQuery(
            sampleType: sleepType, predicate: predicate,
            limit: HKObjectQueryNoLimit, sortDescriptors: nil
        ) { _, samples, error in
            guard let samples = samples as? [HKCategorySample], error == nil
            else {
                completion([])
                return
            }

            var monthlySleep = [HealthDataPoint]()

            // Filter to only include "in bed" data (value == HKCategoryValueSleepAnalysis.inBed)
            let inBedSamples = samples.filter {
                $0.value == HKCategoryValueSleepAnalysis.inBed.rawValue
            }

            // Group sleep data by day
            let groupedSamples = Dictionary(
                grouping: inBedSamples,
                by: { Calendar.current.startOfDay(for: $0.startDate) })

            // Calculate total sleep time (in bed) per day
            for (date, dailySamples) in groupedSamples {
                let sleepMinutes = dailySamples.reduce(0) { total, sample in
                    total + sample.endDate.timeIntervalSince(sample.startDate)
                        / 60
                }
                let sleepHours = (sleepMinutes / 60.0).rounded(toPlaces: 1)
                monthlySleep.append(
                    HealthDataPoint(date: date, value: sleepHours))
            }

            // Fill in any missing days with 0 hours
            var currentDate = startOfMonth
            while currentDate <= endOfMonth {
                if !monthlySleep.contains(where: { $0.date == currentDate }) {
                    monthlySleep.append(
                        HealthDataPoint(date: currentDate, value: 0))
                }
                currentDate = calendar.date(
                    byAdding: .day, value: 1, to: currentDate)!
            }

            completion(monthlySleep.sorted(by: { $0.date < $1.date }))
        }

        HKHealthStore().execute(query)
    }

    // MARK: - General Fetch Monthly Data for HKQuantityType
    private func fetchMonthlyData(
        for quantityType: HKQuantityType, startDate: Date,
        completion: @escaping ([HealthDataPoint]) -> Void
    ) {
        let interval = DateComponents(day: 1)  // Set interval to daily
        let calendar = Calendar.current
        let startOfMonth = calendar.startOfDay(for: startDate)
        let endOfMonth =
            calendar.date(byAdding: .month, value: 1, to: startOfMonth)?
            .endOfDay ?? Date.endOfDay

        let query = HKStatisticsCollectionQuery(
            quantityType: quantityType,
            quantitySamplePredicate: HKQuery.predicateForSamples(
                withStart: startOfMonth, end: endOfMonth,
                options: .strictStartDate
            ),
            anchorDate: startOfMonth,
            intervalComponents: interval
        )

        query.initialResultsHandler = { _, results, error in
            guard let result = results else {
                completion([])
                return
            }

            var monthlyData = [HealthDataPoint]()
            let now = Date()

            // Enumerate through the statistics and handle unit conversion based on the metric type
            result.enumerateStatistics(from: startOfMonth, to: now) {
                statistics, _ in
                let value: Double

                if quantityType
                    == HKQuantityType.quantityType(
                        forIdentifier: .activeEnergyBurned)
                {
                    value =
                        statistics.sumQuantity()?.doubleValue(
                            for: HKUnit.kilocalorie()) ?? 0.0
                } else if quantityType
                    == HKQuantityType.quantityType(
                        forIdentifier: .distanceWalkingRunning)
                {
                    value =
                        statistics.sumQuantity()?.doubleValue(
                            for: HKUnit.mile()) ?? 0.0
                } else {
                    // Default to count for steps, flights climbed, etc.
                    value =
                        statistics.sumQuantity()?.doubleValue(
                            for: HKUnit.count()) ?? 0.0
                }

                let dataPoint = HealthDataPoint(
                    date: statistics.startDate, value: value)
                monthlyData.append(dataPoint)
            }

            // Fill in future days with 0 values
            var futureDay = calendar.date(
                byAdding: .day, value: monthlyData.count, to: startOfMonth)
            while let future = futureDay, future <= endOfMonth {
                if future > now {
                    monthlyData.append(HealthDataPoint(date: future, value: 0))
                }
                futureDay = calendar.date(byAdding: .day, value: 1, to: future)
            }

            completion(monthlyData.sorted(by: { $0.date < $1.date }))
        }

        HKHealthStore().execute(query)
    }
    // Usage for fetching monthly data for different metrics
    func fetchPastMonthData(for metricType: MetricType) async {
        let startDate = Date.startOfMonth

        switch metricType {
        case .steps:
            fetchMonthlySteps(for: startDate) { monthlySteps in
                DispatchQueue.main.async {
                    self.oneMonthChartData = monthlySteps
                }
            }
        case .calories:
            fetchMonthlyCalories(for: startDate) { monthlyCalories in
                DispatchQueue.main.async {
                    self.oneMonthChartData = monthlyCalories
                }
            }
        case .flightsClimbed:
            fetchMonthlyFlightsClimbed(for: startDate) { monthlyFlights in
                DispatchQueue.main.async {
                    self.oneMonthChartData = monthlyFlights
                }
            }
        case .sleep:
            fetchMonthlySleep(for: startDate) { monthlySleep in
                DispatchQueue.main.async {
                    self.oneMonthChartData = monthlySleep
                }
            }
        case .walkingRunningDistance:
            fetchMonthlyWalkingRunningDistance(for: startDate) {
                monthlyDistance in
                DispatchQueue.main.async {
                    self.oneMonthChartData = monthlyDistance
                }
            }
        }
    }
}

extension HealthManager {
    // MARK: - Fetch Weekly Data for Steps
    func fetchWeeklySteps(
        for startDate: Date, completion: @escaping ([HealthDataPoint]) -> Void
    ) {
        let stepsType = HKQuantityType(.stepCount)
        fetchWeeklyData(
            for: stepsType, startDate: startDate, completion: completion)
    }

    // MARK: - Fetch Weekly Data for Calories
    func fetchWeeklyCalories(
        for startDate: Date, completion: @escaping ([HealthDataPoint]) -> Void
    ) {
        let caloriesType = HKQuantityType(.activeEnergyBurned)
        fetchWeeklyData(
            for: caloriesType, startDate: startDate, completion: completion)
    }

    // MARK: - Fetch Weekly Data for Flights Climbed
    func fetchWeeklyFlightsClimbed(
        for startDate: Date, completion: @escaping ([HealthDataPoint]) -> Void
    ) {
        let flightsClimbedType = HKQuantityType(.flightsClimbed)
        fetchWeeklyData(
            for: flightsClimbedType, startDate: startDate,
            completion: completion)
    }

    // MARK: - Fetch Weekly Data for Walking/Running Distance
    func fetchWeeklyWalkingRunningDistance(
        for startDate: Date, completion: @escaping ([HealthDataPoint]) -> Void
    ) {
        let walkingRunningDistanceType = HKQuantityType(.distanceWalkingRunning)
        fetchWeeklyData(
            for: walkingRunningDistanceType, startDate: startDate,
            completion: completion)
    }

    // MARK: - Fetch Weekly Data for Sleep
    func fetchWeeklySleep(
        for startDate: Date, completion: @escaping ([HealthDataPoint]) -> Void
    ) {
        guard
            let sleepType = HKObjectType.categoryType(
                forIdentifier: .sleepAnalysis)
        else {
            completion([])
            return
        }

        let calendar = Calendar.current
        let startOfWeek = calendar.startOfDay(for: startDate)
        let endOfWeek =
            calendar.date(byAdding: .day, value: 6, to: startOfWeek)?.endOfDay
            ?? Date.endOfDay

        let predicate = HKQuery.predicateForSamples(
            withStart: startOfWeek, end: endOfWeek, options: .strictStartDate)

        let query = HKSampleQuery(
            sampleType: sleepType, predicate: predicate,
            limit: HKObjectQueryNoLimit, sortDescriptors: nil
        ) { _, samples, error in
            guard let samples = samples as? [HKCategorySample], error == nil
            else {
                completion([])
                return
            }

            var weeklySleep = [HealthDataPoint]()
            let groupedSamples = Dictionary(
                grouping: samples,
                by: { Calendar.current.startOfDay(for: $0.startDate) })

            // Calculate total sleep per day
            for (date, dailySamples) in groupedSamples {
                let sleepMinutes = dailySamples.reduce(0) { total, sample in
                    total + sample.endDate.timeIntervalSince(sample.startDate)
                        / 60
                }
                let sleepHours = (sleepMinutes / 60.0).rounded(toPlaces: 2)
                weeklySleep.append(
                    HealthDataPoint(date: date, value: sleepHours))
            }

            // Fill in any future days with 0 values
            var futureDay = calendar.date(
                byAdding: .day, value: weeklySleep.count, to: startOfWeek)
            while let future = futureDay, future <= endOfWeek {
                weeklySleep.append(HealthDataPoint(date: future, value: 0))
                futureDay = calendar.date(byAdding: .day, value: 1, to: future)
            }

            completion(weeklySleep.sorted(by: { $0.date < $1.date }))
        }

        HKHealthStore().execute(query)
    }
    // MARK: - General Fetch Weekly Data for HKQuantityType
    private func fetchWeeklyData(
        for quantityType: HKQuantityType, startDate: Date,
        completion: @escaping ([HealthDataPoint]) -> Void
    ) {
        let interval = DateComponents(day: 1)
        let calendar = Calendar.current
        let startOfWeek = calendar.startOfDay(for: startDate)
        let endOfWeek =
            calendar.date(byAdding: .day, value: 6, to: startOfWeek)?.endOfDay
            ?? Date.endOfDay

        let query = HKStatisticsCollectionQuery(
            quantityType: quantityType,
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

            var weeklyData = [HealthDataPoint]()
            let now = Date()

            result.enumerateStatistics(from: startOfWeek, to: now) {
                statistics, _ in
                let value: Double

                // Handle unit conversion based on the metric type
                if quantityType
                    == HKQuantityType.quantityType(
                        forIdentifier: .activeEnergyBurned)
                {
                    value =
                        statistics.sumQuantity()?.doubleValue(
                            for: HKUnit.kilocalorie()) ?? 0.0
                } else if quantityType
                    == HKQuantityType.quantityType(
                        forIdentifier: .distanceWalkingRunning)
                {
                    value =
                        statistics.sumQuantity()?.doubleValue(
                            for: HKUnit.mile()) ?? 0.0
                } else {
                    // Default to using count for other metrics (steps, flights climbed)
                    value =
                        statistics.sumQuantity()?.doubleValue(
                            for: HKUnit.count()) ?? 0.0
                }

                let dataPoint = HealthDataPoint(
                    date: statistics.startDate, value: value)
                weeklyData.append(dataPoint)
            }

            // Fill in any future days with 0 values
            var futureDay = calendar.date(
                byAdding: .day, value: weeklyData.count, to: startOfWeek)
            while let future = futureDay, future <= endOfWeek {
                if future > now {
                    weeklyData.append(HealthDataPoint(date: future, value: 0))
                }
                futureDay = calendar.date(byAdding: .day, value: 1, to: future)
            }

            completion(weeklyData.sorted(by: { $0.date < $1.date }))
        }

        HKHealthStore().execute(query)
    }
    // MARK: - Fetch Past Week Data
    func fetchPastWeekData(for metricType: MetricType) async {
        let startDate = Date.startOfWeek

        switch metricType {
        case .steps:
            fetchWeeklySteps(for: startDate) { weeklySteps in
                DispatchQueue.main.async {
                    self.oneWeekChartData = weeklySteps
                }
            }
        case .calories:
            fetchWeeklyCalories(for: startDate) { weeklyCalories in
                DispatchQueue.main.async {
                    self.oneWeekChartData = weeklyCalories
                }
            }
        case .flightsClimbed:
            fetchWeeklyFlightsClimbed(for: startDate) { weeklyFlights in
                DispatchQueue.main.async {
                    self.oneWeekChartData = weeklyFlights
                }
            }
        case .sleep:
            fetchWeeklySleep(for: startDate) { weeklySleep in
                DispatchQueue.main.async {
                    self.oneWeekChartData = weeklySleep
                }
            }
        case .walkingRunningDistance:
            fetchWeeklyWalkingRunningDistance(for: startDate) {
                weeklyDistance in
                DispatchQueue.main.async {
                    self.oneWeekChartData = weeklyDistance
                }
            }
        }
    }
}

extension HealthManager {

    // MARK: - Fetch Hourly Data for Steps
    func fetchHourlySteps(
        for startDate: Date, completion: @escaping ([HealthDataPoint]) -> Void
    ) {
        let stepsType = HKQuantityType(.stepCount)
        fetchHourlyData(
            for: stepsType, startDate: startDate, completion: completion
        )
    }

    // MARK: - Fetch Hourly Data for Calories
    func fetchHourlyCalories(
        for startDate: Date, completion: @escaping ([HealthDataPoint]) -> Void
    ) {
        let caloriesType = HKQuantityType(.activeEnergyBurned)
        fetchHourlyData(
            for: caloriesType, startDate: startDate, completion: completion
        )
    }

    // MARK: - Fetch Hourly Data for Flights Climbed
    func fetchHourlyFlightsClimbed(
        for startDate: Date, completion: @escaping ([HealthDataPoint]) -> Void
    ) {
        let flightsClimbedType = HKQuantityType(.flightsClimbed)
        fetchHourlyData(
            for: flightsClimbedType, startDate: startDate,
            completion: completion
        )
    }

    // MARK: - Fetch Hourly Data for Walking/Running Distance
    func fetchHourlyWalkingRunningDistance(
        for startDate: Date, completion: @escaping ([HealthDataPoint]) -> Void
    ) {
        let walkingRunningDistanceType = HKQuantityType(.distanceWalkingRunning)
        fetchHourlyData(
            for: walkingRunningDistanceType, startDate: startDate,
            completion: completion
        )
    }

    // MARK: - Fetch Hourly Data for Sleep (In Bed Only)
    func fetchHourlySleep(
        for startDate: Date, completion: @escaping ([HealthDataPoint]) -> Void
    ) {
        guard
            let sleepType = HKObjectType.categoryType(
                forIdentifier: .sleepAnalysis)
        else {
            completion([])
            return
        }

        let calendar = Calendar.current
        let startOfDay = calendar.startOfDay(for: startDate)
        let endOfDay =
            calendar.date(
                bySettingHour: 23, minute: 59, second: 59, of: startOfDay)
            ?? Date()

        let predicate = HKQuery.predicateForSamples(
            withStart: startOfDay, end: endOfDay, options: .strictStartDate)

        let query = HKSampleQuery(
            sampleType: sleepType, predicate: predicate,
            limit: HKObjectQueryNoLimit, sortDescriptors: nil
        ) { _, samples, error in
            guard let samples = samples as? [HKCategorySample], error == nil
            else {
                completion([])
                return
            }

            var hourlySleep = [HealthDataPoint]()

            // Filter to only include "in bed" data (if necessary)
            let inBedSamples = samples.filter {
                $0.value == HKCategoryValueSleepAnalysis.inBed.rawValue
            }

            // Iterate over each sleep sample and split it into hourly chunks
            for sample in inBedSamples {
                var currentStart = sample.startDate
                let sampleEnd = sample.endDate

                // Split the sleep sample into hourly chunks
                while currentStart < sampleEnd {
                    let nextHour =
                        calendar.nextDate(
                            after: currentStart,
                            matching: DateComponents(minute: 0),
                            matchingPolicy: .nextTime) ?? sampleEnd
                    let endOfHour = min(nextHour, sampleEnd)

                    // Calculate the time slept within this hour
                    let sleepMinutes =
                        endOfHour.timeIntervalSince(currentStart) / 60.0
                    let sleepHours = (sleepMinutes / 60.0).rounded(toPlaces: 2)

                    // Add the sleep duration for the current hour
                    hourlySleep.append(
                        HealthDataPoint(date: currentStart, value: sleepHours))

                    // Move to the next hour
                    currentStart = endOfHour
                }
            }

            // Sort the hourly data points by date and return
            completion(hourlySleep.sorted(by: { $0.date < $1.date }))
        }

        HKHealthStore().execute(query)
    }

    // MARK: - General Fetch Hourly Data for HKQuantityType
    func fetchHourlyData(
        for quantityType: HKQuantityType, startDate: Date,
        completion: @escaping ([HealthDataPoint]) -> Void
    ) {
        let interval = DateComponents(hour: 1)
        let calendar = Calendar.current
        let startOfDay = calendar.startOfDay(for: startDate)
        let endOfDay =
            calendar.date(byAdding: .day, value: 1, to: startOfDay) ?? Date()

        let query = HKStatisticsCollectionQuery(
            quantityType: quantityType,
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

            var hourlyData = [HealthDataPoint]()
            let now = Date()

            // Enumerate through the statistics and handle unit conversion based on the metric type
            result.enumerateStatistics(from: startOfDay, to: now) {
                statistics, _ in
                let value: Double

                if quantityType
                    == HKQuantityType.quantityType(
                        forIdentifier: .activeEnergyBurned)
                {
                    value =
                        statistics.sumQuantity()?.doubleValue(
                            for: HKUnit.kilocalorie()) ?? 0.0
                } else if quantityType
                    == HKQuantityType.quantityType(
                        forIdentifier: .distanceWalkingRunning)
                {
                    value =
                        statistics.sumQuantity()?.doubleValue(
                            for: HKUnit.mile()) ?? 0.0
                } else {
                    value =
                        statistics.sumQuantity()?.doubleValue(
                            for: HKUnit.count()) ?? 0.0
                }

                hourlyData.append(
                    HealthDataPoint(date: statistics.startDate, value: value))
            }

            // Fill in missing hours with 0 values
            for hour in 0..<24 {
                if !hourlyData.contains(where: {
                    calendar.component(.hour, from: $0.date) == hour
                }) {
                    if let date = calendar.date(
                        bySettingHour: hour, minute: 0, second: 0,
                        of: startOfDay)
                    {
                        hourlyData.append(HealthDataPoint(date: date, value: 0))
                    }
                }
            }

            completion(hourlyData.sorted(by: { $0.date < $1.date }))
        }

        HKHealthStore().execute(query)
    }

    // MARK: - Fetch Past Day Data for Any Metric
    func fetchPastDayData(for metricType: MetricType) async {
        let startDate = Date.startOfDay

        switch metricType {
        case .steps:
            fetchHourlySteps(for: startDate) { hourlySteps in
                DispatchQueue.main.async {
                    self.oneDayChartData = hourlySteps
                }
            }
        case .calories:
            fetchHourlyCalories(for: startDate) { hourlyCalories in
                DispatchQueue.main.async {
                    self.oneDayChartData = hourlyCalories
                }
            }
        case .flightsClimbed:
            fetchHourlyFlightsClimbed(for: startDate) { hourlyFlights in
                DispatchQueue.main.async {
                    self.oneDayChartData = hourlyFlights
                }
            }
        case .sleep:
            fetchHourlySleep(for: startDate) { hourlySleep in
                DispatchQueue.main.async {
                    self.oneDayChartData = hourlySleep
                }
            }
        case .walkingRunningDistance:
            fetchHourlyWalkingRunningDistance(for: startDate) {
                hourlyDistance in
                DispatchQueue.main.async {
                    self.oneDayChartData = hourlyDistance
                }
            }
        }
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
                await fetchPastDayData(for: MetricType.steps)  // Fetch past month data after authorization
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
        let (startDate, endDate, key, title) = getTimeFrameDetails(
            for: metricType, timeFrame: timeFrame)

        switch metricType {
        case .steps:
            await fetchSteps(
                from: startDate, to: endDate, for: key, title: title)
        case .calories:
            await fetchCalories(
                from: startDate, to: endDate, for: key, title: title)
        case .flightsClimbed:
            await fetchFlightsClimbed(
                from: startDate, to: endDate, for: key, title: title)
        case .sleep:
            await fetchSleep(
                from: startDate, to: endDate, for: key, title: title)
        case .walkingRunningDistance:
            await fetchWalkingRunningDistance(
                from: startDate, to: endDate, for: key, title: title)
        }
    }

    // Helper function to get start date, end date, and other details based on the time frame and metric type
    private func getTimeFrameDetails(
        for metricType: MetricType, timeFrame: TimeFrame
    ) -> (Date, Date, String, String) {
        let todayEnd = Date()
        let (startDate, keyPrefix, titlePrefix) = getStartDateAndGoal(
            for: timeFrame, metricType: metricType)

        let key = "\(keyPrefix)\(metricType)"
        let title = "\(titlePrefix) \(metricType)"
        return (startDate, todayEnd, key, title)
    }

    // Helper function to determine the start date and goals based on time frame and metric type
    private func getStartDateAndGoal(
        for timeFrame: TimeFrame, metricType: MetricType
    ) -> (Date, String, String) {
        switch timeFrame {
        case .daily:
            return (Date.startOfDay, "today", "Today's")
        case .weekly:
            return (Date.startOfWeek, "weekly", "This Week's")
        case .monthly:
            return (Date.startOfMonth, "monthly", "This Month's")
        }
    }

    // MARK: - General Fetch Functions for each type
    func fetchSteps(
        from startDate: Date, to endDate: Date, for key: String, title: String
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

                print("\(title): \(stepCount.formattedString())")
                continuation.resume()
            }

            HKHealthStore().execute(query)
        }
    }

    func fetchCalories(
        from startDate: Date, to endDate: Date, for key: String, title: String
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
                print("\(title): \(calorieCount.formattedString())")
                continuation.resume()
            }

            HKHealthStore().execute(query)
        }
    }

    func fetchFlightsClimbed(
        from startDate: Date, to endDate: Date, for key: String, title: String
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
                print("\(title): \(flights.formattedString())")
                continuation.resume()
            }

            HKHealthStore().execute(query)
        }
    }

    func fetchSleep(
        from startDate: Date, to endDate: Date, for key: String, title: String
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

                print("\(title): \(totalSleepHours) hrs")
                continuation.resume()
            }

            HKHealthStore().execute(query)
        }
    }

    func fetchWalkingRunningDistance(
        from startDate: Date, to endDate: Date, for key: String, title: String
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

                print("\(title): \(distance.formattedString()) mi")
                continuation.resume()
            }

            HKHealthStore().execute(query)
        }
    }
}
