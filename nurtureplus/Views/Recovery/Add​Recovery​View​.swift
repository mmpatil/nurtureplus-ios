//
//  Add​Recovery​View​.swift
//  nurtureplus
//
//  Created by Manali Maruti Pat on 3/3/26.
//

import SwiftUI

/// Sheet for adding or editing a recovery entry
struct AddRecoveryView: View {
    
    @ObservedObject var viewModel: RecoveryViewModel
    @Environment(\.dismiss) private var dismiss
    
    let babyID: UUID
    let isEditing: Bool
    
    @State private var showingDeleteConfirmation = false
    
    init(viewModel: RecoveryViewModel, babyID: UUID) {
        self.viewModel = viewModel
        self.babyID = babyID
        self.isEditing = viewModel.editingEntry != nil
    }
    
    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(spacing: NurtureSpacing.xl) {
                    // Mood selection
                    moodSection
                    
                    // Energy level
                    energySection
                    
                    // Water intake
                    waterIntakeSection
                    
                    // Symptoms
                    symptomsSection
                    
                    // Notes
                    notesSection
                }
                .padding(NurtureSpacing.lg)
            }
            .background(NurtureColors.background)
            .navigationTitle(isEditing ? "Edit Check-In" : "Recovery Check-In")
            #if os(iOS)
            .navigationBarTitleDisplayMode(.inline)
            #endif
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("Cancel") {
                        viewModel.clearForm()
                        dismiss()
                    }
                }
                
                ToolbarItem(placement: .confirmationAction) {
                    Button("Save") {
                        saveEntry()
                    }
                    .fontWeight(.semibold)
                }
                
                if isEditing {
                    ToolbarItem(placement: .destructiveAction) {
                        Button(role: .destructive) {
                            showingDeleteConfirmation = true
                        } label: {
                            Image(systemName: "trash")
                        }
                    }
                }
            }
            .alert("Delete Entry?", isPresented: $showingDeleteConfirmation) {
                Button("Cancel", role: .cancel) { }
                Button("Delete", role: .destructive) {
                    deleteEntry()
                }
            } message: {
                Text("This recovery check-in will be permanently deleted.")
            }
        }
    }
    
    // MARK: - Sections
    
    private var moodSection: some View {
        VStack(alignment: .leading, spacing: NurtureSpacing.md) {
            Text("How are you feeling?")
                .font(.system(size: 17, weight: .semibold))
                .foregroundColor(NurtureColors.textPrimary)
            
            VStack(spacing: NurtureSpacing.sm) {
                ForEach(MoodType.allCases, id: \.self) { mood in
                    Button {
                        viewModel.selectedMood = mood
                    } label: {
                        HStack(spacing: NurtureSpacing.md) {
                            Text(mood.emoji)
                                .font(.system(size: 28))
                            
                            Text(mood.displayName)
                                .font(.system(size: 16, weight: .medium))
                                .foregroundColor(NurtureColors.textPrimary)
                            
                            Spacer()
                            
                            if viewModel.selectedMood == mood {
                                Image(systemName: "checkmark.circle.fill")
                                    .foregroundColor(NurtureColors.primary)
                            } else {
                                Circle()
                                    .strokeBorder(NurtureColors.divider, lineWidth: 2)
                                    .frame(width: 24, height: 24)
                            }
                        }
                        .padding(NurtureSpacing.md)
                        .background(
                            RoundedRectangle(cornerRadius: NurtureCornerRadius.md)
                                .fill(viewModel.selectedMood == mood ?
                                      NurtureColors.primary.opacity(0.1) :
                                      NurtureColors.cardBackground)
                        )
                    }
                    .buttonStyle(.plain)
                }
            }
        }
    }
    
    private var energySection: some View {
        VStack(alignment: .leading, spacing: NurtureSpacing.md) {
            Text("Energy Level")
                .font(.system(size: 17, weight: .semibold))
                .foregroundColor(NurtureColors.textPrimary)
            
            HStack(spacing: NurtureSpacing.sm) {
                ForEach(RecoveryEnergyLevel.allCases, id: \.self) { energy in
                    Button {
                        viewModel.selectedEnergyLevel = energy
                    } label: {
                        VStack(spacing: NurtureSpacing.xs) {
                            Text(energy.emoji)
                                .font(.system(size: 32))
                            
                            Text(energy.displayName)
                                .font(.system(size: 12, weight: .medium))
                                .foregroundColor(NurtureColors.textSecondary)
                                .lineLimit(1)
                                .minimumScaleFactor(0.8)
                        }
                        .frame(maxWidth: .infinity)
                        .padding(.vertical, NurtureSpacing.md)
                        .background(
                            RoundedRectangle(cornerRadius: NurtureCornerRadius.md)
                                .fill(viewModel.selectedEnergyLevel == energy ?
                                      NurtureColors.accent.opacity(0.15) :
                                      NurtureColors.cardBackground)
                        )
                        .overlay(
                            RoundedRectangle(cornerRadius: NurtureCornerRadius.md)
                                .strokeBorder(
                                    viewModel.selectedEnergyLevel == energy ?
                                    NurtureColors.accent : Color.clear,
                                    lineWidth: 2
                                )
                        )
                    }
                    .buttonStyle(.plain)
                }
            }
        }
    }
    
    private var waterIntakeSection: some View {
        VStack(alignment: .leading, spacing: NurtureSpacing.md) {
            HStack {
                Text("Water Intake")
                    .font(.system(size: 17, weight: .semibold))
                    .foregroundColor(NurtureColors.textPrimary)
                
                Spacer()
                
                Text("\(viewModel.waterIntake) oz")
                    .font(.system(size: 20, weight: .bold))
                    .foregroundColor(NurtureColors.primary)
            }
            
            NurtureCard(padding: NurtureSpacing.lg) {
                VStack(spacing: NurtureSpacing.md) {
                    Slider(
                        value: Binding(
                            get: { Double(viewModel.waterIntake) },
                            set: { viewModel.waterIntake = Int($0) }
                        ),
                        in: 0...128,
                        step: 8
                    )
                    .tint(NurtureColors.primary)
                    
                    HStack {
                        Text("0 oz")
                            .font(.system(size: 12))
                            .foregroundColor(NurtureColors.textTertiary)
                        
                        Spacer()
                        
                        Text("128 oz")
                            .font(.system(size: 12))
                            .foregroundColor(NurtureColors.textTertiary)
                    }
                    
                    // Quick increment buttons
                    HStack(spacing: NurtureSpacing.sm) {
                        quickWaterButton("+8 oz") { viewModel.waterIntake += 8 }
                        quickWaterButton("+16 oz") { viewModel.waterIntake += 16 }
                        quickWaterButton("Reset") {
                            viewModel.waterIntake = 0
                        }
                    }
                }
            }
            
            Text("Recommended: 64-100 oz per day while breastfeeding")
                .font(.system(size: 13))
                .foregroundColor(NurtureColors.textSecondary)
        }
    }
    
    private func quickWaterButton(_ label: String, action: @escaping () -> Void) -> some View {
        Button(action: action) {
            Text(label)
                .font(.system(size: 13, weight: .medium))
                .foregroundColor(NurtureColors.primary)
                .frame(maxWidth: .infinity)
                .padding(.vertical, NurtureSpacing.sm)
                .background(
                    RoundedRectangle(cornerRadius: NurtureCornerRadius.sm)
                        .fill(NurtureColors.primaryLight)
                )
        }
    }
    
    private var symptomsSection: some View {
        VStack(alignment: .leading, spacing: NurtureSpacing.md) {
            Text("Symptoms (optional)")
                .font(.system(size: 17, weight: .semibold))
                .foregroundColor(NurtureColors.textPrimary)
            
            LazyVGrid(columns: [
                GridItem(.flexible()),
                GridItem(.flexible())
            ], spacing: NurtureSpacing.sm) {
                ForEach(Symptom.allCases, id: \.self) { symptom in
                    symptomButton(symptom)
                }
            }
        }
    }
    
    private func symptomButton(_ symptom: Symptom) -> some View {
        Button {
            if viewModel.selectedSymptoms.contains(symptom) {
                viewModel.selectedSymptoms.remove(symptom)
            } else {
                viewModel.selectedSymptoms.insert(symptom)
            }
        } label: {
            HStack(spacing: NurtureSpacing.sm) {
                Image(systemName: symptom.icon)
                    .font(.system(size: 14))
                
                Text(symptom.displayName)
                    .font(.system(size: 13, weight: .medium))
                    .lineLimit(1)
                
                Spacer()
                
                if viewModel.selectedSymptoms.contains(symptom) {
                    Image(systemName: "checkmark")
                        .font(.system(size: 12, weight: .bold))
                }
            }
            .foregroundColor(
                viewModel.selectedSymptoms.contains(symptom) ?
                .white : NurtureColors.textPrimary
            )
            .padding(.horizontal, NurtureSpacing.md)
            .padding(.vertical, NurtureSpacing.sm)
            .background(
                RoundedRectangle(cornerRadius: NurtureCornerRadius.sm)
                    .fill(
                        viewModel.selectedSymptoms.contains(symptom) ?
                        NurtureColors.accent : NurtureColors.cardBackground
                    )
            )
        }
        .buttonStyle(.plain)
    }
    
    private var notesSection: some View {
        VStack(alignment: .leading, spacing: NurtureSpacing.md) {
            Text("Notes (optional)")
                .font(.system(size: 17, weight: .semibold))
                .foregroundColor(NurtureColors.textPrimary)
            
            NurtureCard(padding: NurtureSpacing.md) {
                TextEditor(text: $viewModel.notes)
                    .frame(minHeight: 100)
                    .scrollContentBackground(.hidden)
                    .font(.system(size: 15))
                    .foregroundColor(NurtureColors.textPrimary)
            }
        }
    }
    
    // MARK: - Actions
    
    private func saveEntry() {
        do {
            try viewModel.saveRecoveryEntry(for: babyID)
            dismiss()
        } catch {
            print("Error saving recovery entry: \(error)")
        }
    }
    
    private func deleteEntry() {
        guard let entry = viewModel.editingEntry else { return }
        
        do {
            try viewModel.deleteEntry(entry)
            dismiss()
        } catch {
            print("Error deleting recovery entry: \(error)")
        }
    }
}

// MARK: - Preview

#Preview {
    AddRecoveryView(
        viewModel: RecoveryViewModel(),
        babyID: UUID()
    )
}

