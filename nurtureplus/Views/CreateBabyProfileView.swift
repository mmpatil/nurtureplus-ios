//
//  CreateBabyProfileView.swift
//  nurtureplus
//
//  Created on 2026-03-03.
//

import SwiftUI
import PhotosUI

/// View for creating a new baby profile
struct CreateBabyProfileView: View {
    
    @Environment(\.dismiss) private var dismiss
    
    @State private var babyName: String = ""
    @State private var birthDate: Date = Date()
    @State private var showingDatePicker = false
    @State private var showError = false
    
    // Photo picker
    @State private var selectedPhoto: PhotosPickerItem?
    @State private var profileImage: PlatformImage?
    
    var onComplete: ((BabyProfile) -> Void)?
    
    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(spacing: NurtureSpacing.xxxl) {
                    // Header
                    headerSection
                    
                    // Avatar placeholder
                    avatarSection
                    
                    // Form fields
                    formSection
                    
                    // Save button
                    NurturePrimaryButton(
                        title: "Create Profile",
                        action: saveProfile,
                        isEnabled: !babyName.isEmpty
                    )
                }
                .padding(NurtureSpacing.xl)
            }
            .background(NurtureColors.background)
            .navigationTitle("Baby Profile")
            #if os(iOS)
            .navigationBarTitleDisplayMode(.inline)
            #endif
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("Cancel") {
                        dismiss()
                    }
                }
            }
            .alert("Name Required", isPresented: $showError) {
                Button("OK", role: .cancel) {}
            } message: {
                Text("Please enter your baby's name")
            }
        }
    }
    
    // MARK: - Sections
    
    private var headerSection: some View {
        VStack(spacing: NurtureSpacing.md) {
            Text("Let's meet your little one")
                .font(.system(size: 28, weight: .bold))
                .foregroundColor(NurtureColors.textPrimary)
                .multilineTextAlignment(.center)
            
            Text("Tell us a bit about your baby to personalize your experience")
                .font(.system(size: 16))
                .foregroundColor(NurtureColors.textSecondary)
                .multilineTextAlignment(.center)
                .lineSpacing(4)
        }
    }
    
    private var avatarSection: some View {
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
                    if let profileImage = profileImage {
                        #if canImport(UIKit)
                        Image(uiImage: profileImage)
                            .resizable()
                            .scaledToFill()
                            .frame(width: 100, height: 100)
                            .clipShape(Circle())
                        #elseif canImport(AppKit)
                        Image(nsImage: profileImage)
                            .resizable()
                            .scaledToFill()
                            .frame(width: 100, height: 100)
                            .clipShape(Circle())
                        #endif
                    } else if babyName.isEmpty {
                        Image(systemName: "figure.and.child.holdinghands")
                            .font(.system(size: 40))
                            .foregroundColor(.white)
                    } else {
                        Text(String(babyName.prefix(1).uppercased()))
                            .font(.system(size: 40, weight: .bold))
                            .foregroundColor(.white)
                    }
                }
                .shadow(color: NurtureColors.shadow, radius: 12, y: 4)
            
            PhotosPicker(selection: $selectedPhoto, matching: .images) {
                HStack(spacing: NurtureSpacing.xs) {
                    Image(systemName: profileImage == nil ? "camera.fill" : "photo.fill")
                        .font(.system(size: 14))
                    Text(profileImage == nil ? "Add Photo" : "Change Photo")
                        .font(.system(size: 15, weight: .medium))
                }
                .foregroundColor(NurtureColors.primary)
            }
            .onChange(of: selectedPhoto) { _, newValue in
                Task {
                    if let newValue = newValue {
                        profileImage = await PhotoManager.shared.loadImage(from: newValue)
                    }
                }
            }
        }
    }
    
    private var formSection: some View {
        VStack(spacing: NurtureSpacing.xl) {
            // Name field
            VStack(alignment: .leading, spacing: NurtureSpacing.md) {
                Text("Baby's Name")
                    .font(.system(size: 17, weight: .semibold))
                    .foregroundColor(NurtureColors.textPrimary)
                
                TextField("Enter name", text: $babyName)
                    .font(.system(size: 17))
                    .padding(NurtureSpacing.lg)
                    .background(
                        RoundedRectangle(cornerRadius: NurtureCornerRadius.md)
                            .fill(NurtureColors.cardBackground)
                    )
                    .overlay(
                        RoundedRectangle(cornerRadius: NurtureCornerRadius.md)
                            .stroke(NurtureColors.divider, lineWidth: 1)
                    )
            }
            
            // Birth date field
            VStack(alignment: .leading, spacing: NurtureSpacing.md) {
                Text("Birth Date")
                    .font(.system(size: 17, weight: .semibold))
                    .foregroundColor(NurtureColors.textPrimary)
                
                DatePicker(
                    "",
                    selection: $birthDate,
                    in: ...Date(),
                    displayedComponents: .date
                )
                .datePickerStyle(.compact)
                .labelsHidden()
                .tint(NurtureColors.primary)
                
                // Age preview
                if birthDate < Date() {
                    HStack(spacing: NurtureSpacing.xs) {
                        Image(systemName: "info.circle.fill")
                            .font(.system(size: 14))
                            .foregroundColor(NurtureColors.primary)
                        
                        Text(agePreviewText)
                            .font(.system(size: 14))
                            .foregroundColor(NurtureColors.textSecondary)
                    }
                    .padding(NurtureSpacing.md)
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .background(
                        RoundedRectangle(cornerRadius: NurtureCornerRadius.sm)
                            .fill(NurtureColors.primaryLight)
                    )
                }
            }
        }
    }
    
    // MARK: - Computed Properties
    
    private var agePreviewText: String {
        let days = Calendar.current.dateComponents([.day], from: birthDate, to: Date()).day ?? 0
        
        if days == 0 {
            return "Born today! 🎉"
        } else if days == 1 {
            return "1 day old"
        } else if days < 7 {
            return "\(days) days old"
        } else if days < 30 {
            let weeks = days / 7
            return "\(weeks) week\(weeks == 1 ? "" : "s") old"
        } else {
            let months = Calendar.current.dateComponents([.month], from: birthDate, to: Date()).month ?? 0
            return "\(months) month\(months == 1 ? "" : "s") old"
        }
    }
    
    // MARK: - Actions
    
    private func saveProfile() {
        guard !babyName.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty else {
            showError = true
            return
        }
        
        let profile = BabyProfile(
            name: babyName.trimmingCharacters(in: .whitespacesAndNewlines),
            birthDate: birthDate
        )
        
        // Save photo if selected
        var updatedProfile = profile
        if let profileImage = profileImage {
            if let photoFilename = PhotoManager.shared.savePhoto(profileImage, for: profile.id) {
                updatedProfile.photoURL = photoFilename
            }
        }
        
        // Save to DataManager
        DataManager.shared.saveBabyProfile(updatedProfile)
        
        // Update onboarding state
        var state = OnboardingState.load()
        state.hasCreatedBabyProfile = true
        state.save()
        
        // Notify completion
        onComplete?(updatedProfile)
        
        // Dismiss the sheet
        dismiss()
    }
}

// MARK: - Preview

#Preview {
    CreateBabyProfileView()
}
