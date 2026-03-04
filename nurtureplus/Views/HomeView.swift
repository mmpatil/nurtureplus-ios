//
//  HomeView.swift
//  nurtureplus
//
//  Created by Manali Maruti Pat on 3/3/26.
//

import SwiftUI

/// Home screen - main dashboard with real data
struct HomeView: View {
    
    @StateObject private var viewModel = HomeViewModel()
    @StateObject private var trackingViewModel = TrackingViewModel()
    @StateObject private var recoveryViewModel = RecoveryViewModel()
    @State private var showAddFeeding = false
    @State private var showAddDiaper = false
    @State private var showAddSleep = false
    @State private var showAddRecovery = false
    @State private var showRecoveryHistory = false
    @State private var showingBabyProfiles = false
    @State private var showingAnalytics = false
    @State private var babyProfileCount: Int = 0
    
    var body: some View {
        ScrollView {
            VStack(spacing: NurtureSpacing.xl) {
                // Header with baby info
                headerSection
                
                // Baby info card
                if let baby = viewModel.babyProfile {
                    babyInfoCard(baby)
                }
                
                // Quick action buttons
                quickActionsSection
                
                // Today's summary stats
                todaySummarySection
                
                // Analytics button
                analyticsButton
                
                // Mom Recovery Check-In Card
                recoveryCheckInCard
                
                // Recent activity
                recentActivitySection
            }
            .padding(NurtureSpacing.lg)
        }
        .background(NurtureColors.background)
        .navigationTitle("Home")
        .toolbar {
            ToolbarItem(placement: .automatic) {
                babyProfileCountButton
            }
        }
        .refreshable {
            viewModel.loadData()
        }
        .task {
            viewModel.loadData()
            loadBabyProfileCount()
        }
        .sheet(isPresented: $showingBabyProfiles) {
            BabyProfileListView()
                .onDisappear {
                    viewModel.loadData()
                    loadBabyProfileCount()
                }
        }
        .sheet(isPresented: $showAddFeeding) {
            AddFeedingView(viewModel: trackingViewModel)
                .onDisappear {
                    viewModel.loadData()
                }
        }
        .sheet(isPresented: $showAddDiaper) {
            AddDiaperView(viewModel: trackingViewModel)
                .onDisappear {
                    viewModel.loadData()
                }
        }
        .sheet(isPresented: $showAddSleep) {
            AddSleepView(viewModel: trackingViewModel)
                .onDisappear {
                    viewModel.loadData()
                }
        }
        .sheet(isPresented: $showAddRecovery) {
            if let babyIDString = viewModel.babyProfile?.id,
               let babyID = UUID(uuidString: babyIDString) {
                AddRecoveryView(viewModel: recoveryViewModel, babyID: babyID)
                    .onDisappear {
                        viewModel.loadData()
                    }
            }
        }
        .sheet(isPresented: $showRecoveryHistory) {
            if let babyIDString = viewModel.babyProfile?.id,
               let babyID = UUID(uuidString: babyIDString) {
                RecoveryHistoryView(babyID: babyID)
            }
        }
        .sheet(isPresented: $showingAnalytics) {
            AnalyticsView()
        }
    }
    
    // MARK: - View Components
    
    private var babyProfileCountButton: some View {
        Button {
            showingBabyProfiles = true
        } label: {
            HStack(spacing: 6) {
                // Circular badge with baby count
                Circle()
                    .fill(
                        LinearGradient(
                            colors: [NurtureColors.primary, NurtureColors.primaryLight],
                            startPoint: .topLeading,
                            endPoint: .bottomTrailing
                        )
                    )
                    .frame(width: 32, height: 32)
                    .overlay {
                        VStack(spacing: 0) {
                            Text("\(babyProfileCount)")
                                .font(.system(size: 14, weight: .bold))
                                .foregroundColor(.white)
                            
                            Text(babyProfileCount == 1 ? "baby" : "babies")
                                .font(.system(size: 6, weight: .semibold))
                                .foregroundColor(.white.opacity(0.9))
                        }
                    }
            }
        }
        .buttonStyle(.plain)
    }
    
