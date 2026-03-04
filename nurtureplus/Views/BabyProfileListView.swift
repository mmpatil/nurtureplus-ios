//
//  BabyProfileListView.swift
//  nurtureplus
//
//  Created on 2026-03-03.
//

import SwiftUI

/// View for managing multiple baby profiles
struct BabyProfileListView: View {
    
    @Environment(\.dismiss) private var dismiss
    @State private var profiles: [BabyProfile] = []
    @State private var activeProfileId: String?
    @State private var showingAddProfile = false
    
    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(spacing: NurtureSpacing.lg) {
                    if profiles.isEmpty {
                        emptyState
                    } else {
                        ForEach(profiles) { profile in
                            profileCard(profile)
                        }
                    }
                }
                .padding(NurtureSpacing.lg)
            }
            .background(NurtureColors.background)
            .navigationTitle("Baby Profiles")
            #if !os(macOS)
            .navigationBarTitleDisplayMode(.large)
            #endif
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("Done") {
                        dismiss()
                    }
                }
                
                ToolbarItem(placement: .primaryAction) {
                    Button {
                        showingAddProfile = true
                    } label: {
                        Image(systemName: "plus.circle.fill")
                            .foregroundColor(NurtureColors.primary)
                    }
                }
            }
            .onAppear {
                loadProfiles()
            }
            .sheet(isPresented: $showingAddProfile) {
                CreateBabyProfileView { newProfile in
                    loadProfiles()
                }
            }
        }
    }
    
    // MARK: - Profile Card
    
    private func profileCard(_ profile: BabyProfile) -> some View {
        Button {
            switchToProfile(profile)
        } label: {
            NurtureCard {
                HStack(spacing: NurtureSpacing.lg) {
                    // Avatar
                    BabyAvatarView(
                        name: profile.name,
                        photoFilename: profile.photoURL,
                        size: 70
                    )
                    
                    // Info
                    VStack(alignment: .leading, spacing: NurtureSpacing.xs) {
                        HStack {
                            Text(profile.name)
                                .font(.system(size: 20, weight: .bold))
                                .foregroundColor(NurtureColors.textPrimary)
                            
                            if profile.id == activeProfileId {
                                Text("Active")
                                    .font(.system(size: 12, weight: .semibold))
                                    .foregroundColor(NurtureColors.success)
                                    .padding(.horizontal, NurtureSpacing.sm)
                                    .padding(.vertical, 4)
                                    .background(
                                        Capsule()
                                            .fill(NurtureColors.success.opacity(0.15))
                                    )
                            }
                        }
                        
                        Text(profile.ageDescription)
                            .font(.system(size: 15))
                            .foregroundColor(NurtureColors.textSecondary)
                        
                        Text("Born \(formatDate(profile.birthDate))")
                            .font(.system(size: 13))
                            .foregroundColor(NurtureColors.textTertiary)
                    }
                    
                    Spacer()
                    
                    if profile.id != activeProfileId {
                        Image(systemName: "chevron.right")
                            .font(.system(size: 14, weight: .semibold))
                            .foregroundColor(NurtureColors.textTertiary)
                    }
                }
                .padding(NurtureSpacing.md)
            }
        }
        .buttonStyle(.plain)
        .contextMenu {
            if profiles.count > 1 && profile.id != activeProfileId {
                Button(action: {
                    switchToProfile(profile)
                }) {
                    Label("Switch to \(profile.name)", systemImage: "arrow.triangle.2.circlepath")
                }
            }
            
            Button(role: .destructive, action: {
                deleteProfile(profile)
            }) {
                Label("Delete", systemImage: "trash")
            }
        }
    }
    
    // MARK: - Empty State
    
    private var emptyState: some View {
        VStack(spacing: NurtureSpacing.xl) {
            Spacer()
            
            Image(systemName: "figure.and.child.holdinghands")
                .font(.system(size: 60))
                .foregroundColor(NurtureColors.primary)
            
            Text("No Baby Profiles")
                .font(.system(size: 24, weight: .bold))
                .foregroundColor(NurtureColors.textPrimary)
            
            Text("Add your first baby profile to start tracking")
                .font(.system(size: 16))
                .foregroundColor(NurtureColors.textSecondary)
                .multilineTextAlignment(.center)
            
            NurturePrimaryButton(title: "Add Baby Profile") {
                showingAddProfile = true
            }
            .padding(.horizontal, NurtureSpacing.xl)
            
            Spacer()
        }
    }
    
    // MARK: - Actions
    
    private func loadProfiles() {
        profiles = DataManager.shared.loadAllBabyProfiles()
        activeProfileId = DataManager.shared.getActiveBabyProfileId()
    }
    
    private func switchToProfile(_ profile: BabyProfile) {
        DataManager.shared.setActiveBabyProfile(profile.id)
        activeProfileId = profile.id
        
        // Dismiss to trigger refresh in parent views
        dismiss()
    }
    
    private func deleteProfile(_ profile: BabyProfile) {
        guard profiles.count > 1 || profiles.first?.id != profile.id else {
            // Don't allow deleting the last profile
            return
        }
        
        DataManager.shared.deleteBabyProfile(profile.id)
        loadProfiles()
    }
    
    // MARK: - Helpers
    
    private func formatDate(_ date: Date) -> String {
        let formatter = DateFormatter()
        formatter.dateStyle = .medium
        return formatter.string(from: date)
    }
}

// MARK: - Preview

#Preview {
    BabyProfileListView()
}
