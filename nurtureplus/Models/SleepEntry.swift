//
//  SleepEntry.swift
//  nurtureplus
//
//  Created by Manali Maruti Pat on 3/3/26.
//

import Foundation

/// Represents a sleep session entry
struct SleepEntry: Identifiable, Codable, Equatable {
    
    // MARK: - Properties
    
    let id: String
    let babyId: String
    var startTime: Date
    var endTime: Date?
    var notes: String?
    var createdAt: Date
    
    // MARK: - Initialization
    
    init(
        id: String = UUID().uuidString,
        babyId: String,
        startTime: Date = Date(),
        endTime: Date? = nil,
        notes: String? = nil,
        createdAt: Date = Date()
    ) {
        self.id = id
        self.babyId = babyId
        self.startTime = startTime
        self.endTime = endTime
        self.notes = notes
        self.createdAt = createdAt
    }
    
    // MARK: - Computed Properties
    
    /// Whether the sleep session is currently ongoing
    var isOngoing: Bool {
        endTime == nil
    }
    
    /// Duration of the sleep session in minutes
    var durationMinutes: Int? {
        guard let endTime = endTime else { return nil }
        return Int(endTime.timeIntervalSince(startTime) / 60)
    }
    
    /// Duration formatted as hours and minutes
    var durationDescription: String {
        if let duration = durationMinutes {
            let hours = duration / 60
            let minutes = duration % 60
            
            if hours > 0 && minutes > 0 {
                return "\(hours)h \(minutes)m"
            } else if hours > 0 {
                return "\(hours)h"
            } else {
                return "\(minutes)m"
            }
        }
        return "Ongoing"
    }
    
    var summaryDescription: String {
        if isOngoing {
            return "Sleeping now"
        } else {
            return "Slept for \(durationDescription)"
        }
    }
}

// MARK: - Mock Data

extension SleepEntry {
    static let mock = SleepEntry(
        babyId: BabyProfile.mock.id,
        startTime: Calendar.current.date(byAdding: .hour, value: -2, to: Date())!,
        endTime: Calendar.current.date(byAdding: .hour, value: -1, to: Date())!
    )
    
    static let mockOngoing = SleepEntry(
        babyId: BabyProfile.mock.id,
        startTime: Calendar.current.date(byAdding: .minute, value: -45, to: Date())!,
        endTime: nil
    )
    
    static let mockList: [SleepEntry] = [
        mockOngoing,
        mock,
        SleepEntry(
            babyId: BabyProfile.mock.id,
            startTime: Calendar.current.date(byAdding: .hour, value: -6, to: Date())!,
            endTime: Calendar.current.date(byAdding: .hour, value: -4, to: Date())!
        )
    ]
}

