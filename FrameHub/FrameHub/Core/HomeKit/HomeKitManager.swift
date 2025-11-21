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

    // MARK: - Device Categorization

    /// Categorize an accessory
    func categorize(_ accessory: HMAccessory) -> DeviceCategory {
        // Check for lights
        if accessory.services.contains(where: { $0.serviceType == HMServiceTypeLightbulb }) {
            return .lights
        }

        // Check for thermostats
        if accessory.services.contains(where: { $0.serviceType == HMServiceTypeThermostat }) {
            return .thermostats
        }

        // Check for locks
        if accessory.services.contains(where: { $0.serviceType == HMServiceTypeLockMechanism }) {
            return .locks
        }

        // Check for cameras
        if accessory.cameraProfiles?.isEmpty == false {
            return .cameras
        }

        // Check for switches
        if accessory.services.contains(where: { $0.serviceType == HMServiceTypeSwitch }) {
            return .switches
        }

        // Check for outlets
        if accessory.services.contains(where: { $0.serviceType == HMServiceTypeOutlet }) {
            return .outlets
        }

        // Check for fans
        if accessory.services.contains(where: { $0.serviceType == HMServiceTypeFan }) {
            return .fans
        }

        // Check for window coverings
        if accessory.services.contains(where: { $0.serviceType == HMServiceTypeWindowCovering || $0.serviceType == HMServiceTypeWindow }) {
            return .windowCoverings
        }

        // Check for garage doors
        if accessory.services.contains(where: { $0.serviceType == HMServiceTypeGarageDoorOpener }) {
            return .garageDoors
        }

        // Check for sensors
        if accessory.services.contains(where: {
            $0.serviceType == HMServiceTypeMotionSensor ||
            $0.serviceType == HMServiceTypeTemperatureSensor ||
            $0.serviceType == HMServiceTypeHumiditySensor ||
            $0.serviceType == HMServiceTypeContactSensor ||
            $0.serviceType == HMServiceTypeLeakSensor ||
            $0.serviceType == HMServiceTypeSmokeSensor ||
            $0.serviceType == HMServiceTypeCarbonMonoxideSensor ||
            $0.serviceType == HMServiceTypeCarbonDioxideSensor
        }) {
            return .sensors
        }

        return .other
    }

    /// Get all devices grouped by category
    func getDeviceGroups() -> [DeviceGroup] {
        var groups: [DeviceCategory: [GenericDevice]] = [:]

        for accessory in accessories {
            let category = categorize(accessory)
            let device = GenericDevice(
                id: UUID(uuidString: accessory.uniqueIdentifier.uuidString) ?? UUID(),
                name: accessory.name,
                accessory: accessory,
                category: category,
                roomName: accessory.room?.name
            )

            if groups[category] == nil {
                groups[category] = []
            }
            groups[category]?.append(device)
        }

        return groups.map { category, devices in
            DeviceGroup(category: category, devices: devices)
        }.sorted { $0.category.displayName < $1.category.displayName }
    }

    /// Get device count by category
    func deviceCount(for category: DeviceCategory) -> Int {
        return accessories.filter { categorize($0) == category }.count
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
