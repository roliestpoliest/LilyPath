//
//  StatisticsView.swift
//  LilyPath
//
//  Created by Carolyn Heron on 9/29/24.
//

import SwiftUI

struct StatisticsView: View {
    @EnvironmentObject var healthManager: HealthManager
    
    @State private var selectedTimePeriod: TimePeriod = .daily
    @State private var selectedChartPeriod: ChartPeriod = .day
    
    @State private var countSteps: Double = 0.0
    @State private var countCalories: Double = 0.0
    @State private var countFlightsClimbed: Double = 0.0
    @State private var countSleep: Double = 0.0
    @State private var countDistance: Double = 0.0
    
    var body: some View {
        NavigationStack {
            VStack {
                ViewTitle(title: "Fitness Stats")
                
                TimePeriodPicker(selectedTimePeriod: $selectedTimePeriod)
                    .padding(.bottom, 20)
                    .shadow(
                        radius: ShadowConstants.radius,
                        y: ShadowConstants.yOffset)
                
                ScrollView {
                    ForEach(MetricType.allCases, id: \.self) { metric in
                        NavigationLink(
                            destination: ChartsView(
                                metricType: metric,
                                selectedChartPeriod: selectedChartPeriod
                            )
                            .environmentObject(healthManager)
                        ) {
                            StatsCard(
                                stat: MetricStatsModel(
                                    metricType: metric,
                                    value: displayMetricValue(for: metric)),
                                timePeriod: selectedTimePeriod)
                        }
                        .padding(.vertical, 10)
                    }
                }
                
                Spacer()
            }
            .background(Color.mainBackground)
            .onAppear {
                updateChartPeriod()
                Task {
                    await fetchMetricDataForSelectedTypeAndPeriod()
                }
            }
            .onChange(of: selectedTimePeriod) { _ in
                updateChartPeriod()
                Task {
                    await fetchMetricDataForSelectedTypeAndPeriod()
                }
            }
        }
    }
    
    private func fetchMetricDataForSelectedTypeAndPeriod() async {
        switch selectedChartPeriod {
        case .day:
            await fetchDailyData()
        case .week:
            await fetchWeeklyData()
        case .month:
            await fetchMonthlyData()
        }
    }
    
    private func updateChartPeriod() {
        switch selectedTimePeriod {
        case .daily:
            selectedChartPeriod = .day
        case .weekly:
            selectedChartPeriod = .week
        case .monthly:
            selectedChartPeriod = .month
        }
    }
    
    private func displayMetricValue(for metric: MetricType) -> String {
        switch metric {
        case .steps:
            return "\(Int(countSteps))"
        case .calories:
            return "\(Int(countCalories))"
        case .flightsClimbed:
            return "\(Int(countFlightsClimbed))"
        case .sleep:
            return String(format: "%.2f", countSleep)
        case .walkingRunningDistance:
            return String(format: "%.2f", countDistance)
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
    private func fetchMetricData(
        using fetchFunction: @escaping (
            Date, @escaping ([HealthDataPoint]) -> Void
        ) -> Void
    ) async -> Double {
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
        countSteps = await fetchMetricData(
            using: healthManager.fetchHourlySteps)
        countCalories = await fetchMetricData(
            using: healthManager.fetchHourlyCalories)
        countFlightsClimbed = await fetchMetricData(
            using: healthManager.fetchHourlyFlightsClimbed)
        countSleep = await fetchMetricData(
            using: healthManager.fetchHourlySleep)
        countDistance = await fetchMetricData(
            using: healthManager.fetchHourlyWalkingRunningDistance)
    }
    
    private func fetchWeeklyData() async {
        // Fetch weekly data for steps
        await withCheckedContinuation { continuation in
            healthManager.fetchWeeklySteps(for: Date.startOfWeek) {
                weeklySteps in
                DispatchQueue.main.async {
                    countSteps = weeklySteps.reduce(0) { $0 + $1.value }
                    continuation.resume()
                }
            }
        }
        
        // Fetch weekly data for calories
        await withCheckedContinuation { continuation in
            healthManager.fetchWeeklyCalories(for: Date.startOfWeek) {
                weeklyCalories in
                DispatchQueue.main.async {
                    countCalories = weeklyCalories.reduce(0) { $0 + $1.value }
                    continuation.resume()
                }
            }
        }
        
        // Fetch weekly data for flights climbed
        await withCheckedContinuation { continuation in
            healthManager.fetchWeeklyFlightsClimbed(for: Date.startOfWeek) {
                weeklyFlights in
                DispatchQueue.main.async {
                    countFlightsClimbed = weeklyFlights.reduce(0) {
                        $0 + $1.value
                    }
                    continuation.resume()
                }
            }
        }
        
        // Fetch weekly data for sleep
        await withCheckedContinuation { continuation in
            healthManager.fetchWeeklySleep(for: Date.startOfWeek) {
                weeklySleep in
                DispatchQueue.main.async {
                    countSleep = weeklySleep.reduce(0) { $0 + $1.value }
                    continuation.resume()
                }
            }
        }
        
        // Fetch weekly data for walking/running distance
        await withCheckedContinuation { continuation in
            healthManager.fetchWeeklyWalkingRunningDistance(
                for: Date.startOfWeek
            ) { weeklyDistance in
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
            healthManager.fetchMonthlySteps(for: Date.startOfMonth) {
                monthlySteps in
                DispatchQueue.main.async {
                    countSteps = monthlySteps.reduce(0) { $0 + $1.value }
                    continuation.resume()
                }
            }
        }
        
        // Fetch monthly data for calories
        await withCheckedContinuation { continuation in
            healthManager.fetchMonthlyCalories(for: Date.startOfMonth) {
                monthlyCalories in
                DispatchQueue.main.async {
                    countCalories = monthlyCalories.reduce(0) { $0 + $1.value }
                    continuation.resume()
                }
            }
        }
        
        // Fetch monthly data for flights climbed
        await withCheckedContinuation { continuation in
            healthManager.fetchMonthlyFlightsClimbed(for: Date.startOfMonth) {
                monthlyFlights in
                DispatchQueue.main.async {
                    countFlightsClimbed = monthlyFlights.reduce(0) {
                        $0 + $1.value
                    }
                    continuation.resume()
                }
            }
        }
        
        // Fetch monthly data for sleep
        await withCheckedContinuation { continuation in
            healthManager.fetchMonthlySleep(for: Date.startOfMonth) {
                monthlySleep in
                DispatchQueue.main.async {
                    countSleep = monthlySleep.reduce(0) { $0 + $1.value }
                    continuation.resume()
                }
            }
        }
        
        // Fetch monthly data for walking/running distance
        await withCheckedContinuation { continuation in
            healthManager.fetchMonthlyWalkingRunningDistance(
                for: Date.startOfMonth
            ) { monthlyDistance in
                DispatchQueue.main.async {
                    countDistance = monthlyDistance.reduce(0) { $0 + $1.value }
                    continuation.resume()
                }
            }
        }
    }
}
