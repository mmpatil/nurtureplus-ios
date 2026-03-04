//
//  ProfileView.swift
//  nurtureplus
//
//  Created by Manali Maruti Pat on 3/3/26.
//

import SwiftUI

/// Profile screen - baby profile and app settings
struct ProfileView: View {
    
    @StateObject private var viewModel = ProfileViewModel()
    @State private var showingEditProfile = false
    @State private var showingBabyProfiles = false
    @State private var allProfiles: [BabyProfile] = []
    
    var body: some View {
        ScrollView {
            VStack(spacing: NurtureSpacing.xl) {
                // Manage profiles button (if multiple exist)
                if allProfiles.count > 1 {
                    manageProfilesButton
                }
                
                // Baby profile section
                if let baby = viewModel.babyProfile {
                    babyProfileSection(baby)
                }
                
                // App settings section
                settingsSection
            }
            .padding(NurtureSpacing.lg)
        }
        .background(NurtureColors.background)
        .navigationTitle("Profile")
        .sheet(isPresented: $showingEditProfile) {
            EditBabyProfileView(viewModel: viewModel)
        }
        .sheet(isPresented: $showingBabyProfiles) {
            BabyProfileListView()
                .onDisappear {
                    viewModel.loadData()
                    loadAllProfiles()
                }
        }
        .onAppear {
            loadAllProfiles()
        }
    }
    
    // MARK: - Manage Profiles Button
    
