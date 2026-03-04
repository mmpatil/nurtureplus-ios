//
//  FeedingEntry.swift
//  nurtureplus
//
//  Created by Manali Maruti Pat on 3/3/26.
//

import Foundation

/// Represents a feeding session entry
struct FeedingEntry: Identifiable, Codable, Equatable {
    
    // MARK: - Properties
    
    let id: String
    let babyId: String
    var timestamp: Date
    var feedingType: FeedingType
    var durationMinutes: Int? // For breastfeeding
    var amountML: Double? // For bottle feeding
    var notes: String?
    var createdAt: Date
    
    // MARK: - Initialization
    
    init(
        id: String = UUID().uuidString,
        babyId: String,
        timestamp: Date = Date(),
        feedingType: FeedingType,
        durationMinutes: Int? = nil,
        amountML: Double? = nil,
        notes: String? = nil,
        createdAt: Date = Date()
    ) {
        self.id = id
        self.babyId = babyId
        self.timestamp = timestamp
        self.feedingType = feedingType
        self.durationMinutes = durationMinutes
        self.amountML = amountML
        self.notes = notes
        self.createdAt = createdAt
    }
    
    // MARK: - Computed Properties
    
    /// Summary description for the feeding
    var summaryDescription: String {
        switch feedingType {
        case .breastLeft, .breastRight, .breastBoth:
            if let duration = durationMinutes {
                return "\(feedingType.displayName) • \(duration) min"
            }
            return feedingType.displayName
            
        case .bottle, .pumped:
            if let amount = amountML {
                return "\(feedingType.displayName) • \(Int(amount)) ml"
            }
            return feedingType.displayName
        }
    }
}

// MARK: - Feeding Type

enum FeedingType: String, Codable, CaseIterable {
    case breastLeft = "breast_left"
    case breastRight = "breast_right"
    case breastBoth = "breast_both"
    case bottle = "bottle"
    case pumped = "pumped"
    
    var displayName: String {
        switch self {
        case .breastLeft: return "Breast (Left)"
        case .breastRight: return "Breast (Right)"
        case .breastBoth: return "Breast (Both)"
        case .bottle: return "Bottle"
        case .pumped: return "Pumped Milk"
        }
    }
    
    var icon: String {
        switch self {
        case .breastLeft, .breastRight, .breastBoth: return "figure.mind.and.body"
        case .bottle: return "waterbottle.fill"
        case .pumped: return "drop.fill"
        }
    }
}

// MARK: - Mock Data

extension FeedingEntry {
    static let mock = FeedingEntry(
        babyId: BabyProfile.mock.id,
        timestamp: Date(),
        feedingType: .breastBoth,
        durationMinutes: 20
    )
    
    static let mockBottle = FeedingEntry(
        babyId: BabyProfile.mock.id,
        timestamp: Calendar.current.date(byAdding: .hour, value: -3, to: Date())!,
        feedingType: .bottle,
        amountML: 120
    )
    
    static let mockList: [FeedingEntry] = [
        mock,
        mockBottle,
        FeedingEntry(
            babyId: BabyProfile.mock.id,
            timestamp: Calendar.current.date(byAdding: .hour, value: -6, to: Date())!,
            feedingType: .breastLeft,
            durationMinutes: 15
        )
    ]
}

