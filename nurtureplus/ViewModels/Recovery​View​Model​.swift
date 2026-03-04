//
//  Recovery​View​Model​.swift
//  nurtureplus
//
//  Created by Manali Maruti Pat on 3/3/26.
//

import Foundation
import Combine
/// ViewModel for managing recovery entries
@MainActor
class RecoveryViewModel: ObservableObject {
    @Published var recoveryEntries: [RecoveryEntry] = []
    @Published var isLoading: Bool = false
    @Published var errorMessage: String?
    
    // Form state for adding/editing
    @Published var editingEntry: RecoveryEntry?
    @Published var selectedMood: MoodType = .okay
    @Published var selectedEnergyLevel: RecoveryEnergyLevel = .moderate
    @Published var waterIntake: Int = 0
    @Published var selectedSymptoms: Set<Symptom> = []
    @Published var notes: String = ""
    
    private let dataManager = DataManager.shared
    
    // MARK: - Data Loading
    
    func loadRecoveryEntries(for babyID: UUID) {
        isLoading = true
        errorMessage = nil
        
        do {
            recoveryEntries = try dataManager.loadRecoveryEntries(for: babyID)
                .sorted { $0.timestamp > $1.timestamp }
            isLoading = false
        } catch {
            errorMessage = "Failed to load recovery entries: \(error.localizedDescription)"
            isLoading = false
        }
    }
    
    func loadLatestEntry(for babyID: UUID) -> RecoveryEntry? {
        do {
            let entries = try dataManager.loadRecoveryEntries(for: babyID)
            return entries.sorted { $0.timestamp > $1.timestamp }.first
        } catch {
            return nil
        }
    }
    
    // MARK: - CRUD Operations
    
    func saveRecoveryEntry(for babyID: UUID) throws {
        let entry = RecoveryEntry(
            id: editingEntry?.id ?? UUID(),
            babyID: babyID,
            timestamp: editingEntry?.timestamp ?? Date(),
            mood: selectedMood,
            energyLevel: selectedEnergyLevel,
            waterIntakeOz: waterIntake,
            symptoms: Array(selectedSymptoms),
            notes: notes
        )
        
        if editingEntry != nil {
            try dataManager.updateRecoveryEntry(entry)
        } else {
            try dataManager.saveRecoveryEntry(entry)
        }
        
        loadRecoveryEntries(for: babyID)
        clearForm()
    }
    
    func deleteEntry(_ entry: RecoveryEntry) throws {
        try dataManager.deleteRecoveryEntry(entry)
        loadRecoveryEntries(for: entry.babyID)
    }
    
    // MARK: - Form Management
    
    func startEditing(_ entry: RecoveryEntry) {
        editingEntry = entry
        selectedMood = entry.mood
        selectedEnergyLevel = entry.energyLevel
        waterIntake = entry.waterIntakeOz
        selectedSymptoms = Set(entry.symptoms)
        notes = entry.notes
    }
    
    func clearForm() {
        editingEntry = nil
        selectedMood = .okay
        selectedEnergyLevel = .moderate
        waterIntake = 0
        selectedSymptoms = []
        notes = ""
    }
    
    // MARK: - Analytics
    
    func averageWaterIntake(for babyID: UUID, days: Int = 7) -> Double {
        do {
            let entries = try dataManager.loadRecoveryEntries(for: babyID)
            let recentEntries = entries.filter {
                Calendar.current.dateComponents([.day], from: $0.timestamp, to: Date()).day ?? 0 <= days
            }
            
            guard !recentEntries.isEmpty else { return 0 }
            
            let total = recentEntries.reduce(0) { $0 + $1.waterIntakeOz }
            return Double(total) / Double(recentEntries.count)
        } catch {
            return 0
        }
    }
}

