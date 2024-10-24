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
    
    @State private var selectedChartPeriod: ChartPeriod = .day
    
    @State private var countSteps: Double = 0.0
    @State private var countCalories: Double = 0.0
    @State private var countFlightsClimbed: Double = 0.0
    @State private var countSleep: Double = 0.0
    @State private var countDistance: Double = 0.0
    
    var body: some View {
        NavigationStack {
            VStack {
                Text("Health Data Aggregates")
                    .font(.title)
                    .padding()
                
                Picker("Select Time Frame", selection: $selectedChartPeriod) {
                    ForEach(ChartPeriod.allCases) { period in
                        Text(period.rawValue).tag(period)
                    }
                }
                .pickerStyle(SegmentedPickerStyle())
                .padding()
                
                List {
                    // For each metric, display the aggregate data and link to the chart view
                    NavigationLink(destination: ChartsView(metricType: .steps, selectedChartPeriod: selectedChartPeriod).environmentObject(healthManager)) {
                        HStack {
                            Text("Steps")
                            Spacer()
                            Text("\(Int(countSteps))")
                        }
                    }
                    
                    NavigationLink(destination: ChartsView(metricType: .calories, selectedChartPeriod: selectedChartPeriod).environmentObject(healthManager)) {
                        HStack {
                            Text("Calories")
                            Spacer()
                            Text("\(Int(countCalories))")
                        }
                    }
                    
                    NavigationLink(destination: ChartsView(metricType: .flightsClimbed, selectedChartPeriod: selectedChartPeriod).environmentObject(healthManager)) {
                        HStack {
                            Text("Flights Climbed")
                            Spacer()
                            Text("\(Int(countFlightsClimbed))")
                        }
                    }
                    
                    NavigationLink(destination: ChartsView(metricType: .sleep, selectedChartPeriod: selectedChartPeriod).environmentObject(healthManager)) {
                        HStack {
                            Text("Sleep (hrs)")
                            Spacer()
                            Text("\(countSleep, specifier: "%.2f")")
                        }
                    }
                    
                    NavigationLink(destination: ChartsView(metricType: .walkingRunningDistance, selectedChartPeriod: selectedChartPeriod).environmentObject(healthManager)) {
                        HStack {
                            Text("Distance (mi)")
                            Spacer()
                            Text("\(countDistance, specifier: "%.2f")")
                        }
                    }
                }
                .background(Color.mainBackground)
            }
            .onAppear {
                Task {
                    await fetchMetricDataForSelectedPeriod()
                }
            }
            .onChange(of: selectedChartPeriod) { _ in
                Task {
                    await fetchMetricDataForSelectedPeriod()
                }
            }
        }
    }
    
    // Function to fetch data based on the selected period
    private func fetchMetricDataForSelectedPeriod() async {
        switch selectedChartPeriod {
        case .day:
            await fetchDailyData()
        case .week:
            await fetchWeeklyData()
        case .month:
            await fetchMonthlyData()
        }
    }
    
    // Helper function to fetch metric data using async and the HealthManager fetch functions
    private func fetchMetricData(using fetchFunction: @escaping (Date, @escaping ([HealthDataPoint]) -> Void) -> Void) async -> Double {
        return await withCheckedContinuation { continuation in
            fetchFunction(Date.startOfDay) { dataPoints in
                let totalValue = dataPoints.reduce(0) { $0 + $1.value }
                DispatchQueue.main.async {
                    continuation.resume(returning: totalValue)
                }
            }
        }
    }
    
    // Fetch daily data for all metrics
    private func fetchDailyData() async {
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
