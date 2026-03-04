//
//  AnalyticsView.swift
//  nurtureplus
//
//  Created on 2026-03-03.
//

import SwiftUI
import Charts

/// Analytics and charts screen
struct AnalyticsView: View {
    
    @StateObject private var viewModel = AnalyticsViewModel()
    @Environment(\.dismiss) private var dismiss
    @State private var babyProfileCount: Int = 0
    
    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(spacing: NurtureSpacing.xl) {
                    // Baby profile count indicator
                    babyProfileCountCard
                    
                    // Time range picker
                    timeRangePicker
                    
                    // Summary cards
                    summarySection
                    
                    // Feeding chart
                    feedingChartSection
                    
                    // Sleep chart
                    sleepChartSection
                    
                    // Diaper chart
                    diaperChartSection
                }
                .padding(NurtureSpacing.lg)
            }
            .background(NurtureColors.background)
            .navigationTitle("Analytics")
            #if os(iOS)
            .navigationBarTitleDisplayMode(.large)
            #endif
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("Done") {
                        dismiss()
                    }
                }
            }
            .task {
                loadBabyProfileCount()
            }
        }
    }
    
    // MARK: - Computed Properties
    
    /// Determines the stride count for x-axis labels based on time range
    private var xAxisStride: Int {
        switch viewModel.selectedTimeRange {
        case .week:
            return 1  // Show every day for 7 days
        case .twoWeeks:
            return 2  // Show every 2 days for 14 days
        case .month:
            return 5  // Show every 5 days for 30 days
        }
    }
    
    // MARK: - Baby Profile Count Card
    
    private var babyProfileCountCard: some View {
        HStack(spacing: NurtureSpacing.md) {
            // Circular icon with baby count
            Circle()
                .fill(
                    LinearGradient(
                        colors: [NurtureColors.primary, NurtureColors.primaryLight],
                        startPoint: .topLeading,
                        endPoint: .bottomTrailing
                    )
                )
                .frame(width: 50, height: 50)
                .overlay {
                    VStack(spacing: 2) {
                        Text("\(babyProfileCount)")
                            .font(.system(size: 20, weight: .bold))
                            .foregroundColor(.white)
                        
                        Text(babyProfileCount == 1 ? "baby" : "babies")
                            .font(.system(size: 8, weight: .semibold))
                            .foregroundColor(.white.opacity(0.9))
                    }
                }
            
            VStack(alignment: .leading, spacing: 2) {
                if let baby = viewModel.activeBabyProfile {
                    Text("\(baby.name)'s Analytics")
                        .font(.system(size: 17, weight: .semibold))
                        .foregroundColor(NurtureColors.textPrimary)
                    
                    Text("Tracking \(viewModel.selectedTimeRange.rawValue.lowercased())")
                        .font(.system(size: 14))
                        .foregroundColor(NurtureColors.textSecondary)
                } else {
                    Text("Analytics Overview")
                        .font(.system(size: 17, weight: .semibold))
                        .foregroundColor(NurtureColors.textPrimary)
                }
            }
            
            Spacer()
        }
        .padding(NurtureSpacing.md)
        .background(
            RoundedRectangle(cornerRadius: NurtureCornerRadius.md)
                .fill(NurtureColors.cardBackground)
        )
    }
    
    // MARK: - Time Range Picker
    
    private var timeRangePicker: some View {
        Picker("Time Range", selection: $viewModel.selectedTimeRange) {
            ForEach(TimeRange.allCases, id: \.self) { range in
                Text(range.rawValue).tag(range)
            }
        }
        .pickerStyle(.segmented)
        .onChange(of: viewModel.selectedTimeRange) { _, newValue in
            viewModel.changeTimeRange(newValue)
        }
    }
    
    // MARK: - Summary Section
    
    private var summarySection: some View {
        HStack(spacing: NurtureSpacing.md) {
            summaryCard(
                title: "Avg Feedings",
                value: String(format: "%.1f", viewModel.averageFeedingsPerDay),
                subtitle: "per day",
                color: NurtureColors.primary
            )
            
            summaryCard(
                title: "Avg Sleep",
                value: String(format: "%.1f", viewModel.averageSleepHours),
                subtitle: "hours/day",
                color: NurtureColors.accent
            )
        }
    }
    
    private func summaryCard(title: String, value: String, subtitle: String, color: Color) -> some View {
        NurtureCard {
            VStack(spacing: NurtureSpacing.sm) {
                Text(title)
                    .font(.system(size: 13))
                    .foregroundColor(NurtureColors.textSecondary)
                
                Text(value)
                    .font(.system(size: 32, weight: .bold))
                    .foregroundColor(color)
                
                Text(subtitle)
                    .font(.system(size: 12))
                    .foregroundColor(NurtureColors.textTertiary)
            }
            .frame(maxWidth: .infinity)
        }
    }
    
    // MARK: - Feeding Chart
    
    private var feedingChartSection: some View {
        VStack(alignment: .leading, spacing: NurtureSpacing.md) {
            Text("Feeding Trend")
                .font(.system(size: 20, weight: .semibold))
                .foregroundColor(NurtureColors.textPrimary)
            
            NurtureCard {
                if viewModel.dailyFeedingData.isEmpty {
                    emptyChartState(message: "No feeding data")
                } else {
                    Chart(viewModel.dailyFeedingData) { point in
                        BarMark(
                            x: .value("Date", point.date, unit: .day),
                            y: .value("Count", point.count)
                        )
                        .foregroundStyle(NurtureColors.primary)
                        .cornerRadius(4)
                    }
                    .frame(height: 200)
                    .chartXAxis {
                        AxisMarks(values: .stride(by: .day, count: xAxisStride)) { _ in
                            AxisValueLabel(format: .dateTime.day().month(.abbreviated))
                                .font(.system(size: 10))
                        }
                    }
                    .chartYAxis {
                        AxisMarks { value in
                            AxisValueLabel()
                                .font(.system(size: 10))
                        }
                    }
                }
            }
        }
    }
    
    // MARK: - Sleep Chart
    
    private var sleepChartSection: some View {
        VStack(alignment: .leading, spacing: NurtureSpacing.md) {
            Text("Sleep Pattern")
                .font(.system(size: 20, weight: .semibold))
                .foregroundColor(NurtureColors.textPrimary)
            
            NurtureCard {
                if viewModel.dailySleepData.isEmpty {
                    emptyChartState(message: "No sleep data")
                } else {
                    Chart(viewModel.dailySleepData) { point in
                        LineMark(
                            x: .value("Date", point.date, unit: .day),
                            y: .value("Hours", point.hours)
                        )
                        .foregroundStyle(NurtureColors.accent)
                        .interpolationMethod(.catmullRom)
                        
                        AreaMark(
                            x: .value("Date", point.date, unit: .day),
                            y: .value("Hours", point.hours)
                        )
                        .foregroundStyle(
                            LinearGradient(
                                colors: [NurtureColors.accent.opacity(0.3), NurtureColors.accent.opacity(0.05)],
                                startPoint: .top,
                                endPoint: .bottom
                            )
                        )
                        .interpolationMethod(.catmullRom)
                    }
                    .frame(height: 200)
                    .chartXAxis {
                        AxisMarks(values: .stride(by: .day, count: xAxisStride)) { _ in
                            AxisValueLabel(format: .dateTime.day().month(.abbreviated))
                                .font(.system(size: 10))
                        }
                    }
                    .chartYAxis {
                        AxisMarks { value in
                            AxisValueLabel()
                                .font(.system(size: 10))
                        }
                    }
                }
            }
        }
    }
    
    // MARK: - Diaper Chart
    
    private var diaperChartSection: some View {
        VStack(alignment: .leading, spacing: NurtureSpacing.md) {
            Text("Diaper Changes")
                .font(.system(size: 20, weight: .semibold))
                .foregroundColor(NurtureColors.textPrimary)
            
            NurtureCard {
                if viewModel.dailyDiaperData.isEmpty {
                    emptyChartState(message: "No diaper data")
                } else {
                    Chart(viewModel.dailyDiaperData) { point in
                        BarMark(
                            x: .value("Date", point.date, unit: .day),
                            y: .value("Count", point.count)
                        )
                        .foregroundStyle(NurtureColors.accentSecondary)
                        .cornerRadius(4)
                    }
                    .frame(height: 200)
                    .chartXAxis {
                        AxisMarks(values: .stride(by: .day, count: xAxisStride)) { _ in
                            AxisValueLabel(format: .dateTime.day().month(.abbreviated))
                                .font(.system(size: 10))
                        }
                    }
                    .chartYAxis {
                        AxisMarks { value in
                            AxisValueLabel()
                                .font(.system(size: 10))
                        }
                    }
                }
            }
        }
    }
    
    // MARK: - Empty State
    
    private func emptyChartState(message: String) -> some View {
        VStack(spacing: NurtureSpacing.md) {
            Image(systemName: "chart.bar")
                .font(.system(size: 40))
                .foregroundColor(NurtureColors.textTertiary)
            
            Text(message)
                .font(.system(size: 15))
                .foregroundColor(NurtureColors.textSecondary)
        }
        .frame(height: 200)
        .frame(maxWidth: .infinity)
    }
    
    // MARK: - Helper Methods
    
    private func loadBabyProfileCount() {
        let profiles = viewModel.allBabyProfiles
        babyProfileCount = profiles.count
    }
}

// MARK: - Preview

#Preview {
    AnalyticsView()
}
