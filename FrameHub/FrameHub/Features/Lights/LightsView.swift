//
//  LightsView.swift
//  FrameHub
//
//  Created by Peter Conijn on 21/11/2025.
//

import SwiftUI

struct LightsView: View {
    @StateObject private var viewModel: LightsViewModel
    @Environment(\.dismiss) var dismiss

    init(homeKitManager: HomeKitManager) {
        _viewModel = StateObject(wrappedValue: LightsViewModel(homeKitManager: homeKitManager))
    }

    var body: some View {
        ScrollView {
            VStack(spacing: AppTheme.Spacing.lg) {
                // Header with quick actions
                headerView

                // Error message if any
                if let error = viewModel.errorMessage {
                    errorBanner(error)
                }

                // Lights grouped by room
                if viewModel.lights.isEmpty {
                    emptyStateView
                } else {
                    lightsListView
                }
            }
            .padding()
        }
        .gradientBackground()
        .navigationTitle("Lights")
        .navigationBarTitleDisplayMode(.large)
        .toolbar {
            ToolbarItem(placement: .navigationBarTrailing) {
                Button(action: { viewModel.loadLights() }) {
                    Image(systemName: "arrow.clockwise")
                }
            }
        }
    }

    // MARK: - Header

    private var headerView: some View {
        HStack(spacing: AppTheme.Spacing.md) {
            Button(action: { viewModel.allLightsOn() }) {
                Label("All On", systemImage: "lightbulb.fill")
                    .frame(maxWidth: .infinity)
                    .padding()
                    .background(AppTheme.Colors.success)
                    .foregroundColor(.white)
                    .cornerRadius(AppTheme.CornerRadius.medium)
            }

            Button(action: { viewModel.allLightsOff() }) {
                Label("All Off", systemImage: "lightbulb.slash")
                    .frame(maxWidth: .infinity)
                    .padding()
                    .background(AppTheme.Colors.error)
                    .foregroundColor(.white)
                    .cornerRadius(AppTheme.CornerRadius.medium)
            }
        }
        .buttonStyle(.plain)
    }

    // MARK: - Error Banner

    private func errorBanner(_ message: String) -> some View {
        HStack {
            Image(systemName: "exclamationmark.triangle.fill")
                .foregroundColor(.white)
            Text(message)
                .foregroundColor(.white)
                .font(AppTheme.Typography.caption)
            Spacer()
            Button(action: { viewModel.clearError() }) {
                Image(systemName: "xmark")
                    .foregroundColor(.white)
            }
        }
        .padding()
        .background(AppTheme.Colors.error)
        .cornerRadius(AppTheme.CornerRadius.medium)
    }

    // MARK: - Lights List

    private var lightsListView: some View {
        ForEach(viewModel.rooms, id: \.self) { room in
            if let lights = viewModel.groupedLights[room], !lights.isEmpty {
                VStack(alignment: .leading, spacing: AppTheme.Spacing.md) {
                    // Room header
                    HStack {
                        Text(room)
                            .font(AppTheme.Typography.title2)
                        Spacer()
                        Text("\(lights.count) light\(lights.count == 1 ? "" : "s")")
                            .font(AppTheme.Typography.caption)
                            .foregroundColor(AppTheme.Colors.secondaryText)
                    }
                    .padding(.horizontal)

                    // Lights in this room
                    ForEach(lights) { light in
                        LightCard(light: light, viewModel: viewModel)
                    }
                }
            }
        }
    }

    // MARK: - Empty State

    private var emptyStateView: some View {
        VStack(spacing: AppTheme.Spacing.lg) {
            Image(systemName: "lightbulb.slash")
                .font(.system(size: 60))
                .foregroundColor(AppTheme.Colors.tertiaryText)

            Text("No Lights Found")
                .font(AppTheme.Typography.title2)

            Text("Add lights in the Home app to control them here")
                .font(AppTheme.Typography.body)
                .foregroundColor(AppTheme.Colors.secondaryText)
                .multilineTextAlignment(.center)

            Button(action: { viewModel.loadLights() }) {
                Label("Refresh", systemImage: "arrow.clockwise")
                    .padding()
                    .background(AppTheme.Colors.primary)
                    .foregroundColor(.white)
                    .cornerRadius(AppTheme.CornerRadius.medium)
            }
        }
        .padding()
        .cardStyle()
    }
}

// MARK: - Light Card

struct LightCard: View {
    let light: LightDevice
    @ObservedObject var viewModel: LightsViewModel
    @State private var showingDetail = false

