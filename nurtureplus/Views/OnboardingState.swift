//
//  OnboardingState.swift
//  nurtureplus
//
//  Created on 2026-03-03.
//

import Foundation

/// Manages onboarding completion state
struct OnboardingState: Codable {
    var hasCompletedOnboarding: Bool
    var hasCreatedBabyProfile: Bool
    
    static let `default` = OnboardingState(
        hasCompletedOnboarding: false,
        hasCreatedBabyProfile: false
    )
    
    // MARK: - Persistence
    
    private static let key = "onboardingState"
    
    static func load() -> OnboardingState {
        guard let data = UserDefaults.standard.data(forKey: key),
              let state = try? JSONDecoder().decode(OnboardingState.self, from: data) else {
            return .default
        }
        return state
    }
    
    func save() {
        if let data = try? JSONEncoder().encode(self) {
            UserDefaults.standard.set(data, forKey: Self.key)
        }
    }
    
    static func reset() {
        UserDefaults.standard.removeObject(forKey: key)
    }
}
