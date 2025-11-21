//
//  LightsViewModel.swift
//  FrameHub
//
//  Created by Peter Conijn on 21/11/2025.
//

import Foundation
import SwiftUI
import HomeKit
import Combine

class LightsViewModel: ObservableObject, BaseViewModel {
    // MARK: - Published Properties

    @Published var isLoading: Bool = false
    @Published var errorMessage: String?
    @Published var lights: [LightDevice] = []
    @Published var groupedLights: [String: [LightDevice]] = [:]
    @Published var rooms: [String] = []

    // MARK: - Private Properties

    private let homeKitManager: HomeKitManager
    private var cancellables = Set<AnyCancellable>()

    // MARK: - Initialization

    init(homeKitManager: HomeKitManager) {
        self.homeKitManager = homeKitManager
        setupObservers()
        loadLights()
    }

    // MARK: - Setup

    private func setupObservers() {
        homeKitManager.$accessories
            .receive(on: DispatchQueue.main)
            .sink { [weak self] _ in
                self?.loadLights()
            }
            .store(in: &cancellables)
    }

    // MARK: - Public Methods

    func loadLights() {
        print("[LightsViewModel] Loading lights")
        isLoading = true

        DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) { [weak self] in
            guard let self = self else { return }

            let lightAccessories = self.homeKitManager.lightAccessories
            self.lights = lightAccessories.compactMap { self.createLightDevice(from: $0) }

            // Group by room
            self.groupLightsByRoom()
            self.isLoading = false

            print("[LightsViewModel] Loaded \(self.lights.count) lights")
        }
    }

    private func createLightDevice(from accessory: HMAccessory) -> LightDevice? {
        guard let service = accessory.services.first(where: { $0.serviceType == HMServiceTypeLightbulb }) else {
            return nil
        }

        // Get current values from characteristics
        let powerChar = service.characteristics.first { $0.characteristicType == HMCharacteristicTypePowerState }
        let brightnessChar = service.characteristics.first { $0.characteristicType == HMCharacteristicTypeBrightness }
        let hueChar = service.characteristics.first { $0.characteristicType == HMCharacteristicTypeHue }
        let saturationChar = service.characteristics.first { $0.characteristicType == HMCharacteristicTypeSaturation }

        let isOn = (powerChar?.value as? Bool) ?? false
        let brightness = (brightnessChar?.value as? Int) ?? 100
        let hue = hueChar?.value as? Int
        let saturation = saturationChar?.value as? Int

        return LightDevice(
            id: UUID(uuidString: accessory.uniqueIdentifier.uuidString) ?? UUID(),
            name: accessory.name,
            accessory: accessory,
            service: service,
            isOn: isOn,
            brightness: brightness,
            hue: hue,
            saturation: saturation,
            colorTemperature: nil
        )
    }

    private func groupLightsByRoom() {
        var groups: [String: [LightDevice]] = [:]

        for light in lights {
            let roomName = light.accessory.room?.name ?? "Other"
            if groups[roomName] == nil {
                groups[roomName] = []
            }
            groups[roomName]?.append(light)
        }

        groupedLights = groups
        rooms = groups.keys.sorted()
    }

    // MARK: - Light Control

    func toggleLight(_ light: LightDevice) {
        print("[LightsViewModel] Toggling light: \(light.name)")

        guard let powerChar = light.service.characteristics.first(where: {
            $0.characteristicType == HMCharacteristicTypePowerState
        }) else {
            errorMessage = "Cannot find power characteristic"
            return
        }

        let newValue = !light.isOn

        powerChar.writeValue(newValue) { [weak self] error in
            DispatchQueue.main.async {
                if let error = error {
                    self?.errorMessage = "Failed to toggle light: \(error.localizedDescription)"
                    print("[LightsViewModel] Error: \(error.localizedDescription)")
                } else {
                    print("[LightsViewModel] Light toggled successfully")
                    self?.updateLightState(light.id, isOn: newValue)
                }
            }
        }
    }

    func setBrightness(_ light: LightDevice, brightness: Int) {
        print("[LightsViewModel] Setting brightness for \(light.name) to \(brightness)%")

        guard let brightnessChar = light.service.characteristics.first(where: {
            $0.characteristicType == HMCharacteristicTypeBrightness
        }) else {
            errorMessage = "Light doesn't support brightness"
            return
        }

        brightnessChar.writeValue(brightness) { [weak self] error in
            DispatchQueue.main.async {
                if let error = error {
                    self?.errorMessage = "Failed to set brightness: \(error.localizedDescription)"
                } else {
                    self?.updateLightBrightness(light.id, brightness: brightness)
                }
            }
        }
    }

    func setColor(_ light: LightDevice, hue: Int, saturation: Int) {
        print("[LightsViewModel] Setting color for \(light.name) - Hue: \(hue), Sat: \(saturation)")

        guard light.supportsColor else {
            errorMessage = "Light doesn't support color"
            return
        }

        let group = DispatchGroup()

        // Set hue
        if let hueChar = light.service.characteristics.first(where: { $0.characteristicType == HMCharacteristicTypeHue }) {
            group.enter()
            hueChar.writeValue(hue) { error in
                if let error = error {
                    print("[LightsViewModel] Hue error: \(error)")
                }
                group.leave()
            }
        }

        // Set saturation
        if let satChar = light.service.characteristics.first(where: { $0.characteristicType == HMCharacteristicTypeSaturation }) {
            group.enter()
            satChar.writeValue(saturation) { error in
                if let error = error {
                    print("[LightsViewModel] Saturation error: \(error)")
                }
                group.leave()
            }
        }

        group.notify(queue: .main) { [weak self] in
            self?.updateLightColor(light.id, hue: hue, saturation: saturation)
        }
    }

    func allLightsOn() {
        print("[LightsViewModel] Turning all lights on")
        for light in lights where !light.isOn {
            toggleLight(light)
        }
    }

    func allLightsOff() {
        print("[LightsViewModel] Turning all lights off")
        for light in lights where light.isOn {
            toggleLight(light)
        }
    }

    // MARK: - State Updates

    private func updateLightState(_ id: UUID, isOn: Bool) {
        if let index = lights.firstIndex(where: { $0.id == id }) {
            lights[index].isOn = isOn
            groupLightsByRoom()
        }
    }

    private func updateLightBrightness(_ id: UUID, brightness: Int) {
        if let index = lights.firstIndex(where: { $0.id == id }) {
            lights[index].brightness = brightness
            groupLightsByRoom()
        }
    }

    private func updateLightColor(_ id: UUID, hue: Int, saturation: Int) {
        if let index = lights.firstIndex(where: { $0.id == id }) {
            lights[index].hue = hue
            lights[index].saturation = saturation
            groupLightsByRoom()
        }
    }
}
