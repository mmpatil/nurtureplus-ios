//
//  NurtureColors.swift
//  nurtureplus
//
//  Created on 2026-03-03.
//

import SwiftUI

/// Color palette for Nurture+ - designed for a calm, supportive wellness experience
struct NurtureColors {
    
    // MARK: - Primary Colors
    
    /// Soft sage green - primary brand color
    static let primary = Color(red: 0.65, green: 0.75, blue: 0.68)
    
    /// Deeper sage for active states
    static let primaryDark = Color(red: 0.55, green: 0.65, blue: 0.58)
    
    /// Very light sage for backgrounds
    static let primaryLight = Color(red: 0.93, green: 0.96, blue: 0.94)
    
    // MARK: - Neutral Colors
    
    /// Main text color - warm dark gray
    static let textPrimary = Color(red: 0.2, green: 0.2, blue: 0.22)
    
    /// Secondary text - softer gray
    static let textSecondary = Color(red: 0.5, green: 0.5, blue: 0.52)
    
    /// Subtle text - light gray
    static let textTertiary = Color(red: 0.7, green: 0.7, blue: 0.72)
    
    // MARK: - Background Colors
    
    /// Main background - off-white with warmth
    static let background = Color(red: 0.98, green: 0.98, blue: 0.97)
    
    /// Card background - pure white
    static let cardBackground = Color.white
    
    /// Secondary background - very light warm gray
    static let backgroundSecondary = Color(red: 0.96, green: 0.96, blue: 0.95)
    
    // MARK: - Accent Colors
    
    /// Soft peach for warmth and highlights
    static let accent = Color(red: 0.98, green: 0.85, blue: 0.78)
    
    /// Soft lavender for calm
    static let accentSecondary = Color(red: 0.85, green: 0.82, blue: 0.92)
    
    // MARK: - Status Colors
    
    /// Success state - gentle green
    static let success = Color(red: 0.6, green: 0.8, blue: 0.7)
    
    /// Warning state - soft amber
    static let warning = Color(red: 0.95, green: 0.8, blue: 0.6)
    
    /// Error state - muted coral
    static let error = Color(red: 0.92, green: 0.65, blue: 0.65)
    
    // MARK: - Utility
    
    /// Divider lines
    static let divider = Color(red: 0.9, green: 0.9, blue: 0.9)
    
    /// Shadow color
    static let shadow = Color.black.opacity(0.08)
    
    private init() {}
}
