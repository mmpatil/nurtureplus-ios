//
//  ResourcesView.swift
//  nurtureplus
//
//  Created by Manali Maruti Pat on 3/3/26.
//

import SwiftUI

/// Resources screen - educational content and support
struct ResourcesView: View {
    
    var body: some View {
        ScrollView {
            VStack(spacing: NurtureSpacing.lg) {
                Text("Resources coming soon")
                    .font(.system(size: 17))
                    .foregroundColor(NurtureColors.textSecondary)
                    .padding(NurtureSpacing.xxxl)
            }
        }
        .background(NurtureColors.background)
        .navigationTitle("Resources")
    }
}

// MARK: - Preview

#Preview {
    NavigationStack {
        ResourcesView()
    }
}

