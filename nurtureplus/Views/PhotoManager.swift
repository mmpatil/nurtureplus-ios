//
//  PhotoManager.swift
//  nurtureplus
//
//  Created on 2026-03-03.
//

import SwiftUI
import PhotosUI
import Combine

#if canImport(UIKit)
import UIKit
typealias PlatformImage = UIImage
#elseif canImport(AppKit)
import AppKit
typealias PlatformImage = NSImage
#endif

/// Manages baby profile photos
@MainActor
final class PhotoManager: ObservableObject {
    
    // MARK: - Singleton
    
    static let shared = PhotoManager()
    
    private init() {}
    
    // MARK: - Photo Selection
    
    /// Load image from PhotosPickerItem
    func loadImage(from item: PhotosPickerItem) async -> PlatformImage? {
        guard let data = try? await item.loadTransferable(type: Data.self),
              let image = PlatformImage(data: data) else {
            return nil
        }
        return image
    }
    
    // MARK: - Photo Storage
    
    /// Save photo to documents directory and return file URL
    func savePhoto(_ image: PlatformImage, for profileId: String) -> String? {
        #if canImport(UIKit)
        guard let data = image.jpegData(compressionQuality: 0.8) else {
            return nil
        }
        #elseif canImport(AppKit)
        guard let cgImage = image.cgImage(forProposedRect: nil, context: nil, hints: nil) else {
            return nil
        }
        let bitmapRep = NSBitmapImageRep(cgImage: cgImage)
        guard let data = bitmapRep.representation(using: .jpeg, properties: [.compressionFactor: 0.8]) else {
            return nil
        }
        #endif
        
        let fileName = "baby_\(profileId).jpg"
        let fileURL = getDocumentsDirectory().appendingPathComponent(fileName)
        
        do {
            try data.write(to: fileURL)
            print("✅ Saved photo: \(fileName)")
            return fileURL.lastPathComponent // Return just the filename
        } catch {
            print("❌ Error saving photo: \(error)")
            return nil
        }
    }
    
    /// Load photo from documents directory
    func loadPhoto(filename: String) -> PlatformImage? {
        let fileURL = getDocumentsDirectory().appendingPathComponent(filename)
        
        guard let data = try? Data(contentsOf: fileURL),
              let image = PlatformImage(data: data) else {
            return nil
        }
        
        return image
    }
    
    /// Delete photo from documents directory
    func deletePhoto(filename: String) {
        let fileURL = getDocumentsDirectory().appendingPathComponent(filename)
        
        do {
            try FileManager.default.removeItem(at: fileURL)
            print("🗑️ Deleted photo: \(filename)")
        } catch {
            print("❌ Error deleting photo: \(error)")
        }
    }
    
    // MARK: - Helpers
    
    private func getDocumentsDirectory() -> URL {
        FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0]
    }
}
