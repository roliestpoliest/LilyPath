//
//  AggregateHealthDataView.swift
//  LilyPath
//
//  Created by Carolyn Heron on 10/24/24.
//

import HealthKit
import SwiftUI

import SwiftUI
import HealthKit

struct AggregateHealthDataView: View {
    @EnvironmentObject var healthManager: HealthManager
    
    @State private var selectedChartPeriod: TimeFrame = .daily
    @State private var selectedMetric: MetricType? = nil

    
    @State private var countSteps: Double = 0.0
    @State private var countCalories: Double = 0.0
    @State private var countFlightsClimbed: Double = 0.0
    @State private var countSleep: Double = 0.0
    @State private var countDistance: Double = 0.0
    
    
    
    var body: some View {
        VStack {
            Text("Health Data Aggregates")
                .font(.title)
                .padding()
            
            Picker("Select Time Period", selection: $selectedChartPeriod) {
                Text("Day").tag(TimeFrame.daily)
                Text("Week").tag(TimeFrame.weekly)
                Text("Month").tag(TimeFrame.monthly)
            }
            .pickerStyle(SegmentedPickerStyle())
            .padding()
            
            List {
                HStack {
                    Text("Steps")
                    Spacer()
                    Text("\(Int(countSteps))")
                }
                HStack {
                    Text("Calories")
                    Spacer()
                    Text("\(Int(countCalories))")
                }
                HStack {
                    Text("Flights Climbed")
                    Spacer()
                    Text("\(Int(countFlightsClimbed))")
                }
                HStack {
                    Text("Sleep (hrs)")
                    Spacer()
                    Text("\(countSleep, specifier: "%.2f")")
                }
                HStack {
                    Text("Distance (mi)")
                    Spacer()
                    Text("\(countDistance, specifier: "%.2f")")
                }
            }
            .onAppear {
                Task {
                    await fetchMetricDataForSelectedTypeAndPeriod()
                }
            }
            .onChange(of: selectedChartPeriod) { _ in
                Task {
                    await fetchMetricDataForSelectedTypeAndPeriod()
                }
            }
        }
    }
    
    private func fetchMetricDataForSelectedTypeAndPeriod() async {
        switch selectedChartPeriod {
        case .daily:
            await fetchDailyData()
        case .weekly:
            await fetchWeeklyData() // Replace with your weekly aggregation if needed
        case .monthly:
            await fetchMonthlyData() // Replace with your monthly aggregation if needed
        }
    }
    
    private func fetchMetricData(using fetchFunction: @escaping (Date, @escaping ([HealthDataPoint]) -> Void) -> Void) async -> Double {
        return await withCheckedContinuation { continuation in
            fetchFunction(Date.startOfDay) { hourlyData in
                let totalValue = hourlyData.reduce(0) { $0 + $1.value }
                DispatchQueue.main.async {
                    continuation.resume(returning: totalValue)
                }
            }
        }
    }
    
    private func fetchDailyData() async {
        // Fetch daily data for all metrics using the modular fetch function
        countSteps = await fetchMetricData(using: healthManager.fetchHourlySteps)
        countCalories = await fetchMetricData(using: healthManager.fetchHourlyCalories)
        countFlightsClimbed = await fetchMetricData(using: healthManager.fetchHourlyFlightsClimbed)
        countSleep = await fetchMetricData(using: healthManager.fetchHourlySleep)
        countDistance = await fetchMetricData(using: healthManager.fetchHourlyWalkingRunningDistance)
    }
    
    private func fetchWeeklyData() async {
        // Fetch weekly data for steps
        await withCheckedContinuation { continuation in
            healthManager.fetchWeeklySteps(for: Date.startOfWeek) { weeklySteps in
                DispatchQueue.main.async {
                    countSteps = weeklySteps.reduce(0) { $0 + $1.value }
                    continuation.resume()
                }
            }
        }
        
        // Fetch weekly data for calories
        await withCheckedContinuation { continuation in
            healthManager.fetchWeeklyCalories(for: Date.startOfWeek) { weeklyCalories in
                DispatchQueue.main.async {
                    countCalories = weeklyCalories.reduce(0) { $0 + $1.value }
                    continuation.resume()
                }
            }
        }
        
        // Fetch weekly data for flights climbed
        await withCheckedContinuation { continuation in
            healthManager.fetchWeeklyFlightsClimbed(for: Date.startOfWeek) { weeklyFlights in
                DispatchQueue.main.async {
                    countFlightsClimbed = weeklyFlights.reduce(0) { $0 + $1.value }
                    continuation.resume()
                }
            }
        }
        
        // Fetch weekly data for sleep
        await withCheckedContinuation { continuation in
            healthManager.fetchWeeklySleep(for: Date.startOfWeek) { weeklySleep in
                DispatchQueue.main.async {
                    countSleep = weeklySleep.reduce(0) { $0 + $1.value }
                    continuation.resume()
                }
            }
        }
        
        // Fetch weekly data for walking/running distance
        await withCheckedContinuation { continuation in
            healthManager.fetchWeeklyWalkingRunningDistance(for: Date.startOfWeek) { weeklyDistance in
                DispatchQueue.main.async {
                    countDistance = weeklyDistance.reduce(0) { $0 + $1.value }
                    continuation.resume()
                }
            }
        }
    }
    
    private func fetchMonthlyData() async {
        // Fetch monthly data for steps
        await withCheckedContinuation { continuation in
            healthManager.fetchMonthlySteps(for: Date.startOfMonth) { monthlySteps in
                DispatchQueue.main.async {
                    countSteps = monthlySteps.reduce(0) { $0 + $1.value }
                    continuation.resume()
                }
            }
        }
        
        // Fetch monthly data for calories
        await withCheckedContinuation { continuation in
            healthManager.fetchMonthlyCalories(for: Date.startOfMonth) { monthlyCalories in
                DispatchQueue.main.async {
                    countCalories = monthlyCalories.reduce(0) { $0 + $1.value }
                    continuation.resume()
                }
            }
        }
        
        // Fetch monthly data for flights climbed
        await withCheckedContinuation { continuation in
            healthManager.fetchMonthlyFlightsClimbed(for: Date.startOfMonth) { monthlyFlights in
                DispatchQueue.main.async {
                    countFlightsClimbed = monthlyFlights.reduce(0) { $0 + $1.value }
                    continuation.resume()
                }
            }
        }
        
        // Fetch monthly data for sleep
        await withCheckedContinuation { continuation in
            healthManager.fetchMonthlySleep(for: Date.startOfMonth) { monthlySleep in
                DispatchQueue.main.async {
                    countSleep = monthlySleep.reduce(0) { $0 + $1.value }
                    continuation.resume()
                }
            }
        }
        
        // Fetch monthly data for walking/running distance
        await withCheckedContinuation { continuation in
            healthManager.fetchMonthlyWalkingRunningDistance(for: Date.startOfMonth) { monthlyDistance in
                DispatchQueue.main.async {
                    countDistance = monthlyDistance.reduce(0) { $0 + $1.value }
                    continuation.resume()
                }
            }
        }
    }
}
