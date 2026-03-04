//
//  DataManager.swift
//  nurtureplus
//
//  Created on 2026-03-03.
//

import Foundation
import Combine

/// Manages local data persistence using UserDefaults
/// Will be replaced with Firebase in the future
final class DataManager: ObservableObject {
    
    // MARK: - Singleton
    
    static let shared = DataManager()
    
    // MARK: - Initialization
    
    private init() {}
    
    // MARK: - UserDefaults Keys
    
    private enum Keys {
        static let babyProfiles = "babyProfiles" // Changed to array
        static let activeBabyProfileId = "activeBabyProfileId"
        static let feedingEntries = "feedingEntries"
        static let diaperEntries = "diaperEntries"
        static let sleepEntries = "sleepEntries"
        static let moodEntries = "moodEntries"
        static let recoveryEntries = "recoveryEntries"
    }
    
    // MARK: - Baby Profiles (Multiple Support)
    
    func saveAllBabyProfiles(_ profiles: [BabyProfile]) {
        if let encoded = try? JSONEncoder().encode(profiles) {
            UserDefaults.standard.set(encoded, forKey: Keys.babyProfiles)
            print("✅ Saved \(profiles.count) baby profiles")
        }
    }
    
    func loadAllBabyProfiles() -> [BabyProfile] {
        guard let data = UserDefaults.standard.data(forKey: Keys.babyProfiles),
              let profiles = try? JSONDecoder().decode([BabyProfile].self, from: data) else {
            return []
        }
        print("✅ Loaded \(profiles.count) baby profiles")
        return profiles
    }
    
    func addBabyProfile(_ profile: BabyProfile) {
        var profiles = loadAllBabyProfiles()
        profiles.append(profile)
        saveAllBabyProfiles(profiles)
        
        // Set as active if it's the first profile
        if profiles.count == 1 {
            setActiveBabyProfile(profile.id)
        }
    }
    
    func updateBabyProfile(_ profile: BabyProfile) {
        var profiles = loadAllBabyProfiles()
        if let index = profiles.firstIndex(where: { $0.id == profile.id }) {
            profiles[index] = profile
            saveAllBabyProfiles(profiles)
            print("✅ Updated baby profile: \(profile.name)")
        }
    }
    
    func deleteBabyProfile(_ profileId: String) {
        var profiles = loadAllBabyProfiles()
        profiles.removeAll { $0.id == profileId }
        saveAllBabyProfiles(profiles)
        
        // If deleted profile was active, switch to first available
        if getActiveBabyProfileId() == profileId {
            if let firstProfile = profiles.first {
                setActiveBabyProfile(firstProfile.id)
            } else {
                UserDefaults.standard.removeObject(forKey: Keys.activeBabyProfileId)
            }
        }
        
        print("🗑️ Deleted baby profile")
    }
    
    // MARK: - Active Baby Profile
    
    func setActiveBabyProfile(_ profileId: String) {
        UserDefaults.standard.set(profileId, forKey: Keys.activeBabyProfileId)
        print("✅ Set active baby profile: \(profileId)")
    }
    
    func getActiveBabyProfileId() -> String? {
        return UserDefaults.standard.string(forKey: Keys.activeBabyProfileId)
    }
    
    func getActiveBabyProfile() -> BabyProfile? {
        guard let activeId = getActiveBabyProfileId() else { return nil }
        return loadAllBabyProfiles().first { $0.id == activeId }
    }
    
    // MARK: - Legacy Support (for backward compatibility)
    
    func saveBabyProfile(_ profile: BabyProfile) {
        var profiles = loadAllBabyProfiles()
        if let index = profiles.firstIndex(where: { $0.id == profile.id }) {
            profiles[index] = profile
        } else {
            profiles.append(profile)
            if profiles.count == 1 {
                setActiveBabyProfile(profile.id)
            }
        }
        saveAllBabyProfiles(profiles)
    }
    
