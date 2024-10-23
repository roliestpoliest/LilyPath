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

struct ChartsView: View {
    @EnvironmentObject var healthManager: HealthManager
    @State private var selectedChartPeriod: ChartPeriod = .day  // Default to Past Day

    var body: some View {
        VStack {
            // Picker for selecting the time frame (Day, Week, Month)
            Picker("Select Time Frame", selection: $selectedChartPeriod) {
                ForEach(ChartPeriod.allCases) { period in
                    Text(period.rawValue).tag(period)
                }
            }
            .pickerStyle(SegmentedPickerStyle())
            .padding()

            GeometryReader { geometry in
                VStack {
                    if healthManager.oneMonthChartData.isEmpty {
                        Text("Loading chart data...")
                    } else {
                        Chart(healthManager.oneMonthChartData) { dataPoint in
                            BarMark(
                                x: .value(
                                    "Date", dataPoint.date, unit: chartUnit()),
                                y: .value("Steps", dataPoint.value)
                            )
                            .foregroundStyle(
                                getBarColor(for: dataPoint.date)  // Set bar color dynamically
                            )
                            .cornerRadius(1)
                        }
                        .chartXAxis {
                            AxisMarks(values: xAxisValues()) { value in
                                AxisGridLine()
                                    .foregroundStyle(.black)
                                AxisValueLabel {
                                    if let dateValue = value.as(Date.self) {
                                        Text(formatXAxisLabel(for: dateValue))  // Dynamic label formatting
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
                                    Text("\(Int(value.as(Double.self) ?? 0))")
                                        .foregroundColor(.customBrown)
                                        .font(.chartAxisLabels)
                                }
                            }
                        }
                        .frame(width: geometry.size.width - 20, height: 300)
                        .padding(.horizontal, 10)
                        .padding(.top, 10)
                    }
                }
            }
        }
        .onAppear {
            Task {
                await updateChartData(for: selectedChartPeriod)
            }
        }
        .onChange(of: selectedChartPeriod) { newPeriod in
            Task {
                await updateChartData(for: newPeriod)
            }
        }
    }

    // Helper function to format the X-axis labels dynamically
    private func formatXAxisLabel(for date: Date) -> String {
        switch selectedChartPeriod {
        case .day:
            return date.formatted(.dateTime.hour())  // Show hours for daily
        case .week:
            return date.formatted(.dateTime.weekday(.abbreviated))  // Show abbreviated weekday for weekly
        case .month:
            return date.formatted(.dateTime.day())  // Show day number for monthly
        }
    }

    // Helper function to determine X-axis values based on the selected chart period
    private func xAxisValues() -> [Date] {
        switch selectedChartPeriod {
        case .day:
            return stride(from: .startOfDay, to: .endOfDay, by: 60 * 60 * 6).map
            { $0 }
        case .week:
            return stride(
                from: .startOfWeek, to: .endOfWeek, by: 60 * 60 * 24
            ).map { $0 }
        case .month:
            return stride(
                from: .startOfMonth, through: .endOfMonth, by: 60 * 60 * 24 * 7
            ).map { $0 }
        }
    }

    // Determine the appropriate unit for the X-axis
    private func chartUnit() -> Calendar.Component {
        switch selectedChartPeriod {
        case .day:
            return .hour
        case .week, .month:
            return .day
        }
    }

    private func getBarColor(for date: Date) -> Color {
        let calendar = Calendar.current
        switch selectedChartPeriod {
        case .day:
            return calendar.isDateInToday(date)
                && calendar.component(.hour, from: date)
                    == calendar.component(.hour, from: Date())
                ? Color.waterBlue
                : Color.darkerBlue
        case .week, .month:
            return calendar.isDateInToday(date)
                ? Color.waterBlue : Color.darkerBlue
        }
    }

    // Function to update the chart data based on the selected chart period
    private func updateChartData(for period: ChartPeriod) async {
        switch period {
        case .day:
            await healthManager.fetchPastDayData()
        case .week:
            await healthManager.fetchPastWeekData()
        case .month:
            await healthManager.fetchPastMonthData()
        }
    }
}
struct StatisticsView: View {
    @EnvironmentObject var healthManager: HealthManager

    var body: some View {
        VStack {
            ViewTitle(title: "Statistics")

            //            ScrollView {
            //                LazyVGrid(
            //                    columns: Array(repeating: GridItem(spacing: 20), count: 2)
            //                ) {
            //                    ForEach(
            //                        healthManager.activities.sorted(by: {
            //                            $0.value.id < $1.value.id
            //                        }), id: \.key
            //                    ) { _, activity in
            //                        ActivityCard(activity: activity)
            //                    }
            //                }
            //                .padding(.horizontal)

            ChartsView()
                .environmentObject(healthManager)

            //            }

        }
        .onAppear {
            Task {
                // Call each metric data fetch asynchronously
                await healthManager.fetchMetricData(
                    for: .steps, timeFrame: .daily)
                await healthManager.fetchMetricData(
                    for: .calories, timeFrame: .weekly)
                await healthManager.fetchMetricData(
                    for: .flightsClimbed, timeFrame: .monthly)
            }
        }
    }
}
//    struct StatisticsView: View {
//    @EnvironmentObject var healthManager: HealthManager
//
//    var body: some View {
//        VStack {
//            ViewTitle(title: "Statistics")
//
//            ScrollView {
//                LazyVGrid(columns: Array(repeating: GridItem(spacing: 20), count: 2)) {
//                    ForEach(healthManager.activities.sorted(by: { $0.value.id < $1.value.id }), id: \.key) { _, activity in
//                        ActivityCard(activity: activity)
//                    }
//                }
//                .padding(.horizontal)
//            }
//
//        }
//        .onAppear {
//            Task {
//                // Call each metric data fetch asynchronously
//                await healthManager.fetchMetricData(for: .steps, timeFrame: .daily)
//                await healthManager.fetchMetricData(for: .calories, timeFrame: .weekly)
//                await healthManager.fetchMetricData(for: .flightsClimbed, timeFrame: .monthly)
//            }
//        }
//    }
//}

// Fetching Daily Data
//            healthManager.fetchMetricData(for: .steps, timeFrame: .daily)
//            healthManager.fetchMetricData(for: .calories, timeFrame: .daily)
//            healthManager.fetchMetricData(for: .flightsClimbed, timeFrame: .daily)
//            healthManager.fetchMetricData(for: .sleep, timeFrame: .daily)
//            healthManager.fetchMetricData(for: .walkingRunningDistance, timeFrame: .daily)

// Fetching Weekly Data:
//            healthManager.fetchMetricData(for: .steps, timeFrame: .weekly)
//            healthManager.fetchMetricData(for: .calories, timeFrame: .weekly)
//            healthManager.fetchMetricData(for: .flightsClimbed, timeFrame: .weekly)
//            healthManager.fetchMetricData(for: .sleep, timeFrame: .weekly)
//            healthManager.fetchMetricData(for: .walkingRunningDistance, timeFrame: .weekly)
//
//            // Fetching Monthly Data:
//            healthManager.fetchMetricData(for: .steps, timeFrame: .monthly)
//            healthManager.fetchMetricData(for: .calories, timeFrame: .monthly)
//            healthManager.fetchMetricData(for: .flightsClimbed, timeFrame: .monthly)
//            healthManager.fetchMetricData(for: .sleep, timeFrame: .monthly)
//            healthManager.fetchMetricData(for: .walkingRunningDistance, timeFrame: .monthly)
