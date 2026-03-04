//
//  AddMoodView.swift
//  nurtureplus
//
//  Created on 2026-03-03.
//

import SwiftUI

/// Form for adding a mood check-in entry
struct AddMoodView: View {
    
    @Environment(\.dismiss) private var dismiss
    
    // Form state
    @State private var selectedMood: MoodLevel = .good
    @State private var selectedEnergy: EnergyLevel = .moderate
    @State private var notes: String = ""
    
    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(spacing: NurtureSpacing.xl) {
                    // Header message
                    headerSection
                    
                    // Mood selector
                    moodSection
                    
                    // Energy selector
                    energySection
                    
                    // Notes
                    notesSection
                }
                .padding(NurtureSpacing.lg)
            }
            .background(NurtureColors.background)
            .navigationTitle("How Are You Feeling?")
            #if os(iOS)
            .navigationBarTitleDisplayMode(.inline)
            #endif
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("Cancel") {
                        dismiss()
                    }
                    .foregroundColor(NurtureColors.textSecondary)
                }
                
                ToolbarItem(placement: .confirmationAction) {
                    Button("Save") {
                        saveMood()
                    }
                    .foregroundColor(NurtureColors.primary)
                    .fontWeight(.semibold)
                }
            }
        }
    }
    
    // MARK: - Sections
    
    private var headerSection: some View {
        NurtureCard {
            VStack(spacing: NurtureSpacing.sm) {
                Image(systemName: "heart.circle.fill")
                    .font(.system(size: 48))
                    .foregroundColor(NurtureColors.accent)
                
                Text("Check in with yourself")
                    .font(.system(size: 18, weight: .semibold))
                    .foregroundColor(NurtureColors.textPrimary)
                
                Text("Taking a moment to acknowledge how you're feeling is an important part of your recovery journey.")
                    .font(.system(size: 14))
                    .foregroundColor(NurtureColors.textSecondary)
                    .multilineTextAlignment(.center)
                    .lineSpacing(4)
            }
        }
    }
    
    private var moodSection: some View {
        VStack(alignment: .leading, spacing: NurtureSpacing.md) {
            Text("How's your mood?")
                .font(.system(size: 17, weight: .semibold))
                .foregroundColor(NurtureColors.textPrimary)
            
            VStack(spacing: NurtureSpacing.sm) {
                ForEach(MoodLevel.allCases, id: \.self) { mood in
                    moodButton(mood)
                }
            }
        }
    }
    
    private func moodButton(_ mood: MoodLevel) -> some View {
        Button {
            withAnimation(.spring(response: 0.3, dampingFraction: 0.7)) {
                selectedMood = mood
            }
        } label: {
            HStack(spacing: NurtureSpacing.md) {
                Text(mood.emoji)
                    .font(.system(size: 32))
                
                VStack(alignment: .leading, spacing: 2) {
                    Text(mood.displayName)
                        .font(.system(size: 16, weight: .semibold))
                        .foregroundColor(NurtureColors.textPrimary)
                }
                
                Spacer()
                
                if selectedMood == mood {
                    Image(systemName: "checkmark.circle.fill")
                        .font(.system(size: 24))
                        .foregroundColor(NurtureColors.primary)
                }
            }
            .padding(NurtureSpacing.md)
            .background(
                RoundedRectangle(cornerRadius: NurtureCornerRadius.md)
                    .fill(selectedMood == mood ? NurtureColors.primaryLight : NurtureColors.cardBackground)
            )
            .overlay(
                RoundedRectangle(cornerRadius: NurtureCornerRadius.md)
                    .stroke(selectedMood == mood ? NurtureColors.primary : Color.clear, lineWidth: 2)
            )
        }
    }
    
    private var energySection: some View {
        VStack(alignment: .leading, spacing: NurtureSpacing.md) {
            Text("Energy Level")
                .font(.system(size: 17, weight: .semibold))
                .foregroundColor(NurtureColors.textPrimary)
            
            LazyVGrid(columns: [
                GridItem(.flexible()),
                GridItem(.flexible())
            ], spacing: NurtureSpacing.md) {
                ForEach(EnergyLevel.allCases, id: \.self) { energy in
                    energyButton(energy)
                }
            }
        }
    }
    
    private func energyButton(_ energy: EnergyLevel) -> some View {
        Button {
            withAnimation(.spring(response: 0.3, dampingFraction: 0.7)) {
                selectedEnergy = energy
            }
        } label: {
            VStack(spacing: NurtureSpacing.sm) {
                Image(systemName: energy.icon)
                    .font(.system(size: 28))
                    .foregroundColor(selectedEnergy == energy ? NurtureColors.primary : NurtureColors.textSecondary)
                
                Text(energy.displayName)
                    .font(.system(size: 14, weight: .medium))
                    .foregroundColor(NurtureColors.textPrimary)
            }
            .frame(maxWidth: .infinity)
            .padding(.vertical, NurtureSpacing.lg)
            .background(
                RoundedRectangle(cornerRadius: NurtureCornerRadius.md)
                    .fill(selectedEnergy == energy ? NurtureColors.primaryLight : NurtureColors.cardBackground)
            )
            .overlay(
                RoundedRectangle(cornerRadius: NurtureCornerRadius.md)
                    .stroke(selectedEnergy == energy ? NurtureColors.primary : Color.clear, lineWidth: 2)
            )
        }
    }
    
    private var notesSection: some View {
        VStack(alignment: .leading, spacing: NurtureSpacing.md) {
            Text("Any thoughts? (Optional)")
                .font(.system(size: 17, weight: .semibold))
                .foregroundColor(NurtureColors.textPrimary)
            
            TextField("Share what's on your mind...", text: $notes, axis: .vertical)
                .font(.system(size: 15))
                .lineLimit(3...6)
                .padding(NurtureSpacing.md)
                .background(
                    RoundedRectangle(cornerRadius: NurtureCornerRadius.md)
                        .fill(NurtureColors.cardBackground)
                )
                .overlay(
                    RoundedRectangle(cornerRadius: NurtureCornerRadius.md)
                        .stroke(NurtureColors.divider, lineWidth: 1)
                )
        }
    }
    
    // MARK: - Actions
    
    private func saveMood() {
        let entry = MoodEntry(
            mood: selectedMood,
            energyLevel: selectedEnergy,
            notes: notes.isEmpty ? nil : notes
        )
        
        // Save to DataManager
        DataManager.shared.addMoodEntry(entry)
        print("✅ Saved mood entry")
        
        dismiss()
    }
}

// MARK: - Preview

#Preview {
    AddMoodView()
}
