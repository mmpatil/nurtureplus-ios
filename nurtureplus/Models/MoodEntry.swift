//
//  MoodEntry.swift
//  nurtureplus
//
//  Created by Manali Maruti Pat on 3/3/26.
//

import Foundation

/// Represents a maternal mood/wellness check-in
struct MoodEntry: Identifiable, Codable, Equatable {
    
    // MARK: - Properties
    
    let id: String
    var timestamp: Date
    var mood: MoodLevel
    var energyLevel: EnergyLevel
    var notes: String?
    var createdAt: Date
    
    // MARK: - Initialization
    
    init(
        id: String = UUID().uuidString,
        timestamp: Date = Date(),
        mood: MoodLevel,
        energyLevel: EnergyLevel,
        notes: String? = nil,
        createdAt: Date = Date()
    ) {
        self.id = id
        self.timestamp = timestamp
        self.mood = mood
        self.energyLevel = energyLevel
        self.notes = notes
        self.createdAt = createdAt
    }
}

// MARK: - Mood Level

enum MoodLevel: String, Codable, CaseIterable {
    case great = "great"
    case good = "good"
    case okay = "okay"
    case struggling = "struggling"
    case overwhelmed = "overwhelmed"
    
    var displayName: String {
        switch self {
        case .great: return "Great"
        case .good: return "Good"
        case .okay: return "Okay"
        case .struggling: return "Struggling"
        case .overwhelmed: return "Overwhelmed"
        }
    }
    
    var emoji: String {
        switch self {
        case .great: return "😊"
        case .good: return "🙂"
        case .okay: return "😐"
        case .struggling: return "😔"
        case .overwhelmed: return "😰"
        }
    }
    
    var color: String {
        switch self {
        case .great: return "green"
        case .good: return "teal"
        case .okay: return "yellow"
        case .struggling: return "orange"
        case .overwhelmed: return "red"
        }
    }
}

// MARK: - Energy Level

enum EnergyLevel: String, Codable, CaseIterable {
    case high = "high"
    case moderate = "moderate"
    case low = "low"
    case exhausted = "exhausted"
    
    var displayName: String {
        switch self {
        case .high: return "High"
        case .moderate: return "Moderate"
        case .low: return "Low"
        case .exhausted: return "Exhausted"
        }
    }
    
    var icon: String {
        switch self {
        case .high: return "bolt.fill"
        case .moderate: return "bolt.horizontal.fill"
        case .low: return "bolt.slash.fill"
        case .exhausted: return "zzz"
        }
    }
}

// MARK: - Mock Data

extension MoodEntry {
    static let mock = MoodEntry(
        timestamp: Date(),
        mood: .good,
        energyLevel: .moderate,
        notes: "Feeling better after a good nap"
    )
    
    static let mockList: [MoodEntry] = [
        mock,
        MoodEntry(
            timestamp: Calendar.current.date(byAdding: .day, value: -1, to: Date())!,
            mood: .okay,
            energyLevel: .low
        ),
        MoodEntry(
            timestamp: Calendar.current.date(byAdding: .day, value: -2, to: Date())!,
            mood: .great,
            energyLevel: .high
        )
    ]
}

