//
//  HomeKitManager.swift
//  FrameHub
//
//  Created by Peter Conijn on 21/11/2025.
//

import Foundation
import HomeKit
import Combine

/// Manages HomeKit home and accessory discovery and control
class HomeKitManager: NSObject, ObservableObject {
    // MARK: - Published Properties

    @Published var homes: [HMHome] = []
    @Published var primaryHome: HMHome?
    @Published var accessories: [HMAccessory] = []
    @Published var isAuthorized: Bool = false
    @Published var authorizationStatus: HMHomeManagerAuthorizationStatus = .determined

    // MARK: - Private Properties

    private var homeManager: HMHomeManager?
    private var cancellables = Set<AnyCancellable>()

    // MARK: - Initialization

    override init() {
        super.init()
        setupHomeManager()
    }

    // MARK: - Setup

    private func setupHomeManager() {
        homeManager = HMHomeManager()
        homeManager?.delegate = self

        // Authorization status will be updated in delegate methods
    }

    // MARK: - Public Methods

    /// Request HomeKit authorization
    func requestAuthorization() {
        // HomeKit authorization happens automatically when HMHomeManager is initialized
        // The delegate will be notified of the authorization status
        print("[HomeKitManager] Authorization requested")
    }

    /// Discover all accessories in the primary home
    func discoverAccessories() {
        guard let primaryHome = primaryHome else {
            print("[HomeKitManager] No primary home available")
            return
        }

        accessories = primaryHome.accessories
        print("[HomeKitManager] Discovered \(accessories.count) accessories")
    }

    /// Get accessories of a specific category
    func accessories(for category: HMAccessoryCategory) -> [HMAccessory] {
        return accessories.filter { $0.category.categoryType == category.categoryType }
    }

    /// Get all light accessories
    var lightAccessories: [HMAccessory] {
        return accessories.filter { accessory in
            accessory.services.contains { service in
                service.serviceType == HMServiceTypeLightbulb
            }
        }
    }

    /// Get all thermostat accessories
    var thermostatAccessories: [HMAccessory] {
        return accessories.filter { accessory in
            accessory.services.contains { service in
                service.serviceType == HMServiceTypeThermostat
            }
        }
    }

    /// Get all lock accessories
    var lockAccessories: [HMAccessory] {
        return accessories.filter { accessory in
            accessory.services.contains { service in
                service.serviceType == HMServiceTypeLockMechanism
            }
        }
    }

    /// Get all camera accessories
    var cameraAccessories: [HMAccessory] {
        return accessories.filter { accessory in
            accessory.cameraProfiles?.isEmpty == false
        }
    }
}

// MARK: - HMHomeManagerDelegate

extension HomeKitManager: HMHomeManagerDelegate {
    func homeManagerDidUpdateHomes(_ manager: HMHomeManager) {
        DispatchQueue.main.async {
            self.homes = manager.homes
            self.primaryHome = manager.primaryHome

            if let primaryHome = self.primaryHome {
                print("[HomeKitManager] Primary home: \(primaryHome.name)")
                self.discoverAccessories()
            }
        }
    }

    func homeManager(_ manager: HMHomeManager, didAdd home: HMHome) {
        DispatchQueue.main.async {
            self.homes = manager.homes
            print("[HomeKitManager] Home added: \(home.name)")
        }
    }

    func homeManager(_ manager: HMHomeManager, didRemove home: HMHome) {
        DispatchQueue.main.async {
            self.homes = manager.homes
            print("[HomeKitManager] Home removed: \(home.name)")
        }
    }

    func homeManagerDidUpdateAuthorizationStatus(_ manager: HMHomeManager) {
        DispatchQueue.main.async {
            self.authorizationStatus = manager.authorizationStatus
            self.isAuthorized = manager.authorizationStatus == .authorized

            switch manager.authorizationStatus {
            case .determined:
                print("[HomeKitManager] Authorization: Determined")
            case .restricted:
                print("[HomeKitManager] Authorization: Restricted")
            case .authorized:
                print("[HomeKitManager] Authorization: Authorized ✅")
            default:
                print("[HomeKitManager] Authorization: Unknown status")
            }
        }
    }
}

// MARK: - HomeKit Category Extensions

extension HMAccessoryCategory {
    var displayName: String {
        switch categoryType {
        case HMAccessoryCategoryTypeLightbulb: return "Lights"
        case HMAccessoryCategoryTypeThermostat: return "Thermostats"
        case HMAccessoryCategoryTypeDoorLock: return "Locks"
        case HMAccessoryCategoryTypeSecuritySystem: return "Security"
        case HMAccessoryCategoryTypeIPCamera: return "Cameras"
        case HMAccessoryCategoryTypeSwitch: return "Switches"
        case HMAccessoryCategoryTypeOutlet: return "Outlets"
        case HMAccessoryCategoryTypeFan: return "Fans"
        case HMAccessoryCategoryTypeWindowCovering: return "Window Coverings"
        case HMAccessoryCategoryTypeGarageDoorOpener: return "Garage Doors"
        case HMAccessoryCategoryTypeSensor: return "Sensors"
        default: return "Other"
        }
    }
}
