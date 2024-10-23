//
//  TempStatsView.swift
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

struct TempStatsView: View {
    @EnvironmentObject var healthManager: HealthManager
    @State private var selectedMetric: MetricType = .steps  // Default to Steps
    @State private var selectedChartPeriod: ChartPeriod = .day  // Default to Past Day

    var body: some View {
        VStack {
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
            ChartsView(
                metricType: selectedMetric,
                selectedChartPeriod: selectedChartPeriod
            )
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
