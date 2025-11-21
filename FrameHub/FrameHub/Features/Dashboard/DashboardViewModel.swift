//
//  DashboardViewModel.swift
//  FrameHub
//
//  Created by Peter Conijn on 21/11/2025.
//

import Foundation
import SwiftUI
import Combine
import HomeKit

class DashboardViewModel: ObservableObject, BaseViewModel {
    // MARK: - Published Properties

    @Published var isLoading: Bool = false
    @Published var errorMessage: String?
    @Published var deviceGroups: [DeviceGroup] = []
    @Published var isHomeKitConnected: Bool = false
    @Published var isMusicPlaying: Bool = false
    @Published var homeName: String = "My Home"

    // MARK: - Quick Stats

    @Published var totalDevices: Int = 0
    @Published var activeLights: Int = 0
    @Published var currentTemperature: String = "--°"
    @Published var locksSecured: Int = 0

    // MARK: - Private Properties

    private let homeKitManager: HomeKitManager
    private let musicManager: MusicManager
    private var cancellables = Set<AnyCancellable>()

    // MARK: - Initialization

    init(homeKitManager: HomeKitManager, musicManager: MusicManager) {
        self.homeKitManager = homeKitManager
        self.musicManager = musicManager
        setupObservers()
        refreshData()
    }

    // MARK: - Setup

    private func setupObservers() {
        // HomeKit authorization
        homeKitManager.$isAuthorized
            .receive(on: DispatchQueue.main)
            .assign(to: &$isHomeKitConnected)

        // Home name
        homeKitManager.$primaryHome
            .compactMap { $0?.name }
            .receive(on: DispatchQueue.main)
            .assign(to: &$homeName)

        // Total devices
        homeKitManager.$accessories
            .map { $0.count }
            .receive(on: DispatchQueue.main)
            .assign(to: &$totalDevices)

        // Music playback
        musicManager.$playbackState
            .map { $0 == .playing }
            .receive(on: DispatchQueue.main)
            .assign(to: &$isMusicPlaying)
    }

    // MARK: - Public Methods

    func refreshData() {
        print("[DashboardViewModel] Refreshing dashboard data")
        isLoading = true

        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) { [weak self] in
            guard let self = self else { return }

            self.deviceGroups = self.homeKitManager.getDeviceGroups()
            self.updateQuickStats()
            self.isLoading = false

            print("[DashboardViewModel] Dashboard refreshed")
        }
    }

    private func updateQuickStats() {
        // Count active lights (simplified - would need to read actual states)
        activeLights = homeKitManager.lightAccessories.count

        // Count secured locks
        locksSecured = homeKitManager.lockAccessories.count

        // Get temperature from first thermostat (simplified)
        if let firstThermostat = homeKitManager.thermostatAccessories.first {
            // Would need to read actual characteristic value
            currentTemperature = "21°"
        }
    }

    func quickAction(for category: DeviceCategory) {
        print("[DashboardViewModel] Quick action for \(category.displayName)")
        // Will implement specific actions in phase for each device type
    }
}
