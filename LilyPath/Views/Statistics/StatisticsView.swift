//
//  StatisticsView.swift
//  LilyPath
//
//  Created by Carolyn Heron on 9/29/24.
//

import SwiftUI
import Charts

struct ChartsView: View {
    @EnvironmentObject var healthManager: HealthManager
    
    var body: some View {
        GeometryReader { geometry in  // Use GeometryReader to get the screen width
            VStack {
                if healthManager.oneMonthChartData.isEmpty {
                    Text("Loading chart data...")
                } else {
                    Chart(healthManager.oneMonthChartData) { daily in
                        BarMark(
                            x: .value("Date", daily.date, unit: .day),
                            y: .value("Steps", daily.value)
                        )
                        .foregroundStyle(
                            Calendar.current.isDateInToday(daily.date) ? Color.waterBlue : Color.darkerBlue
                        )
                    }
                    .chartXAxis {
                        AxisMarks(values: .stride(by: .day, count: 7)) { value in  // Show every 7th day to avoid clutter
                            AxisGridLine()
                                .foregroundStyle(.black)
                            AxisValueLabel {
                                if let dateValue = value.as(Date.self) {
                                    Text(dateValue, format: .dateTime.day())  // Show only the day number
                                        .foregroundColor(.customBrown)
                                        .layoutPriority(1)  // Increase priority to avoid truncation
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
                    .frame(width: geometry.size.width - 20, height: 300)  // Add a small margin to ensure everything fits
                    .padding(.horizontal, 10)  // Add horizontal padding for better aesthetics
                    .padding(.top, 10)  // Add some padding at the top to avoid the chart touching the top

                }
            }
        }
        .onAppear {
            Task {
                await healthManager.fetchPastMonthData()
            }
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
