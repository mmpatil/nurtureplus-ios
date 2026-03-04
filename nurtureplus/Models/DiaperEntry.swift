//
//  DiaperEntry.swift
//  nurtureplus
//
//  Created by Manali Maruti Pat on 3/3/26.
//

import Foundation

/// Represents a diaper change entry
struct DiaperEntry: Identifiable, Codable, Equatable {
    
    // MARK: - Properties
    
    let id: String
    let babyId: String
    var timestamp: Date
    var type: DiaperType
    var notes: String?
    var createdAt: Date
    
    // MARK: - Initialization
    
    init(
        id: String = UUID().uuidString,
        babyId: String,
        timestamp: Date = Date(),
        type: DiaperType,
        notes: String? = nil,
        createdAt: Date = Date()
    ) {
        self.id = id
        self.babyId = babyId
        self.timestamp = timestamp
        self.type = type
        self.notes = notes
        self.createdAt = createdAt
    }
    
    // MARK: - Computed Properties
    
    var summaryDescription: String {
        type.displayName
    }
}

// MARK: - Diaper Type

enum DiaperType: String, Codable, CaseIterable {
    case wet = "wet"
    case dirty = "dirty"
    case both = "both"
    case dry = "dry"
    
    var displayName: String {
        switch self {
        case .wet: return "Wet"
        case .dirty: return "Dirty"
        case .both: return "Wet & Dirty"
        case .dry: return "Dry"
        }
    }
    
    var icon: String {
        switch self {
        case .wet: return "drop.fill"
        case .dirty: return "leaf.fill"
        case .both: return "drop.triangle.fill"
        case .dry: return "checkmark.circle.fill"
        }
    }
    
    var iconColor: String {
        switch self {
        case .wet: return "blue"
        case .dirty: return "brown"
        case .both: return "purple"
        case .dry: return "green"
        }
    }
}

// MARK: - Mock Data

extension DiaperEntry {
    static let mock = DiaperEntry(
        babyId: BabyProfile.mock.id,
        timestamp: Date(),
        type: .both
    )
    
    static let mockList: [DiaperEntry] = [
        mock,
        DiaperEntry(
            babyId: BabyProfile.mock.id,
            timestamp: Calendar.current.date(byAdding: .hour, value: -2, to: Date())!,
            type: .wet
        ),
        DiaperEntry(
            babyId: BabyProfile.mock.id,
            timestamp: Calendar.current.date(byAdding: .hour, value: -5, to: Date())!,
            type: .dirty
        )
    ]
}