    func loadBabyProfile() -> BabyProfile? {
        return getActiveBabyProfile()
    }
    
    func deleteBabyProfile() {
        if let activeId = getActiveBabyProfileId() {
            deleteBabyProfile(activeId)
        }
    }
    
    // MARK: - Feeding Entries
    
    func saveFeedingEntries(_ entries: [FeedingEntry]) {
        if let encoded = try? JSONEncoder().encode(entries) {
            UserDefaults.standard.set(encoded, forKey: Keys.feedingEntries)
            print("✅ Saved \(entries.count) feeding entries")
        }
    }
    
    func loadFeedingEntries() -> [FeedingEntry] {
        guard let data = UserDefaults.standard.data(forKey: Keys.feedingEntries),
              let entries = try? JSONDecoder().decode([FeedingEntry].self, from: data) else {
            return []
        }
        print("✅ Loaded \(entries.count) feeding entries")
        return entries
    }
    
    func addFeedingEntry(_ entry: FeedingEntry) {
        var entries = loadFeedingEntries()
        entries.insert(entry, at: 0)
        saveFeedingEntries(entries)
    }
    
    func deleteFeedingEntry(_ entry: FeedingEntry) {
        var entries = loadFeedingEntries()
        entries.removeAll { $0.id == entry.id }
        saveFeedingEntries(entries)
    }
    
    // MARK: - Diaper Entries
    
    func saveDiaperEntries(_ entries: [DiaperEntry]) {
        if let encoded = try? JSONEncoder().encode(entries) {
            UserDefaults.standard.set(encoded, forKey: Keys.diaperEntries)
            print("✅ Saved \(entries.count) diaper entries")
        }
    }
    
    func loadDiaperEntries() -> [DiaperEntry] {
        guard let data = UserDefaults.standard.data(forKey: Keys.diaperEntries),
              let entries = try? JSONDecoder().decode([DiaperEntry].self, from: data) else {
            return []
        }
        print("✅ Loaded \(entries.count) diaper entries")
        return entries
    }
    
    func addDiaperEntry(_ entry: DiaperEntry) {
        var entries = loadDiaperEntries()
        entries.insert(entry, at: 0)
        saveDiaperEntries(entries)
    }
    
    func deleteDiaperEntry(_ entry: DiaperEntry) {
        var entries = loadDiaperEntries()
        entries.removeAll { $0.id == entry.id }
        saveDiaperEntries(entries)
    }
    
    // MARK: - Sleep Entries
    
    func saveSleepEntries(_ entries: [SleepEntry]) {
        if let encoded = try? JSONEncoder().encode(entries) {
            UserDefaults.standard.set(encoded, forKey: Keys.sleepEntries)
            print("✅ Saved \(entries.count) sleep entries")
        }
    }
    
    func loadSleepEntries() -> [SleepEntry] {
        guard let data = UserDefaults.standard.data(forKey: Keys.sleepEntries),
              let entries = try? JSONDecoder().decode([SleepEntry].self, from: data) else {
            return []
        }
        print("✅ Loaded \(entries.count) sleep entries")
        return entries
    }
    
    func addSleepEntry(_ entry: SleepEntry) {
        var entries = loadSleepEntries()
        entries.insert(entry, at: 0)
        saveSleepEntries(entries)
    }
    
    func deleteSleepEntry(_ entry: SleepEntry) {
        var entries = loadSleepEntries()
        entries.removeAll { $0.id == entry.id }
        saveSleepEntries(entries)
    }
    
    // MARK: - Mood Entries
    
    func saveMoodEntries(_ entries: [MoodEntry]) {
        if let encoded = try? JSONEncoder().encode(entries) {
            UserDefaults.standard.set(encoded, forKey: Keys.moodEntries)
            print("✅ Saved \(entries.count) mood entries")
        }
    }
    
