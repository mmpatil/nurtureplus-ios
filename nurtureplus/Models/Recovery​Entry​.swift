//
//  RecoveryEntry.swift
//  nurtureplus
//
//  Created by Manali Maruti Pat on 3/3/26.
//

import Foundation

/// Represents a mom's recovery check-in entry
struct RecoveryEntry: Identifiable, Codable, Equatable, Hashable {
    let id: UUID
    let babyID: UUID
    var timestamp: Date
    var mood: MoodType
    var energyLevel: RecoveryEnergyLevel
    var waterIntakeOz: Int // ounces of water
    var symptoms: [Symptom]
    var notes: String
    
    init(
        id: UUID = UUID(),
        babyID: UUID,
        timestamp: Date = Date(),
        mood: MoodType = .okay,
        energyLevel: RecoveryEnergyLevel = .moderate,
        waterIntakeOz: Int = 0,
        symptoms: [Symptom] = [],
        notes: String = ""
    ) {
        self.id = id
        self.babyID = babyID
        self.timestamp = timestamp
        self.mood = mood
        self.energyLevel = energyLevel
        self.waterIntakeOz = waterIntakeOz
        self.symptoms = symptoms
        self.notes = notes
    }
    
    // MARK: - Computed Properties
    
    var summaryDescription: String {
        "\(mood.emoji) \(mood.displayName) • \(energyLevel.displayName) energy"
    }
    
    var symptomsSummary: String {
        if symptoms.isEmpty {
            return "No symptoms"
        }
        return symptoms.map { $0.displayName }.joined(separator: ", ")
    }
}

// MARK: - Mood Type

enum MoodType: String, Codable, CaseIterable, Hashable {
    case great
    case good
    case okay
    case struggling
    case overwhelmed
    
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
        case .great: return "primary"
        case .good: return "accent"
        case .okay: return "textSecondary"
        case .struggling: return "accentSecondary"
        case .overwhelmed: return "error"
        }
    }
}

// MARK: - Energy Level

enum RecoveryEnergyLevel: String, Codable, CaseIterable, Hashable {
    case veryLow
    case low
    case moderate
    case high
    case veryHigh
    
    var displayName: String {
        switch self {
        case .veryLow: return "Very Low"
        case .low: return "Low"
        case .moderate: return "Moderate"
        case .high: return "High"
        case .veryHigh: return "Very High"
        }
    }
    
    var emoji: String {
        switch self {
        case .veryLow: return "🔋"
        case .low: return "🪫"
        case .moderate: return "⚡️"
        case .high: return "✨"
        case .veryHigh: return "🌟"
        }
    }
}



// MARK: - Symptom

enum Symptom: String, Codable, CaseIterable, Hashable {
    case soreness
    case bleeding
    case cramping
    case breastPain
    case headache
    case nausea
    case anxiety
    case sadness
    case insomnia
    case hotFlashes
    
    var displayName: String {
        switch self {
        case .soreness: return "Soreness"
        case .bleeding: return "Bleeding"
        case .cramping: return "Cramping"
        case .breastPain: return "Breast Pain"
        case .headache: return "Headache"
        case .nausea: return "Nausea"
        case .anxiety: return "Anxiety"
        case .sadness: return "Sadness"
        case .insomnia: return "Insomnia"
        case .hotFlashes: return "Hot Flashes"
        }
    }
    
    var icon: String {
        switch self {
        case .soreness: return "bandage.fill"
        case .bleeding: return "drop.fill"
        case .cramping: return "waveform.path.ecg"
        case .breastPain: return "heart.fill"
        case .headache: return "brain.head.profile"
        case .nausea: return "stomach"
        case .anxiety: return "exclamationmark.triangle.fill"
        case .sadness: return "cloud.rain.fill"
        case .insomnia: return "moon.zzz.fill"
        case .hotFlashes: return "flame.fill"
        }
    }
}

