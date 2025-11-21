//
//  FrameHubApp.swift
//  FrameHub
//
//  Created by Peter Conijn on 21/11/2025.
//

import SwiftUI

@main
struct FrameHubApp: App {
    // MARK: - Dependencies

    @StateObject private var dependencies = DependencyContainer.shared

    // MARK: - Body

    var body: some Scene {
        WindowGroup {
            ContentView()
                .environmentObject(dependencies)
                .environmentObject(dependencies.homeKitManager)
                .environmentObject(dependencies.musicManager)
        }
    }
}
