//
//  StatisticsView.swift
//  LilyPath
//
//  Created by Carolyn Heron on 9/29/24.
//

import Charts
import SwiftUI

enum ChartPeriod: String, CaseIterable, Identifiable {
    case day = "Past Day"
    case week = "Past Week"
    case month = "Past Month"

    var id: String { self.rawValue }
}

import SwiftUI
import Charts

struct StatisticsView: View {
    @EnvironmentObject var healthManager: HealthManager
    @State private var selectedMetric: MetricType = .steps  // Default to Steps
    @State private var selectedChartPeriod: ChartPeriod = .day  // Default to Past Day
    
    var body: some View {
        VStack {
            ViewTitle(title: "Statistics")
            
            // Picker to choose the metric type
            Picker("Select Metric", selection: $selectedMetric) {
                Text("Steps").tag(MetricType.steps)
                Text("Calories").tag(MetricType.calories)
                Text("Flights Climbed").tag(MetricType.flightsClimbed)
                Text("Sleep").tag(MetricType.sleep)
                Text("Distance").tag(MetricType.walkingRunningDistance)
            }
            .pickerStyle(SegmentedPickerStyle())
            .padding()
            
            // Picker to choose the time frame (Day, Week, Month)
            Picker("Select Time Frame", selection: $selectedChartPeriod) {
                ForEach(ChartPeriod.allCases) { period in
                    Text(period.rawValue).tag(period)
                }
            }
            .pickerStyle(SegmentedPickerStyle())
            .padding()
            
            // Pass both metric type and chart period to ChartsView
            ChartsView(metricType: selectedMetric, selectedChartPeriod: selectedChartPeriod)
                .environmentObject(healthManager)
        }
        .onAppear {
            Task {
                await fetchMetricDataForSelectedTypeAndPeriod()
            }
        }
        .onChange(of: selectedMetric) { _ in
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
    
    // Fetch data for the selected metric and time period
    private func fetchMetricDataForSelectedTypeAndPeriod() async {
        switch selectedChartPeriod {
        case .day:
            await healthManager.fetchPastDayData(for: selectedMetric)
        case .week:
            await healthManager.fetchPastWeekData(for: selectedMetric)
        case .month:
            await healthManager.fetchPastMonthData(for: selectedMetric)
        }
    }
}

struct ChartsView: View {
    @EnvironmentObject var healthManager: HealthManager
    var metricType: MetricType  // Add the selected metric type
    var selectedChartPeriod: ChartPeriod  // Add the selected chart period
    
    var body: some View {
        GeometryReader { geometry in
            VStack {
                if selectedChartData().isEmpty {
                    Text("Loading chart data...")
                } else {
                    Chart(selectedChartData()) { dataPoint in
                        BarMark(
                            x: .value("Date", dataPoint.date, unit: chartUnit()),
                            y: .value("Value", dataPoint.value)
                        )
                        .foregroundStyle(getBarColor(for: dataPoint.date))
                        .cornerRadius(1)
                    }
                    .chartXAxis {
                        AxisMarks(values: xAxisValues()) { value in
                            AxisGridLine()
                                .foregroundStyle(.black)
                            AxisValueLabel {
                                if let dateValue = value.as(Date.self) {
                                    Text(formatXAxisLabel(for: dateValue))
                                        .foregroundColor(.customBrown)
                                        .layoutPriority(1)
                                        .font(.chartAxisLabels)
                                }
                            }
                        }
                    }
                    .chartYAxis {
                        AxisMarks { value in
                            AxisGridLine()
                                .foregroundStyle(.black)
                            AxisValueLabel {
                                if let yValue = value.as(Double.self) {
                                    Text(formatYValue(yValue))  // Truncate trailing zeros
                                        .foregroundColor(.customBrown)
                                        .font(.chartAxisLabels)
                                }
                            }
                        }
                    }
                    .chartYScale(domain: 0...maxYValue())  // Ensure Y-axis goes from 0 to max value
                    .frame(width: geometry.size.width - 20, height: 300)
                    .padding(.horizontal, 10)
                    .padding(.top, 10)
                }
            }
        }
    }
    
    // Helper function to select the correct chart data based on the selected period
    private func selectedChartData() -> [HealthDataPoint] {
        switch selectedChartPeriod {
        case .day:
            return healthManager.oneDayChartData.isEmpty ? generateZeroValueData(for: .day) : healthManager.oneDayChartData
        case .week:
            return healthManager.oneWeekChartData.isEmpty ? generateZeroValueData(for: .week) : healthManager.oneWeekChartData
        case .month:
            return healthManager.oneMonthChartData.isEmpty ? generateZeroValueData(for: .month) : healthManager.oneMonthChartData
        }
    }
    
    // Generate placeholder zero data for the given period
    private func generateZeroValueData(for period: ChartPeriod) -> [HealthDataPoint] {
        let dates: [Date]
        switch period {
        case .day:
            dates = stride(from: Date.startOfDay, to: Date.endOfDay, by: 60 * 60).map { $0 }  // Hourly for the current day
        case .week:
            dates = stride(from: Date.startOfWeek, to: Date.endOfWeek, by: 60 * 60 * 24).map { $0 }
        case .month:
            dates = stride(from: Date.startOfMonth, through: Date.endOfMonth, by: 60 * 60 * 24 * 7).map { $0 }
        }
        return dates.map { HealthDataPoint(date: $0, value: 0) }
    }
    
    // Helper function to format the X-axis labels dynamically
    private func formatXAxisLabel(for date: Date) -> String {
        switch selectedChartPeriod {
        case .day:
            return date.formatted(.dateTime.hour())  // Show hours for daily data
        case .week:
            return date.formatted(.dateTime.weekday(.abbreviated))
        case .month:
            return date.formatted(.dateTime.day())
        }
    }
    
    // Helper function to determine X-axis values based on the selected chart period
    private func xAxisValues() -> [Date] {
        let calendar = Calendar.current
        
        switch selectedChartPeriod {
        case .day:
            // Ensure endOfDay is 12 AM of the *next* day, covering all necessary intervals
            let startOfDay = Date.startOfDay
            let endOfDay = calendar.date(byAdding: .day, value: 1, to: startOfDay) ?? Date()
            
            // Return every 6 hours including 12 AM, 6 AM, 12 PM, and 6 PM
            return stride(from: startOfDay, to: endOfDay, by: 60 * 60 * 6).map { $0 }
            
        case .week:
            return stride(from: .startOfWeek, to: .endOfWeek, by: 60 * 60 * 24).map { $0 }
            
        case .month:
            return stride(from: .startOfMonth, through: .endOfMonth, by: 60 * 60 * 24 * 7).map { $0 }
        }
    }
    // Determine the appropriate unit for the X-axis
    private func chartUnit() -> Calendar.Component {
        switch selectedChartPeriod {
        case .day:
            return .hour  // Use hourly unit for daily data
        case .week, .month:
            return .day
        }
    }
    
    private func getBarColor(for date: Date) -> Color {
        let calendar = Calendar.current
        switch selectedChartPeriod {
        case .day:
            return calendar.isDateInToday(date) && calendar.component(.hour, from: date) == calendar.component(.hour, from: Date()) ? Color.waterBlue : Color.darkerBlue
        case .week, .month:
            return calendar.isDateInToday(date) ? Color.waterBlue : Color.darkerBlue
        }
    }
    
    // Get the maximum Y value for the chart to ensure it fits correctly
    private func maxYValue() -> Double {
        let maxValue = selectedChartData().map { $0.value }.max() ?? 0
        return maxValue > 0 ? (maxValue * 1.2) : 10  // Add buffer (20%) for better scaling, no rounding
    }
    
    // Helper function to format the Y-axis values dynamically, truncating unnecessary zeros
    private func formatYValue(_ value: Double) -> String {
        if value.truncatingRemainder(dividingBy: 1) == 0 {
            return "\(Int(value))"  // Display as integer if the value is whole
        } else {
            return String(format: "%.1f", value)  // Allow for one decimal place for floats
        }
    }
}
