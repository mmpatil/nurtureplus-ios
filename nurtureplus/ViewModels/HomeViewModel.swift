//
//  HomeViewModel.swift
//  nurtureplus
//
//  Created by Manali Maruti Pat on 3/3/26.
//

import Foundation
import Combine

/// ViewModel for the Home screen
@MainActor
final class HomeViewModel: ObservableObject {
    
    // MARK: - Published Properties
    
    @Published var babyProfile: BabyProfile?
    @Published var todayFeedings: [FeedingEntry] = []
    @Published var todayDiapers: [DiaperEntry] = []
    @Published var todaySleep: [SleepEntry] = []
    @Published var recentMood: MoodEntry?
    @Published var isLoading: Bool = false
    
    // MARK: - Dependencies
    
    private let dataManager = DataManager.shared
    
    // MARK: - Computed Properties
    
    /// Total feeding count for today
    var todayFeedingCount: Int {
        todayFeedings.count
    }
    
    /// Total diaper count for today
    var todayDiaperCount: Int {
        todayDiapers.count
    }
    
    /// Total sleep hours for today
    var todaySleepHours: Double {
        let totalMinutes = todaySleep.compactMap { $0.durationMinutes }.reduce(0, +)
        return Double(totalMinutes) / 60.0
    }
    
    /// Last feeding time description
    var lastFeedingDescription: String? {
        guard let lastFeeding = todayFeedings.first else { return nil }
        return formatRelativeTime(lastFeeding.timestamp)
    }
    
    /// Current ongoing sleep session
    var ongoingSleep: SleepEntry? {
        todaySleep.first(where: { $0.isOngoing })
    }
    
    // MARK: - Initialization
    
    init() {
        loadData()
    }
    
    // MARK: - Methods
    
    /// Load data from persistence
    func loadData() {
        isLoading = true
        
        // Load baby profile
        babyProfile = dataManager.loadBabyProfile()
        
        // If no profile exists, create mock data for demo
        if babyProfile == nil {
            let mockProfile = BabyProfile.mock
            dataManager.saveBabyProfile(mockProfile)
            babyProfile = mockProfile
        }
        
        // Load all entries
        let allFeedings = dataManager.loadFeedingEntries()
        let allDiapers = dataManager.loadDiaperEntries()
        let allSleep = dataManager.loadSleepEntries()
        let allMoods = dataManager.loadMoodEntries()
        
        // If no data exists, load mock data for demo
        if allFeedings.isEmpty && allDiapers.isEmpty && allSleep.isEmpty {
            loadMockDataForDemo()
        } else {
            // Filter to today's entries
            todayFeedings = filterToday(allFeedings)
            todayDiapers = filterToday(allDiapers)
            todaySleep = filterToday(allSleep)
            recentMood = allMoods.first
        }
        
        isLoading = false
    }
    
    /// Load mock data for first-time demo
    private func loadMockDataForDemo() {
        // Save mock entries
        let mockFeedings = FeedingEntry.mockList
        let mockDiapers = DiaperEntry.mockList
        let mockSleep = SleepEntry.mockList
        let mockMoods = MoodEntry.mockList
        
        dataManager.saveFeedingEntries(mockFeedings)
        dataManager.saveDiaperEntries(mockDiapers)
        dataManager.saveSleepEntries(mockSleep)
        dataManager.saveMoodEntries(mockMoods)
        
        todayFeedings = mockFeedings
        todayDiapers = mockDiapers
        todaySleep = mockSleep
        recentMood = mockMoods.first
        
        print("📱 Loaded mock data for demo")
    }
    
    /// Refresh all data
    func refresh() async {
        loadData()
    }
    
    // MARK: - Helpers
    
    private func filterToday<T>(_ entries: [T]) -> [T] where T: HasTimestamp {
        let calendar = Calendar.current
        let today = calendar.startOfDay(for: Date())
        
        return entries.filter { entry in
            calendar.isDate(entry.timestamp, inSameDayAs: today)
        }
    }
    
    private func formatRelativeTime(_ date: Date) -> String {
        let formatter = RelativeDateTimeFormatter()
        formatter.unitsStyle = .short
        return formatter.localizedString(for: date, relativeTo: Date())
    }
}

// MARK: - HasTimestamp Protocol
protocol HasTimestamp {
    var timestamp: Date { get }
}

extension FeedingEntry: HasTimestamp {}
extension DiaperEntry: HasTimestamp {}

extension SleepEntry: HasTimestamp {
    var timestamp: Date { startTime }
}


