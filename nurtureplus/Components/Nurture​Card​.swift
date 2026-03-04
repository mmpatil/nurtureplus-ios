//
//  Nurture​Card​.swift
//  nurtureplus
//
//  Created by Manali Maruti Pat on 3/3/26.
//

import SwiftUI

/// Reusable card container with consistent styling
struct NurtureCard<Content: View>: View {
    
    // MARK: - Properties
    
    let content: Content
    var padding: CGFloat = NurtureSpacing.lg
    var cornerRadius: CGFloat = NurtureCornerRadius.md
    
    // MARK: - Initialization
    
    init(
        padding: CGFloat = NurtureSpacing.lg,
        cornerRadius: CGFloat = NurtureCornerRadius.md,
        @ViewBuilder content: () -> Content
    ) {
        self.padding = padding
        self.cornerRadius = cornerRadius
        self.content = content()
    }
    
    // MARK: - Body
    
    var body: some View {
        content
            .padding(padding)
            .frame(maxWidth: .infinity, alignment: .leading)
            .background(
                RoundedRectangle(cornerRadius: cornerRadius)
                    .fill(NurtureColors.cardBackground)
                    .shadow(
                        color: NurtureColors.shadow,
                        radius: 8,
                        y: 2
                    )
            )
    }
}

// MARK: - Preview

#Preview {
    VStack(spacing: NurtureSpacing.lg) {
        NurtureCard {
            VStack(alignment: .leading, spacing: NurtureSpacing.sm) {
                Text("Welcome to Nurture+")
                    .font(.system(size: 20, weight: .semibold))
                    .foregroundColor(NurtureColors.textPrimary)
                
                Text("Your companion for postpartum recovery and baby care")
                    .font(.system(size: 15))
                    .foregroundColor(NurtureColors.textSecondary)
            }
        }
        
        NurtureCard(padding: NurtureSpacing.xl, cornerRadius: NurtureCornerRadius.lg) {
            Text("Custom padding and corner radius")
                .font(.system(size: 15))
                .foregroundColor(NurtureColors.textPrimary)
        }
    }
    .padding()
    .background(NurtureColors.background)
}

