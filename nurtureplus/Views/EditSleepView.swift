//
//  EditSleepView.swift
//  nurtureplus
//
//  Created on 2026-03-03.
//

import SwiftUI

/// Form for editing an existing sleep entry
struct EditSleepView: View {
    
    @Environment(\.dismiss) private var dismiss
    @ObservedObject var viewModel: TrackingViewModel
    
    let entry: SleepEntry
    
    // Form state
    @State private var startTime: Date
    @State private var endTime: Date
    @State private var isOngoing: Bool
    @State private var notes: String
    
    init(viewModel: TrackingViewModel, entry: SleepEntry) {
        self.viewModel = viewModel
        self.entry = entry
        
        // Initialize state from entry
        _startTime = State(initialValue: entry.startTime)
        _endTime = State(initialValue: entry.endTime ?? Date())
        _isOngoing = State(initialValue: entry.isOngoing)
        _notes = State(initialValue: entry.notes ?? "")
    }
    
    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(spacing: NurtureSpacing.xl) {
                    // Ongoing toggle
                    ongoingToggleSection
                    
                    // Time pickers
                    timeSection
                    
                    // Duration display
                    if !isOngoing {
                        durationSection
                    }
                    
                    // Notes
                    notesSection
                }
                .padding(NurtureSpacing.lg)
            }
            .background(NurtureColors.background)
            .navigationTitle("Edit Sleep")
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
                        saveChanges()
                    }
                    .foregroundColor(NurtureColors.primary)
                    .fontWeight(.semibold)
                }
            }
        }
    }
    
    // MARK: - Sections
    
    private var ongoingToggleSection: some View {
        NurtureCard {
            Toggle(isOn: $isOngoing) {
                HStack(spacing: NurtureSpacing.sm) {
                    Image(systemName: "moon.zzz.fill")
                        .font(.system(size: 20))
                        .foregroundColor(NurtureColors.accent)
                    
                    VStack(alignment: .leading, spacing: 2) {
                        Text("Baby is sleeping now")
                            .font(.system(size: 16, weight: .semibold))
                            .foregroundColor(NurtureColors.textPrimary)
                        
                        Text("Mark as ongoing sleep session")
                            .font(.system(size: 13))
                            .foregroundColor(NurtureColors.textSecondary)
                    }
                }
            }
            .tint(NurtureColors.primary)
        }
    }
    
    private var timeSection: some View {
        VStack(spacing: NurtureSpacing.lg) {
            // Start time
            VStack(alignment: .leading, spacing: NurtureSpacing.md) {
                Text(isOngoing ? "Started at" : "Start Time")
                    .font(.system(size: 17, weight: .semibold))
                    .foregroundColor(NurtureColors.textPrimary)
                
                DatePicker("", selection: $startTime, displayedComponents: [.date, .hourAndMinute])
                    .datePickerStyle(.compact)
                    .labelsHidden()
                    .tint(NurtureColors.primary)
            }
            
            // End time (only if not ongoing)
            if !isOngoing {
                VStack(alignment: .leading, spacing: NurtureSpacing.md) {
                    Text("End Time")
                        .font(.system(size: 17, weight: .semibold))
                        .foregroundColor(NurtureColors.textPrimary)
                    
                    DatePicker("", selection: $endTime, displayedComponents: [.date, .hourAndMinute])
                        .datePickerStyle(.compact)
                        .labelsHidden()
                        .tint(NurtureColors.primary)
                }
            }
        }
    }
    
    private var durationSection: some View {
        NurtureCard {
            HStack {
                VStack(alignment: .leading, spacing: NurtureSpacing.xs) {
                    Text("Duration")
                        .font(.system(size: 14))
                        .foregroundColor(NurtureColors.textSecondary)
                    
                    Text(durationText)
                        .font(.system(size: 24, weight: .bold))
                        .foregroundColor(NurtureColors.primary)
                }
                
                Spacer()
                
                Image(systemName: "clock.fill")
                    .font(.system(size: 32))
                    .foregroundColor(NurtureColors.accent.opacity(0.3))
            }
        }
    }
    
    private var notesSection: some View {
        VStack(alignment: .leading, spacing: NurtureSpacing.md) {
            Text("Notes (Optional)")
                .font(.system(size: 17, weight: .semibold))
                .foregroundColor(NurtureColors.textPrimary)
            
            TextField("Add any notes...", text: $notes, axis: .vertical)
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
    
    // MARK: - Computed Properties
    
    private var durationText: String {
        let duration = Int(endTime.timeIntervalSince(startTime) / 60)
        
        guard duration > 0 else {
            return "0m"
        }
        
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
    
    // MARK: - Actions
    
    private func saveChanges() {
        let updatedEntry = SleepEntry(
            id: entry.id,
            babyId: entry.babyId,
            startTime: startTime,
            endTime: isOngoing ? nil : endTime,
            notes: notes.isEmpty ? nil : notes,
            createdAt: entry.createdAt
        )
        
        viewModel.updateSleepEntry(updatedEntry)
        dismiss()
    }
}

// MARK: - Preview

#Preview {
    EditSleepView(viewModel: TrackingViewModel(), entry: SleepEntry.mock)
}
