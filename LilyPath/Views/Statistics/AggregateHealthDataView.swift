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

    
    @State private var dailySteps: Double = 0.0
    @State private var dailyCalories: Double = 0.0
    @State private var dailyFlightsClimbed: Double = 0.0
    @State private var dailySleep: Double = 0.0
    @State private var dailyDistance: Double = 0.0
    
    
    
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
                    Text("\(Int(dailySteps))")
                }
                HStack {
                    Text("Calories")
                    Spacer()
                    Text("\(Int(dailyCalories))")
                }
                HStack {
                    Text("Flights Climbed")
                    Spacer()
                    Text("\(Int(dailyFlightsClimbed))")
                }
                HStack {
                    Text("Sleep (hrs)")
                    Spacer()
                    Text("\(dailySleep, specifier: "%.2f")")
                }
                HStack {
                    Text("Distance (mi)")
                    Spacer()
                    Text("\(dailyDistance, specifier: "%.2f")")
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
        dailySteps = await fetchMetricData(using: healthManager.fetchHourlySteps)
        dailyCalories = await fetchMetricData(using: healthManager.fetchHourlyCalories)
        dailyFlightsClimbed = await fetchMetricData(using: healthManager.fetchHourlyFlightsClimbed)
        dailySleep = await fetchMetricData(using: healthManager.fetchHourlySleep)
        dailyDistance = await fetchMetricData(using: healthManager.fetchHourlyWalkingRunningDistance)
    }
    
    private func fetchWeeklyData() async {
        // Fetch weekly data for steps
        await withCheckedContinuation { continuation in
            healthManager.fetchWeeklySteps(for: Date.startOfWeek) { weeklySteps in
                DispatchQueue.main.async {
                    dailySteps = weeklySteps.reduce(0) { $0 + $1.value }
                    continuation.resume()
                }
            }
        }
        
        // Fetch weekly data for calories
        await withCheckedContinuation { continuation in
            healthManager.fetchWeeklyCalories(for: Date.startOfWeek) { weeklyCalories in
                DispatchQueue.main.async {
                    dailyCalories = weeklyCalories.reduce(0) { $0 + $1.value }
                    continuation.resume()
                }
            }
        }
        
        // Fetch weekly data for flights climbed
        await withCheckedContinuation { continuation in
            healthManager.fetchWeeklyFlightsClimbed(for: Date.startOfWeek) { weeklyFlights in
                DispatchQueue.main.async {
                    dailyFlightsClimbed = weeklyFlights.reduce(0) { $0 + $1.value }
                    continuation.resume()
                }
            }
        }
        
        // Fetch weekly data for sleep
        await withCheckedContinuation { continuation in
            healthManager.fetchWeeklySleep(for: Date.startOfWeek) { weeklySleep in
                DispatchQueue.main.async {
                    dailySleep = weeklySleep.reduce(0) { $0 + $1.value }
                    continuation.resume()
                }
            }
        }
        
        // Fetch weekly data for walking/running distance
        await withCheckedContinuation { continuation in
            healthManager.fetchWeeklyWalkingRunningDistance(for: Date.startOfWeek) { weeklyDistance in
                DispatchQueue.main.async {
                    dailyDistance = weeklyDistance.reduce(0) { $0 + $1.value }
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
                    dailySteps = monthlySteps.reduce(0) { $0 + $1.value }
                    continuation.resume()
                }
            }
        }
        
        // Fetch monthly data for calories
        await withCheckedContinuation { continuation in
            healthManager.fetchMonthlyCalories(for: Date.startOfMonth) { monthlyCalories in
                DispatchQueue.main.async {
                    dailyCalories = monthlyCalories.reduce(0) { $0 + $1.value }
                    continuation.resume()
                }
            }
        }
        
        // Fetch monthly data for flights climbed
        await withCheckedContinuation { continuation in
            healthManager.fetchMonthlyFlightsClimbed(for: Date.startOfMonth) { monthlyFlights in
                DispatchQueue.main.async {
                    dailyFlightsClimbed = monthlyFlights.reduce(0) { $0 + $1.value }
                    continuation.resume()
                }
            }
        }
        
        // Fetch monthly data for sleep
        await withCheckedContinuation { continuation in
            healthManager.fetchMonthlySleep(for: Date.startOfMonth) { monthlySleep in
                DispatchQueue.main.async {
                    dailySleep = monthlySleep.reduce(0) { $0 + $1.value }
                    continuation.resume()
                }
            }
        }
        
        // Fetch monthly data for walking/running distance
        await withCheckedContinuation { continuation in
            healthManager.fetchMonthlyWalkingRunningDistance(for: Date.startOfMonth) { monthlyDistance in
                DispatchQueue.main.async {
                    dailyDistance = monthlyDistance.reduce(0) { $0 + $1.value }
                    continuation.resume()
                }
            }
        }
    }
}
