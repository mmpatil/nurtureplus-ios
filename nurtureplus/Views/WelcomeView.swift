//
//  WelcomeView.swift
//  nurtureplus
//
//  Created on 2026-03-03.
//

import SwiftUI

/// Welcome screen for onboarding
struct WelcomeView: View {
    
    var onComplete: (() -> Void)?
    @State private var currentPage = 0
    
    private let pages: [OnboardingPage] = [
        OnboardingPage(
            icon: "heart.circle.fill",
            color: .init(red: 0.98, green: 0.85, blue: 0.78),
            title: "Welcome to Nurture+",
            description: "Your companion for postpartum recovery and baby care. We're here to support you every step of the way."
        ),
        OnboardingPage(
            icon: "chart.line.uptrend.xyaxis",
            color: .init(red: 0.65, green: 0.75, blue: 0.68),
            title: "Track What Matters",
            description: "Log feedings, diaper changes, sleep patterns, and your own wellness check-ins all in one place."
        ),
        OnboardingPage(
            icon: "sparkles",
            color: .init(red: 0.85, green: 0.82, blue: 0.92),
            title: "Insights & Patterns",
            description: "See trends and patterns in your baby's routine to help you feel more confident and prepared."
        ),
        OnboardingPage(
            icon: "leaf.fill",
            color: .init(red: 0.6, green: 0.8, blue: 0.7),
            title: "You've Got This",
            description: "Remember to be gentle with yourself. Every journey is unique, and you're doing an amazing job."
        )
    ]
    
    var body: some View {
        ZStack {
            NurtureColors.background
                .ignoresSafeArea()
            
            VStack(spacing: 0) {
                // Page indicator
                HStack(spacing: 8) {
                    ForEach(0..<pages.count, id: \.self) { index in
                        Circle()
                            .fill(currentPage == index ? NurtureColors.primary : NurtureColors.divider)
                            .frame(width: 8, height: 8)
                            .animation(.spring(response: 0.3), value: currentPage)
                    }
                }
                .padding(.top, NurtureSpacing.xl)
                
                // Content
                TabView(selection: $currentPage) {
                    ForEach(Array(pages.enumerated()), id: \.offset) { index, page in
                        onboardingPageView(page)
                            .tag(index)
                    }
                }
                #if os(iOS)
                .tabViewStyle(.page(indexDisplayMode: .never))
                #endif
                
                // Continue button
                VStack(spacing: NurtureSpacing.lg) {
                    if currentPage == pages.count - 1 {
                        NurturePrimaryButton(title: "Get Started") {
                            completeOnboarding()
                        }
                        .padding(.horizontal, NurtureSpacing.lg)
                        .transition(.scale.combined(with: .opacity))
                    } else {
                        Button("Skip") {
                            completeOnboarding()
                        }
                        .font(.system(size: 16, weight: .medium))
                        .foregroundColor(NurtureColors.textSecondary)
                        .padding(.vertical, NurtureSpacing.lg)
                    }
                }
                .padding(.bottom, NurtureSpacing.xl)
            }
        }
        .animation(.spring(response: 0.4, dampingFraction: 0.8), value: currentPage)
    }
    
    // MARK: - Page View
    
    private func onboardingPageView(_ page: OnboardingPage) -> some View {
        VStack(spacing: NurtureSpacing.xxxl) {
            Spacer()
            
            // Icon
            Circle()
                .fill(
                    LinearGradient(
                        colors: [page.color, page.color.opacity(0.6)],
                        startPoint: .topLeading,
                        endPoint: .bottomTrailing
                    )
                )
                .frame(width: 120, height: 120)
                .overlay {
                    Image(systemName: page.icon)
                        .font(.system(size: 50, weight: .medium))
                        .foregroundColor(.white)
                }
                .shadow(color: page.color.opacity(0.3), radius: 20, y: 10)
            
            VStack(spacing: NurtureSpacing.lg) {
                Text(page.title)
                    .font(.system(size: 32, weight: .bold))
                    .foregroundColor(NurtureColors.textPrimary)
                    .multilineTextAlignment(.center)
                
                Text(page.description)
                    .font(.system(size: 17))
                    .foregroundColor(NurtureColors.textSecondary)
                    .multilineTextAlignment(.center)
                    .lineSpacing(6)
                    .padding(.horizontal, NurtureSpacing.xl)
            }
            
            Spacer()
        }
        .padding(NurtureSpacing.xl)
    }
    
    // MARK: - Actions
    
    private func completeOnboarding() {
        var state = OnboardingState.load()
        state.hasCompletedOnboarding = true
        state.save()
        
        onComplete?()
    }
}

// MARK: - Onboarding Page Model

struct OnboardingPage {
    let icon: String
    let color: Color
    let title: String
    let description: String
}

// MARK: - Preview

#Preview {
    WelcomeView()
}
