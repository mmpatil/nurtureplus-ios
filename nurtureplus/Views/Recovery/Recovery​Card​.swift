//
//  Recovery​Card​.swift
//  nurtureplus
//
//  Created by Manali Maruti Pat on 3/3/26.
//

import SwiftUI

/// Reusable card component for displaying a recovery entry
struct RecoveryCard: View {
    
    let entry: RecoveryEntry
    let onTap: () -> Void
    
    var body: some View {
        Button(action: onTap) {
            NurtureCard(padding: NurtureSpacing.lg) {
                VStack(spacing: NurtureSpacing.md) {
                    // Header: Mood + Time
                    HStack {
                        HStack(spacing: NurtureSpacing.sm) {
                            Text(entry.mood.emoji)
                                .font(.system(size: 32))
                            
                            VStack(alignment: .leading, spacing: 2) {
                                Text(entry.mood.displayName)
                                    .font(.system(size: 17, weight: .semibold))
                                    .foregroundColor(NurtureColors.textPrimary)
                                
                                Text(formatRelativeTime(entry.timestamp))
                                    .font(.system(size: 13))
                                    .foregroundColor(NurtureColors.textSecondary)
                            }
                        }
                        
                        Spacer()
                        
                        Image(systemName: "chevron.right")
                            .font(.system(size: 14))
                            .foregroundColor(NurtureColors.textTertiary)
                    }
                    
                    Divider()
                        .background(NurtureColors.divider)
                    
                    // Stats row
                    HStack(spacing: NurtureSpacing.lg) {
                        // Energy level
                        statItem(
                            icon: entry.energyLevel.emoji,
                            label: "Energy",
                            value: entry.energyLevel.displayName
                        )
                        
                        Divider()
                            .frame(height: 30)
                            .background(NurtureColors.divider)
                        
                        // Water intake
                        statItem(
                            icon: "💧",
                            label: "Water",
                            value: "\(entry.waterIntakeOz) oz"
                        )
                        
                        Divider()
                            .frame(height: 30)
                            .background(NurtureColors.divider)
                        
                        // Symptoms
                        statItem(
                            icon: entry.symptoms.isEmpty ? "✓" : "⚠️",
                            label: "Symptoms",
                            value: "\(entry.symptoms.count)"
                        )
                    }
                    
                    // Notes preview (if available)
                    if !entry.notes.isEmpty {
                        Text(entry.notes)
                            .font(.system(size: 14))
                            .foregroundColor(NurtureColors.textSecondary)
                            .lineLimit(2)
                    }
                }
            }
        }
        .buttonStyle(.plain)
    }
    
    // MARK: - Helper Views
    
    @ViewBuilder
    private func statItem(icon: String, label: String, value: String) -> some View {
        HStack(spacing: NurtureSpacing.xs) {
            Text(icon)
                .font(.system(size: 16))
            
            VStack(alignment: .leading, spacing: 2) {
                Text(label)
                    .font(.system(size: 11))
                    .foregroundColor(NurtureColors.textTertiary)
                
                Text(value)
                    .font(.system(size: 13, weight: .medium))
                    .foregroundColor(NurtureColors.textPrimary)
            }
        }
        .frame(maxWidth: .infinity, alignment: .leading)
    }
}

// MARK: - Helper Functions
/// Formats a date as a relative time string
private func formatRelativeTime(_ date: Date) -> String {
    let formatter = RelativeDateTimeFormatter()
    formatter.unitsStyle = .short
    return formatter.localizedString(for: date, relativeTo: Date())
}

// MARK: - Preview

#Preview {
    VStack(spacing: NurtureSpacing.md) {
        RecoveryCard(
            entry: RecoveryEntry(
                babyID: UUID(),
                timestamp: Date().addingTimeInterval(-3600),
                mood: .good,
                energyLevel: .moderate,
                waterIntakeOz: 32,
                symptoms: [.soreness, .cramping],
                notes: "Feeling pretty good today, managing well with regular rest breaks."
            ),
            onTap: { }
        )
        
        RecoveryCard(
            entry: RecoveryEntry(
                babyID: UUID(),
                timestamp: Date().addingTimeInterval(-86400),
                mood: .struggling,
                energyLevel: .low,
                waterIntakeOz: 16,
                symptoms: [.anxiety, .insomnia, .headache],
                notes: ""
            ),
            onTap: { }
        )
    }
    .padding()
    .background(NurtureColors.background)
}


