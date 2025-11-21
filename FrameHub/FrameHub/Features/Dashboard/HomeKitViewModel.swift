//
//  HomeKitViewModel.swift
//  FrameHub
//
//  Created by Peter Conijn on 21/11/2025.
//

import Foundation
import SwiftUI
import HomeKit
import Combine

class HomeKitViewModel: ObservableObject, BaseViewModel {
    // MARK: - Published Properties

    @Published var isLoading: Bool = false
    @Published var errorMessage: String?
    @Published var deviceGroups: [DeviceGroup] = []
    @Published var isAuthorized: Bool = false
    @Published var homeName: String = "My Home"
    @Published var totalDeviceCount: Int = 0

    // MARK: - Private Properties

    private let homeKitManager: HomeKitManager
    private var cancellables = Set<AnyCancellable>()

    // MARK: - Initialization

    init(homeKitManager: HomeKitManager) {
        self.homeKitManager = homeKitManager
        setupObservers()
        requestAuthorization()
    }

    // MARK: - Setup

    private func setupObservers() {
        // Observe authorization status
        homeKitManager.$isAuthorized
            .receive(on: DispatchQueue.main)
            .sink { [weak self] authorized in
                self?.isAuthorized = authorized
                if authorized {
                    self?.refreshDevices()
                }
            }
            .store(in: &cancellables)

        // Observe accessories
        homeKitManager.$accessories
            .receive(on: DispatchQueue.main)
            .sink { [weak self] accessories in
                self?.totalDeviceCount = accessories.count
                self?.refreshDevices()
            }
            .store(in: &cancellables)

        // Observe primary home
        homeKitManager.$primaryHome
            .compactMap { $0?.name }
            .receive(on: DispatchQueue.main)
            .assign(to: &$homeName)
    }

    // MARK: - Public Methods

    func requestAuthorization() {
        print("[HomeKitViewModel] Requesting HomeKit authorization")
        isLoading = true
        homeKitManager.requestAuthorization()

        // Wait a bit for authorization to complete
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) { [weak self] in
            self?.isLoading = false
        }
    }

    func refreshDevices() {
        print("[HomeKitViewModel] Refreshing devices")
        isLoading = true

        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) { [weak self] in
            guard let self = self else { return }
            self.deviceGroups = self.homeKitManager.getDeviceGroups()
            self.isLoading = false
            print("[HomeKitViewModel] Found \(self.deviceGroups.count) device categories")
        }
    }

    func deviceCount(for category: DeviceCategory) -> Int {
        return homeKitManager.deviceCount(for: category)
    }

    // MARK: - Helper Methods

    var authorizationStatusMessage: String {
        if isAuthorized {
            return "HomeKit Connected"
        } else {
            switch homeKitManager.authorizationStatus {
            case .restricted:
                return "HomeKit Restricted"
            case .determined:
                return "HomeKit Access Required"
            case .authorized:
                return "HomeKit Authorized"
            default:
                return "HomeKit Status Unknown"
            }
        }
    }

    var hasDevices: Bool {
        return totalDeviceCount > 0
    }
}
