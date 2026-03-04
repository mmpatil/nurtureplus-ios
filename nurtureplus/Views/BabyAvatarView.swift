//
//  BabyAvatarView.swift
//  nurtureplus
//
//  Created on 2026-03-03.
//

import SwiftUI

/// Reusable baby avatar view that shows photo or initial
struct BabyAvatarView: View {
    
    let name: String
    let photoFilename: String?
    let size: CGFloat
    
    @State private var profileImage: NSImage?
    
    init(name: String, photoFilename: String? = nil, size: CGFloat = 100) {
        self.name = name
        self.photoFilename = photoFilename
        self.size = size
    }
    
    var body: some View {
        Circle()
            .fill(
                LinearGradient(
                    colors: [NurtureColors.primary, NurtureColors.primaryLight],
                    startPoint: .topLeading,
                    endPoint: .bottomTrailing
                )
            )
            .frame(width: size, height: size)
            .overlay {
                if let profileImage = profileImage {
                    Image(nsImage: profileImage)
                        .resizable()
                        .scaledToFill()
                        .frame(width: size, height: size)
                        .clipShape(Circle())
                } else {
                    Text(String(name.prefix(1).uppercased()))
                        .font(.system(size: size * 0.4, weight: .bold))
                        .foregroundColor(.white)
                }
            }
            .shadow(color: NurtureColors.shadow, radius: 12, y: 4)
            .onAppear {
                loadPhoto()
            }
            .onChange(of: photoFilename) { _, _ in
                loadPhoto()
            }
    }
    
    private func loadPhoto() {
        guard let filename = photoFilename else {
            profileImage = nil
            return
        }
        
        profileImage = PhotoManager.shared.loadPhoto(filename: filename)
    }
}

// MARK: - Preview

#Preview {
    VStack(spacing: 20) {
        BabyAvatarView(name: "Emma", size: 100)
        BabyAvatarView(name: "Oliver", photoFilename: nil, size: 80)
    }
    .padding()
    .background(NurtureColors.background)
}
