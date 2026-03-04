//
//  NurturePrimaryButton.swift
//  nurtureplus
//
//  Created by Manali Maruti Pat on 3/3/26.
//

import SwiftUI

/// Primary button component with consistent styling
struct NurturePrimaryButton: View {
    
    // MARK: - Properties
    
    let title: String
    let action: () -> Void
    var isEnabled: Bool = true
    var isLoading: Bool = false
    
    // MARK: - Body
    
    var body: some View {
        Button(action: action) {
            HStack(spacing: NurtureSpacing.sm) {
                if isLoading {
                    ProgressView()
                        .tint(.white)
                }
                
                Text(title)
                    .font(.system(size: 17, weight: .semibold))
                    .foregroundColor(.white)
            }
            .frame(maxWidth: .infinity)
            .frame(height: 56)
            .background(
                RoundedRectangle(cornerRadius: NurtureCornerRadius.md)
                    .fill(buttonBackgroundColor)
            )
            .shadow(
                color: isEnabled ? NurtureColors.shadow : .clear,
                radius: 8,
                y: 4
            )
        }
        .disabled(!isEnabled || isLoading)
        .animation(.easeInOut(duration: 0.2), value: isEnabled)
        .animation(.easeInOut(duration: 0.2), value: isLoading)
    }
    
    // MARK: - Computed Properties
    
    private var buttonBackgroundColor: Color {
        if !isEnabled {
            return NurtureColors.textTertiary
        }
        return NurtureColors.primary
    }
}

// MARK: - Preview

#Preview {
    VStack(spacing: NurtureSpacing.lg) {
        NurturePrimaryButton(title: "Continue") {
            print("Button tapped")
        }
        
        NurturePrimaryButton(title: "Disabled", action: {}, isEnabled: false)
        
        NurturePrimaryButton(title: "Loading", action: {}, isLoading: true)
    }
    .padding()
    .background(NurtureColors.background)
}
