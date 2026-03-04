//
//  EditFeedingView.swift
//  nurtureplus
//
//  Created on 2026-03-03.
//

import SwiftUI

/// Form for editing an existing feeding entry
struct EditFeedingView: View {
    
    @Environment(\.dismiss) private var dismiss
    @ObservedObject var viewModel: TrackingViewModel
    
    let entry: FeedingEntry
    
    // Form state
    @State private var selectedType: FeedingType
    @State private var timestamp: Date
    @State private var durationMinutes: Int
    @State private var amountML: String
    @State private var notes: String
    
    init(viewModel: TrackingViewModel, entry: FeedingEntry) {
        self.viewModel = viewModel
        self.entry = entry
        
        // Initialize state from entry
        _selectedType = State(initialValue: entry.feedingType)
        _timestamp = State(initialValue: entry.timestamp)
        _durationMinutes = State(initialValue: entry.durationMinutes ?? 15)
        _amountML = State(initialValue: entry.amountML != nil ? String(Int(entry.amountML!)) : "")
        _notes = State(initialValue: entry.notes ?? "")
    }
    
    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(spacing: NurtureSpacing.xl) {
                    // Feeding type selector
                    feedingTypeSection
                    
                    // Time picker
                    timeSection
                    
                    // Duration or Amount based on type
                    if isBreastFeeding {
                        durationSection
                    } else {
                        amountSection
                    }
                    
                    // Notes
                    notesSection
                }
                .padding(NurtureSpacing.lg)
            }
            .background(NurtureColors.background)
            .navigationTitle("Edit Feeding")
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
    
    // MARK: - Sections (Reuse from AddFeedingView)
    
    private var feedingTypeSection: some View {
        VStack(alignment: .leading, spacing: NurtureSpacing.md) {
            Text("Feeding Type")
                .font(.system(size: 17, weight: .semibold))
                .foregroundColor(NurtureColors.textPrimary)
            
            VStack(spacing: NurtureSpacing.sm) {
                ForEach(FeedingType.allCases, id: \.self) { type in
                    feedingTypeButton(type)
                }
            }
        }
    }
    
    private func feedingTypeButton(_ type: FeedingType) -> some View {
        Button {
            withAnimation(.spring(response: 0.3, dampingFraction: 0.7)) {
                selectedType = type
            }
        } label: {
            HStack {
                Image(systemName: type.icon)
                    .font(.system(size: 20))
                    .foregroundColor(selectedType == type ? NurtureColors.primary : NurtureColors.textSecondary)
                    .frame(width: 30)
                
                Text(type.displayName)
                    .font(.system(size: 16, weight: .medium))
                    .foregroundColor(NurtureColors.textPrimary)
                
                Spacer()
                
                if selectedType == type {
                    Image(systemName: "checkmark.circle.fill")
                        .font(.system(size: 22))
                        .foregroundColor(NurtureColors.primary)
                }
            }
            .padding(NurtureSpacing.md)
            .background(
                RoundedRectangle(cornerRadius: NurtureCornerRadius.md)
                    .fill(selectedType == type ? NurtureColors.primaryLight : NurtureColors.cardBackground)
            )
            .overlay(
                RoundedRectangle(cornerRadius: NurtureCornerRadius.md)
                    .stroke(selectedType == type ? NurtureColors.primary : Color.clear, lineWidth: 2)
            )
        }
    }
    
    private var timeSection: some View {
        VStack(alignment: .leading, spacing: NurtureSpacing.md) {
            Text("Time")
                .font(.system(size: 17, weight: .semibold))
                .foregroundColor(NurtureColors.textPrimary)
            
            DatePicker("", selection: $timestamp, displayedComponents: [.date, .hourAndMinute])
                .datePickerStyle(.compact)
                .labelsHidden()
                .tint(NurtureColors.primary)
        }
    }
    
    private var durationSection: some View {
        VStack(alignment: .leading, spacing: NurtureSpacing.md) {
            Text("Duration")
                .font(.system(size: 17, weight: .semibold))
                .foregroundColor(NurtureColors.textPrimary)
            
            VStack(spacing: NurtureSpacing.md) {
                HStack {
                    Text("\(durationMinutes) minutes")
                        .font(.system(size: 20, weight: .semibold))
                        .foregroundColor(NurtureColors.primary)
                    
                    Spacer()
                }
                .padding(NurtureSpacing.md)
                .background(
                    RoundedRectangle(cornerRadius: NurtureCornerRadius.md)
                        .fill(NurtureColors.cardBackground)
                )
                
                Slider(value: Binding(
                    get: { Double(durationMinutes) },
                    set: { durationMinutes = Int($0) }
                ), in: 1...60, step: 1)
                    .tint(NurtureColors.primary)
                
                HStack {
                    Text("1 min")
                        .font(.system(size: 13))
                        .foregroundColor(NurtureColors.textTertiary)
                    
                    Spacer()
                    
                    Text("60 min")
                        .font(.system(size: 13))
                        .foregroundColor(NurtureColors.textTertiary)
                }
            }
        }
    }
    
    private var amountSection: some View {
        VStack(alignment: .leading, spacing: NurtureSpacing.md) {
            Text("Amount (ml)")
                .font(.system(size: 17, weight: .semibold))
                .foregroundColor(NurtureColors.textPrimary)
            
            TextField("Enter amount", text: $amountML)
                #if os(iOS)
                .keyboardType(.decimalPad)
                #endif
                .font(.system(size: 17))
                .padding(NurtureSpacing.md)
                .background(
                    RoundedRectangle(cornerRadius: NurtureCornerRadius.md)
                        .fill(NurtureColors.cardBackground)
                )
                .overlay(
                    RoundedRectangle(cornerRadius: NurtureCornerRadius.md)
                        .stroke(NurtureColors.divider, lineWidth: 1)
                )
            
            HStack(spacing: NurtureSpacing.sm) {
                ForEach([60, 90, 120, 150], id: \.self) { amount in
                    Button {
                        amountML = "\(amount)"
                    } label: {
                        Text("\(amount) ml")
                            .font(.system(size: 14, weight: .medium))
                            .foregroundColor(NurtureColors.primary)
                            .padding(.horizontal, NurtureSpacing.md)
                            .padding(.vertical, NurtureSpacing.sm)
                            .background(
                                RoundedRectangle(cornerRadius: NurtureCornerRadius.sm)
                                    .fill(NurtureColors.primaryLight)
                            )
                    }
                }
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
    
    private var isBreastFeeding: Bool {
        [.breastLeft, .breastRight, .breastBoth].contains(selectedType)
    }
    
    // MARK: - Actions
    
    private func saveChanges() {
        let updatedEntry = FeedingEntry(
            id: entry.id,
            babyId: entry.babyId,
            timestamp: timestamp,
            feedingType: selectedType,
            durationMinutes: isBreastFeeding ? durationMinutes : nil,
            amountML: isBreastFeeding ? nil : Double(amountML),
            notes: notes.isEmpty ? nil : notes,
            createdAt: entry.createdAt
        )
        
        viewModel.updateFeedingEntry(updatedEntry)
        dismiss()
    }
}

// MARK: - Preview

#Preview {
    EditFeedingView(viewModel: TrackingViewModel(), entry: FeedingEntry.mock)
}
