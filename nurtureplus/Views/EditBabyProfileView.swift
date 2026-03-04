//
//  EditBabyProfileView.swift
//  nurtureplus
//
//  Created on 2026-03-03.
//

import SwiftUI
import PhotosUI

/// View for editing an existing baby profile
struct EditBabyProfileView: View {
    
    @Environment(\.dismiss) private var dismiss
    @ObservedObject var viewModel: ProfileViewModel
    
    // Photo picker
    @State private var selectedPhoto: PhotosPickerItem?
    @State private var profileImage: PlatformImage?
    @State private var photoFilename: String?
    
    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(spacing: NurtureSpacing.xl) {
                    // Avatar
                    avatarSection
                    
                    // Form fields
                    formSection
                }
                .padding(NurtureSpacing.xl)
            }
            .background(NurtureColors.background)
            .navigationTitle("Edit Profile")
            #if os(iOS)
            .navigationBarTitleDisplayMode(.inline)
            #endif
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("Cancel") {
                        viewModel.cancelEditing()
                        dismiss()
                    }
                    .foregroundColor(NurtureColors.textSecondary)
                }
                
                ToolbarItem(placement: .confirmationAction) {
                    Button("Save") {
                        saveChanges()
                    }
                    .foregroundColor(NurtureColors.primary)
                    .fontWeight(.semibold)
                    .disabled(viewModel.editName.isEmpty)
                }
            }
            .onAppear {
                // Load existing photo
                photoFilename = viewModel.babyProfile?.photoURL
                if let filename = photoFilename {
                    profileImage = PhotoManager.shared.loadPhoto(filename: filename)
                }
            }
        }
    }
    
    // MARK: - Sections
    
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
                    } else {
                        Text(String(viewModel.editName.prefix(1).uppercased()))
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
                Text("Name")
                    .font(.system(size: 17, weight: .semibold))
                    .foregroundColor(NurtureColors.textPrimary)
                
                TextField("Baby's name", text: $viewModel.editName)
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
                    selection: $viewModel.editBirthDate,
                    in: ...Date(),
                    displayedComponents: .date
                )
                .datePickerStyle(.compact)
                .labelsHidden()
                .tint(NurtureColors.primary)
            }
        }
    }
    
    // MARK: - Actions
    
    private func saveChanges() {
        // Save photo if changed
        if let profileImage = profileImage, selectedPhoto != nil {
            if let profileId = viewModel.babyProfile?.id {
                // Delete old photo if exists
                if let oldPhoto = viewModel.babyProfile?.photoURL {
                    PhotoManager.shared.deletePhoto(filename: oldPhoto)
                }
                
                // Save new photo
                if let newFilename = PhotoManager.shared.savePhoto(profileImage, for: profileId) {
                    photoFilename = newFilename
                }
            }
        }
        
        // Update profile with new photo URL
        viewModel.editPhotoURL = photoFilename
        viewModel.saveChanges()
        dismiss()
    }
}

// MARK: - Preview

#Preview {
    EditBabyProfileView(viewModel: ProfileViewModel())
}