    private var headerSection: some View {
        VStack(alignment: .leading, spacing: NurtureSpacing.xs) {
            Text(greetingText)
                .font(.system(size: 16))
                .foregroundColor(NurtureColors.textSecondary)
            
            if let baby = viewModel.babyProfile {
                Text("\(baby.name)'s Dashboard")
                    .font(.system(size: 28, weight: .bold))
                    .foregroundColor(NurtureColors.textPrimary)
            } else {
                Text("Welcome to Nurture+")
                    .font(.system(size: 28, weight: .bold))
                    .foregroundColor(NurtureColors.textPrimary)
            }
        }
        .frame(maxWidth: .infinity, alignment: .leading)
    }
    
    private func babyInfoCard(_ baby: BabyProfile) -> some View {
        NurtureCard {
            HStack(spacing: NurtureSpacing.md) {
                // Baby avatar
                BabyAvatarView(
                    name: baby.name,
                    photoFilename: baby.photoURL,
                    size: 60
                )
                
                VStack(alignment: .leading, spacing: NurtureSpacing.xs) {
                    Text(baby.name)
                        .font(.system(size: 20, weight: .semibold))
                        .foregroundColor(NurtureColors.textPrimary)
                    
                    Text(baby.ageDescription)
                        .font(.system(size: 15))
                        .foregroundColor(NurtureColors.textSecondary)
                    
                    Text("Born \(formattedDate(baby.birthDate))")
                        .font(.system(size: 13))
                        .foregroundColor(NurtureColors.textTertiary)
                }
                
                Spacer()
            }
        }
    }
    
    private var quickActionsSection: some View {
        VStack(alignment: .leading, spacing: NurtureSpacing.md) {
            Text("Quick Actions")
                .font(.system(size: 20, weight: .semibold))
                .foregroundColor(NurtureColors.textPrimary)
            
            HStack(spacing: NurtureSpacing.md) {
                quickActionButton(
                    icon: "waterbottle.fill",
                    label: "Feeding",
                    color: NurtureColors.primary
                ) {
                    showAddFeeding = true
                }
                
                quickActionButton(
                    icon: "leaf.fill",
                    label: "Diaper",
                    color: NurtureColors.accentSecondary
                ) {
                    showAddDiaper = true
                }
                
                quickActionButton(
                    icon: "moon.fill",
                    label: "Sleep",
                    color: NurtureColors.accent
                ) {
                    showAddSleep = true
                }
            }
        }
    }
    
    private func quickActionButton(icon: String, label: String, color: Color, action: @escaping () -> Void) -> some View {
        Button(action: action) {
            VStack(spacing: NurtureSpacing.sm) {
                Circle()
                    .fill(color.opacity(0.15))
                    .frame(width: 56, height: 56)
                    .overlay {
                        Image(systemName: icon)
                            .font(.system(size: 24))
                            .foregroundColor(color)
                    }
                
                Text(label)
                    .font(.system(size: 13, weight: .medium))
                    .foregroundColor(NurtureColors.textPrimary)
            }
            .frame(maxWidth: .infinity)
            .padding(.vertical, NurtureSpacing.md)
            .background(
                RoundedRectangle(cornerRadius: NurtureCornerRadius.md)
                    .fill(NurtureColors.cardBackground)
            )
        }
    }
    
    private var todaySummarySection: some View {
        VStack(alignment: .leading, spacing: NurtureSpacing.md) {
            Text("Today's Summary")
                .font(.system(size: 20, weight: .semibold))
                .foregroundColor(NurtureColors.textPrimary)
            
            HStack(spacing: NurtureSpacing.md) {
                summaryStatCard(
                    icon: "waterbottle.fill",
                    value: "\(viewModel.todayFeedingCount)",
                    label: "Feedings",
                    color: NurtureColors.primary
                )
                
                summaryStatCard(
                    icon: "leaf.fill",
                    value: "\(viewModel.todayDiaperCount)",
                    label: "Diapers",
                    color: NurtureColors.accentSecondary
                )
                
                summaryStatCard(
                    icon: "moon.fill",
                    value: String(format: "%.1f", viewModel.todaySleepHours),
                    label: "Sleep hrs",
                    color: NurtureColors.accent
                )
            }
        }
    }
    