    func loadMoodEntries() -> [MoodEntry] {
        guard let data = UserDefaults.standard.data(forKey: Keys.moodEntries),
              let entries = try? JSONDecoder().decode([MoodEntry].self, from: data) else {
            return []
        }
        print("✅ Loaded \(entries.count) mood entries")
        return entries
    }
    
    func addMoodEntry(_ entry: MoodEntry) {
        var entries = loadMoodEntries()
        entries.insert(entry, at: 0)
        saveMoodEntries(entries)
    }
    
    func deleteMoodEntry(_ entry: MoodEntry) {
        var entries = loadMoodEntries()
        entries.removeAll { $0.id == entry.id }
        saveMoodEntries(entries)
    }
    
    // MARK: - Recovery Entries
    
    func saveRecoveryEntries(_ entries: [RecoveryEntry]) {
        if let encoded = try? JSONEncoder().encode(entries) {
            UserDefaults.standard.set(encoded, forKey: Keys.recoveryEntries)
            print("✅ Saved \(entries.count) recovery entries")
        }
    }
    
    func loadRecoveryEntries(for babyID: UUID) throws -> [RecoveryEntry] {
        guard let data = UserDefaults.standard.data(forKey: Keys.recoveryEntries),
              let entries = try? JSONDecoder().decode([RecoveryEntry].self, from: data) else {
            return []
        }
        let filtered = entries.filter { $0.babyID == babyID }
        print("✅ Loaded \(filtered.count) recovery entries for baby \(babyID)")
        return filtered
    }
    
    func saveRecoveryEntry(_ entry: RecoveryEntry) throws {
        var entries = (try? loadRecoveryEntries(for: entry.babyID)) ?? []
        // Load all entries first
        if let data = UserDefaults.standard.data(forKey: Keys.recoveryEntries),
           let allEntries = try? JSONDecoder().decode([RecoveryEntry].self, from: data) {
            var combined = allEntries
            combined.append(entry)
            saveRecoveryEntries(combined)
        } else {
            saveRecoveryEntries([entry])
        }
        print("✅ Saved recovery entry")
    }
    
    func updateRecoveryEntry(_ entry: RecoveryEntry) throws {
        guard let data = UserDefaults.standard.data(forKey: Keys.recoveryEntries),
              var entries = try? JSONDecoder().decode([RecoveryEntry].self, from: data) else {
            throw NSError(domain: "DataManager", code: 404, userInfo: [NSLocalizedDescriptionKey: "No entries found"])
        }
        
        if let index = entries.firstIndex(where: { $0.id == entry.id }) {
            entries[index] = entry
            saveRecoveryEntries(entries)
            print("✅ Updated recovery entry")
        } else {
            throw NSError(domain: "DataManager", code: 404, userInfo: [NSLocalizedDescriptionKey: "Entry not found"])
        }
    }
    
    func deleteRecoveryEntry(_ entry: RecoveryEntry) throws {
        guard let data = UserDefaults.standard.data(forKey: Keys.recoveryEntries),
              var entries = try? JSONDecoder().decode([RecoveryEntry].self, from: data) else {
            return
        }
        
        entries.removeAll { $0.id == entry.id }
        saveRecoveryEntries(entries)
        print("🗑️ Deleted recovery entry")
    }
    
    // MARK: - Reset All Data
    
    func resetAllData() {
        UserDefaults.standard.removeObject(forKey: Keys.babyProfiles)
        UserDefaults.standard.removeObject(forKey: Keys.activeBabyProfileId)
        UserDefaults.standard.removeObject(forKey: Keys.feedingEntries)
        UserDefaults.standard.removeObject(forKey: Keys.diaperEntries)
        UserDefaults.standard.removeObject(forKey: Keys.sleepEntries)
        UserDefaults.standard.removeObject(forKey: Keys.moodEntries)
        UserDefaults.standard.removeObject(forKey: Keys.recoveryEntries)
        print("🗑️ Reset all data")
    }
}
