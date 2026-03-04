//
//  NurtureStatsCard.swift
//  nurtureplus
//
//  Created on 2026-03-03.
//

import SwiftUI

/// Reusable stats card component for displaying metrics
struct NurtureStatsCard: View {
    
    // MARK: - Properties
    
    let icon: String
    let value: String
    let label: String
    let color: Color
    var trend: TrendIndicator? = nil
    
    // MARK: - Body
    
    var body: some View {
        NurtureCard(padding: NurtureSpacing.md) {
            VStack(spacing: NurtureSpacing.sm) {
                // Icon
                Circle()
                    .fill(color.opacity(0.15))
                    .frame(width: 48, height: 48)
                    .overlay {
                        Image(systemName: icon)
                            .font(.system(size: 22))
                            .foregroundColor(color)
                    }
                
                // Value
                HStack(alignment: .firstTextBaseline, spacing: 4) {
                    Text(value)
                        .font(.system(size: 28, weight: .bold))
                        .foregroundColor(NurtureColors.textPrimary)
                    
                    if let trend = trend {
                        trendView(trend)
                    }
                }
                
                // Label
                Text(label)
                    .font(.system(size: 13))
                    .foregroundColor(NurtureColors.textSecondary)
                    .multilineTextAlignment(.center)
                    .lineLimit(2)
            }
            .frame(maxWidth: .infinity)
        }
    }
    
    // MARK: - Trend View
    
    @ViewBuilder
    private func trendView(_ trend: TrendIndicator) -> some View {
        HStack(spacing: 2) {
            Image(systemName: trend.icon)
                .font(.system(size: 10, weight: .bold))
            
            Text(trend.value)
                .font(.system(size: 11, weight: .semibold))
        }
        .foregroundColor(trend.color)
    }
}

// MARK: - Trend Indicator

struct TrendIndicator {
    let value: String
    let direction: Direction
    
    enum Direction {
        case up
        case down
        case neutral
    }
    
    var icon: String {
        switch direction {
        case .up: return "arrow.up"
        case .down: return "arrow.down"
        case .neutral: return "minus"
        }
    }
    
    var color: Color {
        switch direction {
        case .up: return NurtureColors.success
        case .down: return NurtureColors.warning
        case .neutral: return NurtureColors.textTertiary
        }
    }
}

// MARK: - Preview

#Preview {
    VStack(spacing: NurtureSpacing.lg) {
        HStack(spacing: NurtureSpacing.md) {
            NurtureStatsCard(
                icon: "waterbottle.fill",
                value: "8",
                label: "Feedings Today",
                color: NurtureColors.primary,
                trend: TrendIndicator(value: "+2", direction: .up)
            )
            
            NurtureStatsCard(
                icon: "moon.fill",
                value: "5.5",
                label: "Hours Sleep",
                color: NurtureColors.accent
            )
        }
        
        HStack(spacing: NurtureSpacing.md) {
            NurtureStatsCard(
                icon: "leaf.fill",
                value: "12",
                label: "Diaper Changes",
                color: NurtureColors.accentSecondary,
                trend: TrendIndicator(value: "normal", direction: .neutral)
            )
            
            NurtureStatsCard(
                icon: "heart.fill",
                value: "Good",
                label: "Your Mood",
                color: NurtureColors.success
            )
        }
    }
    .padding()
    .background(NurtureColors.background)
}
