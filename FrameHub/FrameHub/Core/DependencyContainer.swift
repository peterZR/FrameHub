//
//  DependencyContainer.swift
//  FrameHub
//
//  Created by Peter Conijn on 21/11/2025.
//

import Foundation
import SwiftUI
import Combine

/// Centralized dependency injection container
/// Provides singleton access to all major services
class DependencyContainer: ObservableObject {
    // MARK: - Singleton

    static let shared = DependencyContainer()

    // MARK: - Services

    @Published var homeKitManager: HomeKitManager
    @Published var musicManager: MusicManager

    // MARK: - Initialization

    private init() {
        // Initialize all services
        self.homeKitManager = HomeKitManager()
        self.musicManager = MusicManager()

        print("[DependencyContainer] Initialized with all services")
    }

    // MARK: - Public Methods

    /// Reset all services (useful for logout or testing)
    func reset() {
        print("[DependencyContainer] Resetting all services")
        homeKitManager = HomeKitManager()
        musicManager = MusicManager()
    }
}

// MARK: - Environment Key

/// Environment key for accessing the dependency container
private struct DependencyContainerKey: EnvironmentKey {
    static let defaultValue: DependencyContainer = .shared
}

extension EnvironmentValues {
    var dependencies: DependencyContainer {
        get { self[DependencyContainerKey.self] }
        set { self[DependencyContainerKey.self] = newValue }
    }
}

// MARK: - View Extension

extension View {
    /// Inject dependencies into the view hierarchy
    func withDependencies() -> some View {
        self.environmentObject(DependencyContainer.shared)
    }
}
