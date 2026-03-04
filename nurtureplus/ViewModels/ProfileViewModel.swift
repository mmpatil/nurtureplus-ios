//
//  ProfileViewModel.swift
//  nurtureplus
//
//  Created by Manali Maruti Pat on 3/3/26.
//

import Foundation
import Combine

/// ViewModel for the Profile screen
@MainActor
final class ProfileViewModel: ObservableObject {
    
    // MARK: - Published Properties
    
    @Published var babyProfile: BabyProfile?
    @Published var isLoading: Bool = false
    @Published var isEditing: Bool = false
    
    // Form fields for editing
    @Published var editName: String = ""
    @Published var editBirthDate: Date = Date()
    @Published var editPhotoURL: String?
    
    // MARK: - Dependencies
    
    private let dataManager = DataManager.shared
    
    // MARK: - Initialization
    
    init() {
        loadData()
    }
    
    // MARK: - Methods
    
    /// Load profile data from persistence
    func loadData() {
        babyProfile = dataManager.loadBabyProfile()
        syncFormFields()
    }
    
    /// Start editing mode
    func startEditing() {
        syncFormFields()
        isEditing = true
    }
    
    /// Cancel editing
    func cancelEditing() {
        syncFormFields()
        isEditing = false
    }
    
    /// Save changes
    func saveChanges() {
        guard var profile = babyProfile else { return }
        
        profile.name = editName
        profile.birthDate = editBirthDate
        profile.photoURL = editPhotoURL
        profile.updatedAt = Date()
        
        babyProfile = profile
        isEditing = false
        
        dataManager.saveBabyProfile(profile)
        print("✅ Saved baby profile changes")
    }
    
    /// Reset app data (for testing)
    func resetAppData() {
        AppState.shared.reset()
        dataManager.resetAllData()
        babyProfile = nil
        print("🗑️ Reset all app data")
    }
    
    // MARK: - Private Methods
    
    private func syncFormFields() {
        editName = babyProfile?.name ?? ""
        editBirthDate = babyProfile?.birthDate ?? Date()
        editPhotoURL = babyProfile?.photoURL
    }
}

