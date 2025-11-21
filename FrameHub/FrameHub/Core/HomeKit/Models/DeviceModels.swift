//
//  DeviceModels.swift
//  FrameHub
//
//  Created by Peter Conijn on 21/11/2025.
//

import Foundation
import HomeKit

// MARK: - Device Category

enum DeviceCategory: String, CaseIterable {
    case lights
    case thermostats
    case locks
    case cameras
    case switches
    case outlets
    case fans
    case windowCoverings
    case garageDoors
    case sensors
    case other

    var displayName: String {
        switch self {
        case .lights: return "Lights"
        case .thermostats: return "Thermostats"
        case .locks: return "Locks"
        case .cameras: return "Cameras"
        case .switches: return "Switches"
        case .outlets: return "Outlets"
        case .fans: return "Fans"
        case .windowCoverings: return "Window Coverings"
        case .garageDoors: return "Garage Doors"
        case .sensors: return "Sensors"
        case .other: return "Other"
        }
    }

    var iconName: String {
        switch self {
        case .lights: return "lightbulb.fill"
        case .thermostats: return "thermometer"
        case .locks: return "lock.fill"
        case .cameras: return "video.fill"
        case .switches: return "switch.2"
        case .outlets: return "powerplug.fill"
        case .fans: return "fan.fill"
        case .windowCoverings: return "blinds.vertical.closed"
        case .garageDoors: return "garage"
        case .sensors: return "sensor.fill"
        case .other: return "questionmark.circle"
        }
    }
}

// MARK: - Light Device

struct LightDevice: Identifiable {
    let id: UUID
    let name: String
    let accessory: HMAccessory
    let service: HMService
    var isOn: Bool
    var brightness: Int // 0-100
    var hue: Int? // 0-360 (if color supported)
    var saturation: Int? // 0-100 (if color supported)
    var colorTemperature: Int? // Kelvin (if tunable white)

    var supportsColor: Bool {
        service.characteristics.contains { $0.characteristicType == HMCharacteristicTypeHue }
    }

    var supportsColorTemperature: Bool {
        service.characteristics.contains { $0.characteristicType == HMCharacteristicTypeColorTemperature }
    }
}

// MARK: - Thermostat Device

struct ThermostatDevice: Identifiable {
    let id: UUID
    let name: String
    let accessory: HMAccessory
    let service: HMService
    var currentTemperature: Double
    var targetTemperature: Double
    var currentHeatingCoolingState: HeatingCoolingState
    var targetHeatingCoolingState: HeatingCoolingState
    var temperatureUnit: TemperatureUnit

    enum HeatingCoolingState: Int {
        case off = 0
        case heat = 1
        case cool = 2
        case auto = 3

        var displayName: String {
            switch self {
            case .off: return "Off"
            case .heat: return "Heat"
            case .cool: return "Cool"
            case .auto: return "Auto"
            }
        }
    }

    enum TemperatureUnit {
        case celsius
        case fahrenheit
    }
}

// MARK: - Lock Device

struct LockDevice: Identifiable {
    let id: UUID
    let name: String
    let accessory: HMAccessory
    let service: HMService
    var currentState: LockState
    var targetState: LockState

    enum LockState: Int {
        case unsecured = 0
        case secured = 1
        case jammed = 2
        case unknown = 3

        var displayName: String {
            switch self {
            case .unsecured: return "Unlocked"
            case .secured: return "Locked"
            case .jammed: return "Jammed"
            case .unknown: return "Unknown"
            }
        }

        var iconName: String {
            switch self {
            case .unsecured: return "lock.open.fill"
            case .secured: return "lock.fill"
            case .jammed: return "exclamationmark.lock.fill"
            case .unknown: return "lock.slash.fill"
            }
        }
    }
}

// MARK: - Camera Device

struct CameraDevice: Identifiable {
    let id: UUID
    let name: String
    let accessory: HMAccessory
    let cameraProfile: HMCameraProfile?
    var isStreaming: Bool
    var snapshotURL: URL?

    var supportsStreaming: Bool {
        cameraProfile != nil
    }
}

// MARK: - Generic Device

struct GenericDevice: Identifiable {
    let id: UUID
    let name: String
    let accessory: HMAccessory
    let category: DeviceCategory
    let roomName: String?
}

// MARK: - Device Group

struct DeviceGroup {
    let category: DeviceCategory
    let devices: [GenericDevice]

    var count: Int {
        devices.count
    }
}