    var body: some View {
        VStack(spacing: AppTheme.Spacing.md) {
            // Top row: Name and toggle
            HStack {
                VStack(alignment: .leading, spacing: 4) {
                    Text(light.name)
                        .font(AppTheme.Typography.headline)

                    Text(light.isOn ? "On" : "Off")
                        .font(AppTheme.Typography.caption)
                        .foregroundColor(light.isOn ? AppTheme.Colors.success : AppTheme.Colors.secondaryText)
                }

                Spacer()

                Toggle("", isOn: Binding(
                    get: { light.isOn },
                    set: { _ in viewModel.toggleLight(light) }
                ))
                .labelsHidden()
                .tint(AppTheme.Colors.primary)
            }

            // Brightness slider (if on)
            if light.isOn {
                VStack(alignment: .leading, spacing: 4) {
                    HStack {
                        Image(systemName: "sun.min")
                            .foregroundColor(AppTheme.Colors.secondaryText)
                        Slider(
                            value: Binding(
                                get: { Double(light.brightness) },
                                set: { viewModel.setBrightness(light, brightness: Int($0)) }
                            ),
                            in: 0...100,
                            step: 1
                        )
                        Image(systemName: "sun.max.fill")
                            .foregroundColor(AppTheme.Colors.primary)
                        Text("\(light.brightness)%")
                            .font(AppTheme.Typography.caption)
                            .foregroundColor(AppTheme.Colors.secondaryText)
                            .frame(width: 50, alignment: .trailing)
                    }
                }

                // Color indicator (if supports color)
                if light.supportsColor, let hue = light.hue, let saturation = light.saturation {
                    HStack {
                        Image(systemName: "paintpalette")
                            .foregroundColor(AppTheme.Colors.secondaryText)

                        Button(action: { showingDetail = true }) {
                            HStack {
                                Circle()
                                    .fill(Color(hue: Double(hue) / 360.0, saturation: Double(saturation) / 100.0, brightness: 1.0))
                                    .frame(width: 30, height: 30)

                                Text("Change Color")
                                    .font(AppTheme.Typography.caption)
                            }
                        }
                        .buttonStyle(.plain)

                        Spacer()
                    }
                }
            }
        }
        .padding()
        .cardStyle()
        .sheet(isPresented: $showingDetail) {
            LightDetailView(light: light, viewModel: viewModel)
        }
    }
}

// MARK: - Light Detail View (Color Picker)

struct LightDetailView: View {
    let light: LightDevice
    @ObservedObject var viewModel: LightsViewModel
    @Environment(\.dismiss) var dismiss
    @State private var selectedHue: Double
    @State private var selectedSaturation: Double

    init(light: LightDevice, viewModel: LightsViewModel) {
        self.light = light
        self.viewModel = viewModel
        _selectedHue = State(initialValue: Double(light.hue ?? 0))
        _selectedSaturation = State(initialValue: Double(light.saturation ?? 100))
    }

    var body: some View {
        NavigationView {
            VStack(spacing: AppTheme.Spacing.xl) {
                // Preview circle
                Circle()
                    .fill(Color(hue: selectedHue / 360.0, saturation: selectedSaturation / 100.0, brightness: 1.0))
                    .frame(width: 200, height: 200)
                    .shadow(radius: 20)

                // Hue slider
                VStack(alignment: .leading) {
                    Text("Hue: \(Int(selectedHue))°")
                        .font(AppTheme.Typography.headline)

                    Slider(value: $selectedHue, in: 0...360, step: 1)
                }
                .padding(.horizontal)

                // Saturation slider
                VStack(alignment: .leading) {
                    Text("Saturation: \(Int(selectedSaturation))%")
                        .font(AppTheme.Typography.headline)

                    Slider(value: $selectedSaturation, in: 0...100, step: 1)
                }
                .padding(.horizontal)

                // Apply button
                Button(action: {
                    viewModel.setColor(light, hue: Int(selectedHue), saturation: Int(selectedSaturation))
                    dismiss()
                }) {
                    Text("Apply Color")
                        .font(AppTheme.Typography.headline)
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(AppTheme.Colors.primary)
                        .foregroundColor(.white)
                        .cornerRadius(AppTheme.CornerRadius.medium)
                }
                .padding(.horizontal)

                Spacer()
            }
            .padding()
            .navigationTitle(light.name)
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("Done") { dismiss() }
                }
            }
        }
    }
}

// MARK: - Preview

#Preview {
    NavigationView {
        LightsView(homeKitManager: HomeKitManager())
    }
}