    private func summaryStatCard(icon: String, value: String, label: String, color: Color) -> some View {
        NurtureCard(padding: NurtureSpacing.md) {
            VStack(spacing: NurtureSpacing.sm) {
                Image(systemName: icon)
                    .font(.system(size: 24))
                    .foregroundColor(color)
                
                Text(value)
                    .font(.system(size: 24, weight: .bold))
                    .foregroundColor(NurtureColors.textPrimary)
                
                Text(label)
                    .font(.system(size: 12))
                    .foregroundColor(NurtureColors.textSecondary)
                    .multilineTextAlignment(.center)
            }
            .frame(maxWidth: .infinity)
        }
    }
    
    private var analyticsButton: some View {
        Button {
            showingAnalytics = true
        } label: {
            NurtureCard {
                HStack {
                    Image(systemName: "chart.xyaxis.line")
                        .font(.system(size: 20))
                        .foregroundColor(NurtureColors.primary)
                    
                    VStack(alignment: .leading, spacing: 2) {
                        Text("View Analytics")
                            .font(.system(size: 17, weight: .semibold))
                            .foregroundColor(NurtureColors.textPrimary)
                        
                        Text("See trends and patterns")
                            .font(.system(size: 14))
                            .foregroundColor(NurtureColors.textSecondary)
                    }
                    
                    Spacer()
                    
                    Image(systemName: "chevron.right")
                        .font(.system(size: 14, weight: .semibold))
                        .foregroundColor(NurtureColors.textTertiary)
                }
            }
        }
        .buttonStyle(.plain)
    }
    
    private var recoveryCheckInCard: some View {
        VStack(spacing: NurtureSpacing.sm) {
            // Main recovery card
            Button {
                showAddRecovery = true
            } label: {
                NurtureCard {
                    VStack(alignment: .leading, spacing: NurtureSpacing.md) {
                        HStack {
                            VStack(alignment: .leading, spacing: NurtureSpacing.xs) {
                                Text("How are you feeling?")
                                    .font(.system(size: 17, weight: .semibold))
                                    .foregroundColor(NurtureColors.textPrimary)
                                
                                if let babyIDString = viewModel.babyProfile?.id,
                                   let babyID = UUID(uuidString: babyIDString),
                                   let latestEntry = recoveryViewModel.loadLatestEntry(for: babyID) {
                                    Text("\(latestEntry.mood.emoji) \(latestEntry.mood.displayName) • \(latestEntry.waterIntakeOz) oz water")
                                        .font(.system(size: 14))
                                        .foregroundColor(NurtureColors.textSecondary)
                                } else {
                                    Text("Track your mood, energy & recovery")
                                        .font(.system(size: 14))
                                        .foregroundColor(NurtureColors.textSecondary)
                                }
                            }
                            
                            Spacer()
                            
                            Image(systemName: "heart.circle.fill")
                                .font(.system(size: 40))
                                .foregroundColor(NurtureColors.accent)
                        }
                    }
                }
            }
            .buttonStyle(.plain)
            
            // View history button
            Button {
                showRecoveryHistory = true
            } label: {
                HStack {
                    Image(systemName: "clock.arrow.circlepath")
                        .font(.system(size: 13))
                    
                    Text("View Recovery History")
                        .font(.system(size: 14, weight: .medium))
                    
                    Spacer()
                    
                    Image(systemName: "chevron.right")
                        .font(.system(size: 12))
                }
                .foregroundColor(NurtureColors.primary)
                .padding(.horizontal, NurtureSpacing.md)
            }
        }
    }
    
