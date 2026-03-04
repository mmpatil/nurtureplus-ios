//
//  Baby​Profile​.swift
//  nurtureplus
//
//  Created by Manali Maruti Pat on 3/3/26.
//

import Foundation

/// Represents a baby's profile information
struct BabyProfile: Identifiable, Codable, Equatable {
    
    // MARK: - Properties
    
    let id: String
    var name: String
    var birthDate: Date
    var photoURL: String?
    var createdAt: Date
    var updatedAt: Date
    
    // MARK: - Computed Properties
    
    /// Baby's age in days
    var ageInDays: Int {
        Calendar.current.dateComponents([.day], from: birthDate, to: Date()).day ?? 0
    }
    
    /// Baby's age in weeks
    var ageInWeeks: Int {
        ageInDays / 7
    }
    
    /// Baby's age in months (approximate)
    var ageInMonths: Int {
        Calendar.current.dateComponents([.month], from: birthDate, to: Date()).month ?? 0
    }
    
    /// Formatted age string (e.g., "2 weeks old", "3 months old")
    var ageDescription: String {
        if ageInDays < 14 {
            return "\(ageInDays) day\(ageInDays == 1 ? "" : "s") old"
        } else if ageInWeeks < 8 {
            return "\(ageInWeeks) week\(ageInWeeks == 1 ? "" : "s") old"
        } else {
            return "\(ageInMonths) month\(ageInMonths == 1 ? "" : "s") old"
        }
    }
    
    // MARK: - Initialization
    
    init(
        id: String = UUID().uuidString,
        name: String,
        birthDate: Date,
        photoURL: String? = nil,
        createdAt: Date = Date(),
        updatedAt: Date = Date()
    ) {
        self.id = id
        self.name = name
        self.birthDate = birthDate
        self.photoURL = photoURL
        self.createdAt = createdAt
        self.updatedAt = updatedAt
    }
}

// MARK: - Mock Data

extension BabyProfile {
    static let mock = BabyProfile(
        name: "Emma",
        birthDate: Calendar.current.date(byAdding: .day, value: -21, to: Date())!
    )
    
    static let mockNewborn = BabyProfile(
        name: "Oliver",
        birthDate: Calendar.current.date(byAdding: .day, value: -5, to: Date())!
    )
}

