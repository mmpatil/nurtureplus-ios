//
//  TrackingViewModel.swift
//  nurtureplus
//
//  Created by Manali Maruti Pat on 3/3/26.
//

import Foundation
import Combine

/// ViewModel for the Tracking screen
@MainActor
final class TrackingViewModel: ObservableObject {
    
    // MARK: - Published Properties
    
    @Published var babyProfile: BabyProfile?
    @Published var feedingEntries: [FeedingEntry] = []
    @Published var diaperEntries: [DiaperEntry] = []
    @Published var sleepEntries: [SleepEntry] = []
    @Published var isLoading: Bool = false
    @Published var selectedCategory: TrackingCategory = .feeding
    
    // MARK: - Dependencies
    
    private let dataManager = DataManager.shared
    
    // MARK: - Initialization
    
    init() {
        loadData()
    }
    
    // MARK: - Methods
    
    /// Load tracking data from persistence
    func loadData() {
        isLoading = true
        
        // Load baby profile
        babyProfile = dataManager.loadBabyProfile()
        
        // Load all entries (sorted by timestamp, newest first)
        feedingEntries = dataManager.loadFeedingEntries().sorted { $0.timestamp > $1.timestamp }
        diaperEntries = dataManager.loadDiaperEntries().sorted { $0.timestamp > $1.timestamp }
        sleepEntries = dataManager.loadSleepEntries().sorted { $0.startTime > $1.startTime }
        
        isLoading = false
    }
    
    /// Add a new feeding entry
    func addFeedingEntry(_ entry: FeedingEntry) {
        feedingEntries.insert(entry, at: 0)
        dataManager.addFeedingEntry(entry)
        print("✅ Added feeding entry")
    }
    
    /// Update an existing feeding entry
    func updateFeedingEntry(_ entry: FeedingEntry) {
        if let index = feedingEntries.firstIndex(where: { $0.id == entry.id }) {
            feedingEntries[index] = entry
        }
        
        var allEntries = dataManager.loadFeedingEntries()
        if let index = allEntries.firstIndex(where: { $0.id == entry.id }) {
            allEntries[index] = entry
            dataManager.saveFeedingEntries(allEntries)
            print("✅ Updated feeding entry")
        }
    }
    
    /// Add a new diaper entry
    func addDiaperEntry(_ entry: DiaperEntry) {
        diaperEntries.insert(entry, at: 0)
        dataManager.addDiaperEntry(entry)
        print("✅ Added diaper entry")
    }
    
    /// Update an existing diaper entry
    func updateDiaperEntry(_ entry: DiaperEntry) {
        if let index = diaperEntries.firstIndex(where: { $0.id == entry.id }) {
            diaperEntries[index] = entry
        }
        
        var allEntries = dataManager.loadDiaperEntries()
        if let index = allEntries.firstIndex(where: { $0.id == entry.id }) {
            allEntries[index] = entry
            dataManager.saveDiaperEntries(allEntries)
            print("✅ Updated diaper entry")
        }
    }
    
    /// Add a new sleep entry
    func addSleepEntry(_ entry: SleepEntry) {
        sleepEntries.insert(entry, at: 0)
        dataManager.addSleepEntry(entry)
        print("✅ Added sleep entry")
    }
    
    /// Update an existing sleep entry
    func updateSleepEntry(_ entry: SleepEntry) {
        if let index = sleepEntries.firstIndex(where: { $0.id == entry.id }) {
            sleepEntries[index] = entry
        }
        
        var allEntries = dataManager.loadSleepEntries()
        if let index = allEntries.firstIndex(where: { $0.id == entry.id }) {
            allEntries[index] = entry
            dataManager.saveSleepEntries(allEntries)
            print("✅ Updated sleep entry")
        }
    }
    
    /// Delete a feeding entry
    func deleteFeedingEntry(_ entry: FeedingEntry) {
        feedingEntries.removeAll { $0.id == entry.id }
        dataManager.deleteFeedingEntry(entry)
        print("🗑️ Deleted feeding entry")
    }
    
    /// Delete a diaper entry
    func deleteDiaperEntry(_ entry: DiaperEntry) {
        diaperEntries.removeAll { $0.id == entry.id }
        dataManager.deleteDiaperEntry(entry)
        print("🗑️ Deleted diaper entry")
    }
    
    /// Delete a sleep entry
    func deleteSleepEntry(_ entry: SleepEntry) {
        sleepEntries.removeAll { $0.id == entry.id }
        dataManager.deleteSleepEntry(entry)
        print("🗑️ Deleted sleep entry")
    }
    
    /// End an ongoing sleep session
    func endSleepSession(_ entry: SleepEntry) {
        guard entry.isOngoing else { return }
        
        var updatedEntry = entry
        updatedEntry.endTime = Date()
        
        // Remove old entry and add updated one
        sleepEntries.removeAll { $0.id == entry.id }
        sleepEntries.insert(updatedEntry, at: 0)
        
        // Update in persistence
        var allEntries = dataManager.loadSleepEntries()
        if let index = allEntries.firstIndex(where: { $0.id == entry.id }) {
            allEntries[index] = updatedEntry
            dataManager.saveSleepEntries(allEntries)
            print("✅ Ended sleep session")
        }
    }
}

// MARK: - Tracking Category

enum TrackingCategory: String, CaseIterable {
    case feeding
    case diaper
    case sleep
    
    var title: String {
        switch self {
        case .feeding: return "Feeding"
        case .diaper: return "Diapers"
        case .sleep: return "Sleep"
        }
    }
    
    var icon: String {
        switch self {
        case .feeding: return "waterbottle.fill"
        case .diaper: return "leaf.fill"
        case .sleep: return "moon.fill"
        }
    }
}

