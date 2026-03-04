//
//  AppRouter.swift
//  nurtureplus
//
//  Created by Manali Maruti Pat on 3/3/26.
//

import SwiftUI
import Combine

/// Navigation router for managing app navigation
@MainActor
final class AppRouter: ObservableObject {
    
    // MARK: - Published Properties
    
    /// Currently selected tab
    @Published var selectedTab: AppTab = .home
    
    /// Navigation path for NavigationStack
    @Published var path: NavigationPath = NavigationPath()
    
    // MARK: - Singleton
    
    static let shared = AppRouter()
    
    // MARK: - Initialization
    
    private init() {}
    
    // MARK: - Navigation Methods
    
    /// Navigate to a specific route
    func navigate(to route: AppRoute) {
        path.append(route)
    }
    
    /// Pop back to root
    func popToRoot() {
        path.removeLast(path.count)
    }
    
    /// Switch to a specific tab
    func switchTab(to tab: AppTab) {
        selectedTab = tab
    }
    
    /// Reset navigation state
    func reset() {
        selectedTab = .home
        path = NavigationPath()
    }
}

// MARK: - App Tab Enumeration

enum AppTab: String, CaseIterable {
    case home
    case tracking
    case resources
    case profile
    
    var title: String {
        switch self {
        case .home:
            return "Home"
        case .tracking:
            return "Tracking"
        case .resources:
            return "Resources"
        case .profile:
            return "Profile"
        }
    }
    
    var icon: String {
        switch self {
        case .home:
            return "house.fill"
        case .tracking:
            return "chart.line.uptrend.xyaxis"
        case .resources:
            return "book.fill"
        case .profile:
            return "person.fill"
        }
    }
}

// MARK: - App Route Enumeration

enum AppRoute: Hashable {
    case placeholder
    // Add more routes as needed
}
