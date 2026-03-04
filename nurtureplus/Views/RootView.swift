//
//  RootView.swift
//  nurtureplus
//
//  Created by Manali Maruti Pat on 3/3/26.
//

import SwiftUI

/// Root navigation container with tab bar and onboarding
struct RootView: View {
    
    @StateObject private var router = AppRouter.shared
    @StateObject private var appState = AppState.shared
    @State private var onboardingState = OnboardingState.load()
    
    var body: some View {
        Group {
            if !onboardingState.hasCompletedOnboarding {
                WelcomeView(onComplete: {
                    onboardingState = OnboardingState.load()
                })
            } else if !onboardingState.hasCreatedBabyProfile {
                CreateBabyProfileView { _ in
                    onboardingState = OnboardingState.load()
                }
            } else {
                mainTabView
            }
        }
        .onAppear {
            onboardingState = OnboardingState.load()
        }
    }
    
    private var mainTabView: some View {
        TabView(selection: $router.selectedTab) {
            ForEach(AppTab.allCases, id: \.self) { tab in
                NavigationStack(path: $router.path) {
                    viewForTab(tab)
                        .navigationDestination(for: AppRoute.self) { route in
                            destinationView(for: route)
                        }
                }
                .tabItem {
                    Label(tab.title, systemImage: tab.icon)
                }
                .tag(tab)
            }
        }
        .tint(NurtureColors.primary)
        .overlay {
            if let errorMessage = appState.errorMessage {
                errorBanner(message: errorMessage)
            }
        }
    }
    
    // MARK: - View Helpers
    
    @ViewBuilder
    private func viewForTab(_ tab: AppTab) -> some View {
        switch tab {
        case .home:
            HomeView()
        case .tracking:
            TrackingView()
        case .resources:
            ResourcesView()
        case .profile:
            ProfileView()
        }
    }
    
    @ViewBuilder
    private func destinationView(for route: AppRoute) -> some View {
        switch route {
        case .placeholder:
            Text("Placeholder")
        }
    }
    
    private func errorBanner(message: String) -> some View {
        VStack {
            HStack {
                Image(systemName: "exclamationmark.triangle.fill")
                    .foregroundColor(NurtureColors.error)
                
                Text(message)
                    .font(.system(size: 14, weight: .medium))
                    .foregroundColor(NurtureColors.textPrimary)
                
                Spacer()
                
                Button {
                    appState.clearError()
                } label: {
                    Image(systemName: "xmark.circle.fill")
                        .foregroundColor(NurtureColors.textSecondary)
                }
            }
            .padding(NurtureSpacing.lg)
            .background(
                RoundedRectangle(cornerRadius: NurtureCornerRadius.md)
                    .fill(NurtureColors.cardBackground)
                    .shadow(color: NurtureColors.shadow, radius: 12, y: 4)
            )
            .padding(NurtureSpacing.lg)
            
            Spacer()
        }
        .transition(.move(edge: .top).combined(with: .opacity))
        .animation(.spring(response: 0.4, dampingFraction: 0.8), value: appState.errorMessage)
    }
}

// MARK: - Preview

#Preview {
    RootView()
}

