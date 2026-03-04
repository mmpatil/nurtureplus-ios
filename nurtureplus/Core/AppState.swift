//
//  AppState.swift
//  nurtureplus
//
//  Created by Manali Maruti Pat on 3/3/26.
//

import SwiftUI
import Combine

/// Central app state manager using ObservableObject
@MainActor
final class AppState: ObservableObject {
    
    nonisolated let objectWillChange = ObservableObjectPublisher()
    
    // MARK: - Published Properties
    
    /// Current user authentication status (placeholder for future Firebase integration)
    @Published var isAuthenticated: Bool = false
    
    /// Whether onboarding has been completed
    @Published var hasCompletedOnboarding: Bool = false
    
    /// Global loading state
    @Published var isLoading: Bool = false
    
    /// Global error message
    @Published var errorMessage: String?
    
    // MARK: - Singleton
    
    static let shared = AppState()
    
    // MARK: - Initialization
    
    private init() {
        loadPersistedState()
    }
    
    // MARK: - Methods
    
    /// Load persisted state from UserDefaults
    private func loadPersistedState() {
        hasCompletedOnboarding = UserDefaults.standard.bool(forKey: "hasCompletedOnboarding")
        // Additional state loading will be added here
    }
    
    /// Mark onboarding as complete
    func completeOnboarding() {
        hasCompletedOnboarding = true
        UserDefaults.standard.set(true, forKey: "hasCompletedOnboarding")
    }
    
    /// Reset app state (useful for testing/logout)
    func reset() {
        isAuthenticated = false
        hasCompletedOnboarding = false
        isLoading = false
        errorMessage = nil
        UserDefaults.standard.removeObject(forKey: "hasCompletedOnboarding")
    }
    
    /// Show error message
    func showError(_ message: String) {
        errorMessage = message
    }
    
    /// Clear error message
    func clearError() {
        errorMessage = nil
    }
}

