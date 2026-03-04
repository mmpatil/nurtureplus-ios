//
//  AddDiaperView.swift
//  nurtureplus
//
//  Created on 2026-03-03.
//

import SwiftUI

/// Form for adding a new diaper change entry
struct AddDiaperView: View {
    
    @Environment(\.dismiss) private var dismiss
    @ObservedObject var viewModel: TrackingViewModel
    
    // Form state
    @State private var selectedType: DiaperType = .both
    @State private var timestamp: Date = Date()
    @State private var notes: String = ""
    
    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(spacing: NurtureSpacing.xl) {
                    // Diaper type selector
                    diaperTypeSection
                    
                    // Time picker
                    timeSection
                    
                    // Notes
                    notesSection
                }
                .padding(NurtureSpacing.lg)
            }
            .background(NurtureColors.background)
            .navigationTitle("Log Diaper Change")
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
                        saveDiaper()
                    }
                    .foregroundColor(NurtureColors.primary)
                    .fontWeight(.semibold)
                }
            }
        }
    }
    
    // MARK: - Sections
    
    private var diaperTypeSection: some View {
        VStack(alignment: .leading, spacing: NurtureSpacing.md) {
            Text("Diaper Type")
                .font(.system(size: 17, weight: .semibold))
                .foregroundColor(NurtureColors.textPrimary)
            
            LazyVGrid(columns: [
                GridItem(.flexible()),
                GridItem(.flexible())
            ], spacing: NurtureSpacing.md) {
                ForEach(DiaperType.allCases, id: \.self) { type in
                    diaperTypeButton(type)
                }
            }
        }
    }
    
    private func diaperTypeButton(_ type: DiaperType) -> some View {
        Button {
            withAnimation(.spring(response: 0.3, dampingFraction: 0.7)) {
                selectedType = type
            }
        } label: {
            VStack(spacing: NurtureSpacing.sm) {
                Circle()
                    .fill(selectedType == type ? NurtureColors.accentSecondary.opacity(0.2) : NurtureColors.backgroundSecondary)
                    .frame(width: 60, height: 60)
                    .overlay {
                        Image(systemName: type.icon)
                            .font(.system(size: 28))
                            .foregroundColor(selectedType == type ? NurtureColors.accentSecondary : NurtureColors.textSecondary)
                    }
                
                Text(type.displayName)
                    .font(.system(size: 14, weight: .medium))
                    .foregroundColor(NurtureColors.textPrimary)
            }
            .frame(maxWidth: .infinity)
            .padding(NurtureSpacing.md)
            .background(
                RoundedRectangle(cornerRadius: NurtureCornerRadius.md)
                    .fill(selectedType == type ? NurtureColors.primaryLight : NurtureColors.cardBackground)
            )
            .overlay(
                RoundedRectangle(cornerRadius: NurtureCornerRadius.md)
                    .stroke(selectedType == type ? NurtureColors.accentSecondary : Color.clear, lineWidth: 2)
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
    
    // MARK: - Actions
    
    private func saveDiaper() {
        guard let babyId = viewModel.babyProfile?.id else { return }
        
        let entry = DiaperEntry(
            babyId: babyId,
            timestamp: timestamp,
            type: selectedType,
            notes: notes.isEmpty ? nil : notes
        )
        
        viewModel.addDiaperEntry(entry)
        dismiss()
    }
}

// MARK: - Preview

#Preview {
    AddDiaperView(viewModel: TrackingViewModel())
}
