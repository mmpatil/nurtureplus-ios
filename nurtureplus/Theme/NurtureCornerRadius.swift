//
//  NurtureCornerRadius.swift
//  nurtureplus
//
//  Created by Manali Maruti Pat on 3/3/26.
//

import CoreGraphics

/// Corner radius values for consistent UI elements
struct NurtureCornerRadius {
    
    /// 8pt - small elements
    static let sm: CGFloat = 8
    
    /// 12pt - standard cards and buttons
    static let md: CGFloat = 12
    
    /// 16pt - larger cards
    static let lg: CGFloat = 16
    
    /// 24pt - prominent elements
    static let xl: CGFloat = 24
    
    /// Full circle/pill shape
    static let full: CGFloat = 999
    
    private init() {}
}
