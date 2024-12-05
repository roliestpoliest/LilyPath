//
//  ChartsView.swift
//  LilyPath
//
//  Created by Carolyn Heron on 10/23/24.
//

import Charts
import SwiftUI

struct ChartsView: View {
    @EnvironmentObject var healthManager: HealthManager
    var metricType: MetricType
    var selectedChartPeriod: ChartPeriod

    var body: some View {
        VStack {
            ViewTitle(title: metricType.fluentDisplayName.capitalized)
            
            Grid(verticalSpacing: 10) {
                GridRow {
                    Text(chartPeriodDisplay())
                        .font(.statsBodyBold)
                        .frame(maxWidth: .infinity, alignment: .leading)
                    Text(chartPeriodDateRange())
                        .font(.statsBodyBold)
                        .frame(maxWidth: .infinity, alignment: .leading)
                }
                
                GridRow {
                    Text("Total \(metricType.displayName)")
                        .font(.statsBodyBold)
                        .frame(maxWidth: .infinity, alignment: .leading)
                    Text("\(Int(totalMetricCount()))")
                        .font(.statsBodyBold)
                        .frame(maxWidth: .infinity, alignment: .leading)
                }
                
                GridRow {
                    Text("Average \(metricType.displayName)")
                        .font(.statsBodyBold)
                        .frame(maxWidth: .infinity, alignment: .leading)
                    Text(
                        "\(String(format: "%.1f", averageMetricCountPerPeriod()))/\(selectedChartPeriod == .day ? "hour" : selectedChartPeriod == .week ? "day" : "week")"
                    )
                    .font(.statsBodyBold)
                    .frame(maxWidth: .infinity, alignment: .leading)
                }
            }
            .foregroundColor(.customBrown)
            .frame(maxWidth: .infinity, alignment: .center)
            .padding(.bottom, 20)
            
            // Chart section
            if selectedChartData().isEmpty {
                Text("Loading chart data...")
            } else {
                Chart(selectedChartData()) { dataPoint in
                    BarMark(
                        x: .value(
                            "Date", dataPoint.date, unit: chartUnit()),
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
                                Text(formatYValue(yValue))
                                    .foregroundColor(.customBrown)
                                    .font(.chartAxisLabels)
                            }
                        }
                    }
                }
                .chartYScale(domain: 0...maxYValue())
                .frame(
                    maxWidth: .infinity, maxHeight: 280
                )
                .padding(15)
                .background(
                    RoundedRectangle(cornerRadius: 20)
                        .fill(.white.opacity(0.8))
                        .overlay(
                            RoundedRectangle(cornerRadius: 20)
                                .inset(by: 3)
                                .stroke(Color.lightBlue, lineWidth: 6)
                        )
                )
                
            }
            
            Spacer()
        }
        .onAppear {
            Task {
                await fetchMetricDataForSelectedTypeAndPeriod()
            }
        }
        
        .background(Color.mainBackground)
    }

    private func chartPeriodDisplay() -> String {
        switch selectedChartPeriod {
        case .day:
            return "Day"
        case .week:
            return "Week"
        case .month:
            return "Month"
        }
    }

    private func chartPeriodDateRange() -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "MMM d"

        let calendar = Calendar.current
        switch selectedChartPeriod {
        case .day:
            let startOfDay = calendar.startOfDay(for: Date())
            return dateFormatter.string(from: startOfDay)

        case .week:
            let startOfWeek = calendar.date(
                from: calendar.dateComponents(
                    [.yearForWeekOfYear, .weekOfYear], from: Date()))!
            let endOfWeek = calendar.date(
                byAdding: .day, value: 6, to: startOfWeek)!
            return
                "\(dateFormatter.string(from: startOfWeek)) - \(dateFormatter.string(from: endOfWeek))"
        case .month:
            let startOfMonth = calendar.date(
                from: calendar.dateComponents([.year, .month], from: Date()))!
            dateFormatter.dateFormat = "MMMM"
            return dateFormatter.string(from: startOfMonth)
        }
    }

    private func fetchMetricDataForSelectedTypeAndPeriod() async {
        switch selectedChartPeriod {
        case .day:
            await healthManager.fetchPastDayData(for: metricType)
        case .week:
            await healthManager.fetchPastWeekData(for: metricType)
        case .month:
            await healthManager.fetchPastMonthData(for: metricType)
        }
    }

    private func selectedChartData() -> [HealthDataPoint] {
        switch selectedChartPeriod {
        case .day:
            return healthManager.oneDayChartData.isEmpty
                ? generateZeroValueData(for: .day)
                : healthManager.oneDayChartData
        case .week:
            return healthManager.oneWeekChartData.isEmpty
                ? generateZeroValueData(for: .week)
                : healthManager.oneWeekChartData
        case .month:
            return healthManager.oneMonthChartData.isEmpty
                ? generateZeroValueData(for: .month)
                : healthManager.oneMonthChartData
        }
    }

    private func generateZeroValueData(for period: ChartPeriod)
        -> [HealthDataPoint]
    {
        let dates: [Date]
        switch period {
        case .day:
            dates = stride(
                from: Date.startOfDay, to: Date.endOfDay, by: 60 * 60
            ).map { $0 }
        case .week:
            dates = stride(
                from: Date.startOfWeek, to: Date.endOfWeek, by: 60 * 60 * 24
            ).map { $0 }
        case .month:
            dates = stride(
                from: Date.startOfMonth, through: Date.endOfMonth,
                by: 60 * 60 * 24 * 7
            ).map { $0 }
        }
        return dates.map { HealthDataPoint(date: $0, value: 0) }
    }

    private func totalMetricCount() -> Double {
        selectedChartData().reduce(0) { $0 + $1.value }
    }

    private func averageMetricCountPerPeriod() -> Double {
        let dataCount = selectedChartData().count
        return dataCount > 0 ? totalMetricCount() / Double(dataCount) : 0
    }

    private func formatXAxisLabel(for date: Date) -> String {
        switch selectedChartPeriod {
        case .day:
            return date.formatted(.dateTime.hour())
        case .week:
            return date.formatted(.dateTime.weekday(.abbreviated))
        case .month:
            return date.formatted(.dateTime.day())
        }
    }

    private func xAxisValues() -> [Date] {
        let calendar = Calendar.current

        switch selectedChartPeriod {
        case .day:
            let startOfDay = Date.startOfDay
            let endOfDay =
                calendar.date(byAdding: .day, value: 1, to: startOfDay)
                ?? Date()
            return stride(from: startOfDay, to: endOfDay, by: 60 * 60 * 6).map {
                $0
            }
        case .week:
            return stride(from: .startOfWeek, to: .endOfWeek, by: 60 * 60 * 24)
                .map { $0 }
        case .month:
            return stride(
                from: .startOfMonth, through: .endOfMonth, by: 60 * 60 * 24 * 7
            ).map { $0 }
        }
    }

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
                ? Color.waterBlue : Color.darkerBlue
        case .week, .month:
            return calendar.isDateInToday(date)
                ? Color.waterBlue : Color.darkerBlue
        }
    }

    private func maxYValue() -> Double {
        let maxValue = selectedChartData().map { $0.value }.max() ?? 0
        return maxValue > 0 ? (maxValue * 1.2) : 10
    }

    private func formatYValue(_ value: Double) -> String {
        if value.truncatingRemainder(dividingBy: 1) == 0 {
            return "\(Int(value))"
        } else {
            return String(format: "%.1f", value)
        }
    }
}

#Preview {
    ChartsView(metricType: .steps, selectedChartPeriod: .day)
        .environmentObject(HealthManager())
}