    private var manageProfilesButton: some View {
        Button {
            showingBabyProfiles = true
        } label: {
            NurtureCard {
                HStack {
                    Image(systemName: "person.2.fill")
                        .font(.system(size: 20))
                        .foregroundColor(NurtureColors.primary)
                    
                    VStack(alignment: .leading, spacing: 2) {
                        Text("Manage Baby Profiles")
                            .font(.system(size: 16, weight: .semibold))
                            .foregroundColor(NurtureColors.textPrimary)
                        
                        Text("\(allProfiles.count) profiles")
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
    
    // MARK: - Baby Profile Section
    
    private func babyProfileSection(_ baby: BabyProfile) -> some View {
        VStack(spacing: NurtureSpacing.lg) {
            // Baby avatar and info
            VStack(spacing: NurtureSpacing.md) {
                Circle()
                    .fill(
                        LinearGradient(
                            colors: [NurtureColors.primary, NurtureColors.primaryLight],
                            startPoint: .topLeading,
                            endPoint: .bottomTrailing
                        )
                    )
                    .frame(width: 100, height: 100)
                    .overlay {
                        Text(String(baby.name.prefix(1)))
                            .font(.system(size: 40, weight: .bold))
                            .foregroundColor(.white)
                    }
                    .shadow(color: NurtureColors.shadow, radius: 12, y: 4)
                
                VStack(spacing: NurtureSpacing.xs) {
                    Text(baby.name)
                        .font(.system(size: 28, weight: .bold))
                        .foregroundColor(NurtureColors.textPrimary)
                    
                    Text(baby.ageDescription)
                        .font(.system(size: 17))
                        .foregroundColor(NurtureColors.textSecondary)
                }
            }
            .padding(.vertical, NurtureSpacing.lg)
            
            // Baby info card
            NurtureCard {
                VStack(spacing: NurtureSpacing.md) {
                    infoRow(
                        icon: "calendar",
                        label: "Birth Date",
                        value: formatDate(baby.birthDate)
                    )
                    
                    Divider()
                        .background(NurtureColors.divider)
                    
                    infoRow(
                        icon: "clock",
                        label: "Age in Days",
                        value: "\(baby.ageInDays) days"
                    )
                    
                    Divider()
                        .background(NurtureColors.divider)
                    
                    infoRow(
                        icon: "chart.line.uptrend.xyaxis",
                        label: "Age in Weeks",
                        value: "\(baby.ageInWeeks) weeks"
                    )
                }
            }
            
            // Edit profile button
            NurturePrimaryButton(title: "Edit Baby Profile") {
                viewModel.startEditing()
                showingEditProfile = true
            }
        }
    }
    
    private func infoRow(icon: String, label: String, value: String) -> some View {
        HStack {
            Image(systemName: icon)
                .font(.system(size: 16))
                .foregroundColor(NurtureColors.primary)
                .frame(width: 24)
            
            Text(label)
                .font(.system(size: 15))
                .foregroundColor(NurtureColors.textSecondary)
            
            Spacer()
            
            Text(value)
                .font(.system(size: 15, weight: .medium))
                .foregroundColor(NurtureColors.textPrimary)
        }
    }
    
    // MARK: - Settings Section
    
    private var settingsSection: some View {
        VStack(alignment: .leading, spacing: NurtureSpacing.md) {
            Text("Settings")
                .font(.system(size: 20, weight: .semibold))
                .foregroundColor(NurtureColors.textPrimary)
            
            NurtureCard(padding: 0) {
                VStack(spacing: 0) {
                    // Add Baby Profile button (always visible)
                    Button {
                        showingBabyProfiles = true
                    } label: {
                        HStack(spacing: NurtureSpacing.md) {
                            Circle()
                                .fill(NurtureColors.primaryLight)
                                .frame(width: 40, height: 40)
                                .overlay {
                                    Image(systemName: "person.badge.plus")
                                        .font(.system(size: 18))
                                        .foregroundColor(NurtureColors.primary)
                                }
                            
                            VStack(alignment: .leading, spacing: 2) {
                                Text("Manage Baby Profiles")
                                    .font(.system(size: 16, weight: .medium))
                                    .foregroundColor(NurtureColors.textPrimary)
                                
                                Text("Add or switch between babies")
                                    .font(.system(size: 13))
                                    .foregroundColor(NurtureColors.textSecondary)
                            }
                            
                            Spacer()
                            
                            if allProfiles.count > 1 {
                                Text("\(allProfiles.count)")
                                    .font(.system(size: 14, weight: .bold))
                                    .foregroundColor(NurtureColors.primary)
                                    .padding(.horizontal, 8)
                                    .padding(.vertical, 4)
                                    .background(
                                        Capsule()
                                            .fill(NurtureColors.primaryLight)
                                    )
                            }
                            
                            Image(systemName: "chevron.right")
                                .font(.system(size: 14, weight: .semibold))
                                .foregroundColor(NurtureColors.textTertiary)
                        }
                        .padding(NurtureSpacing.lg)
                    }
                    .buttonStyle(.plain)
                    
                    Divider()
                        .padding(.leading, 60)
                    
                    settingRow(
                        icon: "bell.fill",
                        title: "Notifications",
                        subtitle: "Manage your notification preferences"
                    )
                    
                    Divider()
                        .padding(.leading, 60)
                    
                    settingRow(
                        icon: "moon.fill",
                        title: "Reminders",
                        subtitle: "Set feeding and sleep reminders"
                    )
                    
                    Divider()
                        .padding(.leading, 60)
                    
                    settingRow(
                        icon: "square.and.arrow.up.fill",
                        title: "Export Data",
                        subtitle: "Download your tracking data"
                    )
                    
                    Divider()
                        .padding(.leading, 60)
                    
                    settingRow(
                        icon: "questionmark.circle.fill",
                        title: "Help & Support",
                        subtitle: "Get help or contact support"
                    )
                }
            }
            
            // Danger zone
            VStack(alignment: .leading, spacing: NurtureSpacing.md) {
                Text("Danger Zone")
                    .font(.system(size: 20, weight: .semibold))
                    .foregroundColor(NurtureColors.error)
                    .padding(.top, NurtureSpacing.lg)
                
                Button {
                    resetAllData()
                } label: {
                    HStack {
                        Image(systemName: "trash.fill")
                            .font(.system(size: 16))
                        
                        Text("Reset All Data")
                            .font(.system(size: 15, weight: .medium))
                    }
                    .foregroundColor(NurtureColors.error)
                    .frame(maxWidth: .infinity)
                    .frame(height: 50)
                    .background(
                        RoundedRectangle(cornerRadius: NurtureCornerRadius.md)
                            .stroke(NurtureColors.error, lineWidth: 2)
                    )
                }
            }
            
            // Version info
            Text("Nurture+ v1.0.0")
                .font(.system(size: 13))
                .foregroundColor(NurtureColors.textTertiary)
                .frame(maxWidth: .infinity, alignment: .center)
                .padding(.top, NurtureSpacing.lg)
        }
    }
    
    private func settingRow(icon: String, title: String, subtitle: String) -> some View {
        Button {
            // TODO: Navigate to settings
            print("\(title) tapped")
        } label: {
            HStack(spacing: NurtureSpacing.md) {
                Circle()
                    .fill(NurtureColors.primaryLight)
                    .frame(width: 40, height: 40)
                    .overlay {
                        Image(systemName: icon)
                            .font(.system(size: 18))
                            .foregroundColor(NurtureColors.primary)
                    }
                
                VStack(alignment: .leading, spacing: 2) {
                    Text(title)
                        .font(.system(size: 16, weight: .medium))
                        .foregroundColor(NurtureColors.textPrimary)
                    
                    Text(subtitle)
                        .font(.system(size: 13))
                        .foregroundColor(NurtureColors.textSecondary)
                }
                
                Spacer()
                
                Image(systemName: "chevron.right")
                    .font(.system(size: 14, weight: .semibold))
                    .foregroundColor(NurtureColors.textTertiary)
            }
            .padding(NurtureSpacing.lg)
        }
    }
    
    // MARK: - Helper Methods
    
    private func formatDate(_ date: Date) -> String {
        let formatter = DateFormatter()
        formatter.dateStyle = .long
        return formatter.string(from: date)
    }
    
    private func resetAllData() {
        viewModel.resetAppData()
        OnboardingState.reset()
        
        // Force app to restart by exiting
        // Note: In production, you'd want a more graceful approach
        exit(0)
    }
    
    private func loadAllProfiles() {
        allProfiles = DataManager.shared.loadAllBabyProfiles()
    }
}

// MARK: - Preview

#Preview {
    NavigationStack {
        ProfileView()
    }
}

