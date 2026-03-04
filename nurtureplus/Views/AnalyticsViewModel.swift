//
//  AnalyticsViewModel.swift
//  nurtureplus
//
//  Created on 2026-03-03.
//

import Foundation
import Combine

/// ViewModel for analytics and charts
@MainActor
final class AnalyticsViewModel: ObservableObject {
    
    // MARK: - Published Properties
    
    @Published var feedingEntries: [FeedingEntry] = []
    @Published var diaperEntries: [DiaperEntry] = []
    @Published var sleepEntries: [SleepEntry] = []
    @Published var selectedTimeRange: TimeRange = .week
    @Published var isLoading = false
    
    // MARK: - Dependencies
    
    private let dataManager = DataManager.shared
    
    // MARK: - Computed Properties
    
    var activeBabyProfile: BabyProfile? {
        dataManager.getActiveBabyProfile()
    }
    
    var allBabyProfiles: [BabyProfile] {
        dataManager.loadAllBabyProfiles()
    }
    
    var dailyFeedingData: [DailyDataPoint] {
        aggregateDailyData(
            entries: feedingEntries,
            for: selectedTimeRange,
            keyPath: \.timestamp
        )
    }
    
    var dailySleepData: [DailySleepPoint] {
        aggregateDailySleep(for: selectedTimeRange)
    }
    
    var dailyDiaperData: [DailyDataPoint] {
        aggregateDailyData(
            entries: diaperEntries,
            for: selectedTimeRange,
            keyPath: \.timestamp
        )
    }
    
    var averageFeedingsPerDay: Double {
        guard !dailyFeedingData.isEmpty else { return 0 }
        let total = dailyFeedingData.reduce(0) { $0 + $1.count }
        return Double(total) / Double(dailyFeedingData.count)
    }
    
    var averageSleepHours: Double {
        guard !dailySleepData.isEmpty else { return 0 }
        let total = dailySleepData.reduce(0.0) { $0 + $1.hours }
        return total / Double(dailySleepData.count)
    }
    
    // MARK: - Initialization
    
    init() {
        loadData()
    }
    
    // MARK: - Methods
    
    func loadData() {
        isLoading = true
        
        guard let babyId = dataManager.getActiveBabyProfile()?.id else {
            isLoading = false
            return
        }
        
        // Load all entries for active baby
        let allFeedings = dataManager.loadFeedingEntries().filter { $0.babyId == babyId }
        let allDiapers = dataManager.loadDiaperEntries().filter { $0.babyId == babyId }
        let allSleep = dataManager.loadSleepEntries().filter { $0.babyId == babyId }
        
        // Filter by time range
        let startDate = selectedTimeRange.startDate
        feedingEntries = allFeedings.filter { $0.timestamp >= startDate }
        diaperEntries = allDiapers.filter { $0.timestamp >= startDate }
        sleepEntries = allSleep.filter { $0.startTime >= startDate }
        
        isLoading = false
    }
    
    func changeTimeRange(_ range: TimeRange) {
        selectedTimeRange = range
        loadData()
    }
    
    // MARK: - Data Aggregation
    
    private func aggregateDailyData<T>(
        entries: [T],
        for range: TimeRange,
        keyPath: KeyPath<T, Date>
    ) -> [DailyDataPoint] {
        let calendar = Calendar.current
        let days = range.numberOfDays
        let startDate = range.startDate
        
        var dataPoints: [DailyDataPoint] = []
        
        for day in 0..<days {
            guard let date = calendar.date(byAdding: .day, value: day, to: startDate) else { continue }
            let dayStart = calendar.startOfDay(for: date)
            
            let count = entries.filter { entry in
                let entryDate = entry[keyPath: keyPath]
                return calendar.isDate(entryDate, inSameDayAs: dayStart)
            }.count
            
            dataPoints.append(DailyDataPoint(date: dayStart, count: count))
        }
        
        return dataPoints
    }
    
    private func aggregateDailySleep(for range: TimeRange) -> [DailySleepPoint] {
        let calendar = Calendar.current
        let days = range.numberOfDays
        let startDate = range.startDate
        
        var dataPoints: [DailySleepPoint] = []
        
        for day in 0..<days {
            guard let date = calendar.date(byAdding: .day, value: day, to: startDate) else { continue }
            let dayStart = calendar.startOfDay(for: date)
            
            let daySleepEntries = sleepEntries.filter { entry in
                calendar.isDate(entry.startTime, inSameDayAs: dayStart)
            }
            
            let totalMinutes = daySleepEntries.compactMap { $0.durationMinutes }.reduce(0, +)
            let hours = Double(totalMinutes) / 60.0
            
            dataPoints.append(DailySleepPoint(date: dayStart, hours: hours))
        }
        
        return dataPoints
    }
}

// MARK: - Time Range

enum TimeRange: String, CaseIterable {
    case week = "7 Days"
    case twoWeeks = "14 Days"
    case month = "30 Days"
    
    var numberOfDays: Int {
        switch self {
        case .week: return 7
        case .twoWeeks: return 14
        case .month: return 30
        }
    }
    
    var startDate: Date {
        let calendar = Calendar.current
        let days = -numberOfDays + 1
        return calendar.date(byAdding: .day, value: days, to: calendar.startOfDay(for: Date()))!
    }
}

// MARK: - Data Models

struct DailyDataPoint: Identifiable {
    let id = UUID()
    let date: Date
    let count: Int
}

struct DailySleepPoint: Identifiable {
    let id = UUID()
    let date: Date
    let hours: Double
}