    private var recentActivitySection: some View {
        VStack(alignment: .leading, spacing: NurtureSpacing.md) {
            Text("Recent Activity")
                .font(.system(size: 20, weight: .semibold))
                .foregroundColor(NurtureColors.textPrimary)
            
            if viewModel.todayFeedings.isEmpty && viewModel.todayDiapers.isEmpty && viewModel.todaySleep.isEmpty {
                NurtureCard {
                    VStack(spacing: NurtureSpacing.sm) {
                        Image(systemName: "tray")
                            .font(.system(size: 40))
                            .foregroundColor(NurtureColors.textTertiary)
                        
                        Text("No activity yet today")
                            .font(.system(size: 15))
                            .foregroundColor(NurtureColors.textSecondary)
                        
                        Text("Start tracking to see your activity here")
                            .font(.system(size: 13))
                            .foregroundColor(NurtureColors.textTertiary)
                            .multilineTextAlignment(.center)
                    }
                    .frame(maxWidth: .infinity)
                    .padding(NurtureSpacing.lg)
                }
            } else {
                VStack(spacing: NurtureSpacing.sm) {
                    // Show recent feedings
                    ForEach(viewModel.todayFeedings.prefix(3)) { feeding in
                        activityRow(
                            icon: feeding.feedingType.icon,
                            iconColor: NurtureColors.primary,
                            title: feeding.summaryDescription,
                            time: feeding.timestamp
                        )
                    }
                    
                    // Show recent diapers
                    ForEach(viewModel.todayDiapers.prefix(3)) { diaper in
                        activityRow(
                            icon: diaper.type.icon,
                            iconColor: NurtureColors.accentSecondary,
                            title: diaper.summaryDescription,
                            time: diaper.timestamp
                        )
                    }
                    
                    // Show recent sleep
                    ForEach(viewModel.todaySleep.prefix(3)) { sleep in
                        activityRow(
                            icon: "moon.fill",
                            iconColor: NurtureColors.accent,
                            title: sleep.summaryDescription,
                            time: sleep.startTime
                        )
                    }
                }
            }
        }
    }
    
    private func activityRow(icon: String, iconColor: Color, title: String, time: Date) -> some View {
        HStack(spacing: NurtureSpacing.md) {
            Circle()
                .fill(iconColor.opacity(0.2))
                .frame(width: 40, height: 40)
                .overlay {
                    Image(systemName: icon)
                        .font(.system(size: 18))
                        .foregroundColor(iconColor)
                }
            
            VStack(alignment: .leading, spacing: 2) {
                Text(title)
                    .font(.system(size: 15, weight: .medium))
                    .foregroundColor(NurtureColors.textPrimary)
                
                Text(formatRelativeTime(time))
                    .font(.system(size: 13))
                    .foregroundColor(NurtureColors.textSecondary)
            }
            
            Spacer()
        }
        .padding(NurtureSpacing.md)
        .background(
            RoundedRectangle(cornerRadius: NurtureCornerRadius.sm)
                .fill(NurtureColors.cardBackground)
        )
    }
    
    // MARK: - Computed Properties
    
    private var greetingText: String {
        let hour = Calendar.current.component(.hour, from: Date())
        
        switch hour {
        case 0..<12:
            return "Good morning"
        case 12..<17:
            return "Good afternoon"
        default:
            return "Good evening"
        }
    }
    
    // MARK: - Helper Methods
    
    private func loadBabyProfileCount() {
        let profiles = DataManager.shared.loadAllBabyProfiles()
        babyProfileCount = profiles.count
    }
    
    private func formattedDate(_ date: Date) -> String {
        let formatter = DateFormatter()
        formatter.dateStyle = .medium
        return formatter.string(from: date)
    }
    
    private func formatRelativeTime(_ date: Date) -> String {
        let formatter = RelativeDateTimeFormatter()
        formatter.unitsStyle = .short
        return formatter.localizedString(for: date, relativeTo: Date())
    }
}

// MARK: - Preview

#Preview {
    NavigationStack {
        HomeView()
    }
}

