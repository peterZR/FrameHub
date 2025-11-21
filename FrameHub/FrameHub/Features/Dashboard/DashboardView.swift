//
//  DashboardView.swift
//  FrameHub
//
//  Created by Peter Conijn on 21/11/2025.
//

import SwiftUI

struct DashboardView: View {
    @StateObject private var viewModel: DashboardViewModel
    @EnvironmentObject var homeKitManager: HomeKitManager
    @Environment(\.horizontalSizeClass) var horizontalSizeClass
    @Environment(\.verticalSizeClass) var verticalSizeClass

    init(homeKitManager: HomeKitManager, musicManager: MusicManager) {
        _viewModel = StateObject(wrappedValue: DashboardViewModel(
            homeKitManager: homeKitManager,
            musicManager: musicManager
        ))
    }

    // Adaptive columns based on orientation
    private var gridColumns: [GridItem] {
        if horizontalSizeClass == .regular && verticalSizeClass == .regular {
            // iPad landscape
            return Array(repeating: GridItem(.flexible(), spacing: AppTheme.Spacing.md), count: 4)
        } else {
            // iPad portrait or other
            return Array(repeating: GridItem(.flexible(), spacing: AppTheme.Spacing.md), count: 2)
        }
    }

    var body: some View {
        NavigationView {
            ScrollView {
                VStack(spacing: AppTheme.Spacing.lg) {
                    // Welcome Header
                    headerView

                    // Quick Stats
                    quickStatsView

                    // Device Categories Grid
                    deviceCategoriesView

                    // Quick Actions Footer
                    quickActionsView
                }
                .padding()
            }
            .gradientBackground()
            .navigationTitle(viewModel.homeName)
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button(action: { viewModel.refreshData() }) {
                        Image(systemName: "arrow.clockwise")
                    }
                }
            }
        }
        .navigationViewStyle(.stack)
    }

    // MARK: - Header

    private var headerView: some View {
        HStack {
            VStack(alignment: .leading, spacing: AppTheme.Spacing.sm) {
                Text("Welcome to")
                    .font(AppTheme.Typography.callout)
                    .foregroundColor(AppTheme.Colors.secondaryText)

                Text("FrameHub")
                    .font(AppTheme.Typography.largeTitle)

                HStack(spacing: AppTheme.Spacing.sm) {
                    Circle()
                        .fill(viewModel.isHomeKitConnected ? AppTheme.Colors.success : AppTheme.Colors.error)
                        .frame(width: 8, height: 8)

                    Text(viewModel.isHomeKitConnected ? "Connected" : "Disconnected")
                        .font(AppTheme.Typography.caption)
                        .foregroundColor(AppTheme.Colors.secondaryText)
                }
            }

            Spacer()

            Image(systemName: AppTheme.Icons.home)
                .font(.system(size: 50))
                .foregroundColor(AppTheme.Colors.primary)
        }
        .padding()
        .cardStyle()
    }

    // MARK: - Quick Stats

    private var quickStatsView: some View {
        HStack(spacing: AppTheme.Spacing.md) {
            QuickStatCard(
                icon: "lightbulb.fill",
                label: "Lights",
                value: "\(viewModel.activeLights)",
                color: .yellow
            )

            QuickStatCard(
                icon: "thermometer",
                label: "Temperature",
                value: viewModel.currentTemperature,
                color: .orange
            )

            QuickStatCard(
                icon: "lock.fill",
                label: "Locks",
                value: "\(viewModel.locksSecured)",
                color: .green
            )

            QuickStatCard(
                icon: "square.grid.2x2.fill",
                label: "Total",
                value: "\(viewModel.totalDevices)",
                color: AppTheme.Colors.primary
            )
        }
        .padding(.horizontal)
    }

    // MARK: - Device Categories

    private var deviceCategoriesView: some View {
        VStack(alignment: .leading, spacing: AppTheme.Spacing.md) {
            Text("Device Categories")
                .font(AppTheme.Typography.title2)
                .padding(.horizontal)

            if viewModel.deviceGroups.isEmpty {
                emptyDevicesView
            } else {
                LazyVGrid(columns: gridColumns, spacing: AppTheme.Spacing.md) {
                    ForEach(viewModel.deviceGroups, id: \.category) { group in
                        if group.category == .lights {
                            NavigationLink(destination: LightsView(homeKitManager: homeKitManager)) {
                                DashboardCategoryCard(
                                    category: group.category,
                                    count: group.count,
                                    action: {}
                                )
                            }
                            .buttonStyle(.plain)
                        } else {
                            DashboardCategoryCard(
                                category: group.category,
                                count: group.count,
                                action: { viewModel.quickAction(for: group.category) }
                            )
                        }
                    }
                }
                .padding(.horizontal)
            }
        }
    }

    // MARK: - Empty State

    private var emptyDevicesView: some View {
        VStack(spacing: AppTheme.Spacing.md) {
            Image(systemName: "plus.circle.fill")
                .font(.system(size: 50))
                .foregroundColor(AppTheme.Colors.tertiaryText)

            Text("No devices found")
                .font(AppTheme.Typography.headline)

            Text("Add devices in the Apple Home app")
                .font(AppTheme.Typography.caption)
                .foregroundColor(AppTheme.Colors.secondaryText)
        }
        .frame(maxWidth: .infinity)
        .padding(AppTheme.Spacing.xl)
        .cardStyle()
        .padding(.horizontal)
    }

    // MARK: - Quick Actions

    private var quickActionsView: some View {
        HStack(spacing: AppTheme.Spacing.md) {
            QuickActionButton(
                icon: viewModel.isMusicPlaying ? "pause.fill" : "play.fill",
                label: viewModel.isMusicPlaying ? "Pause" : "Play Music",
                color: .pink
            ) {
                // Music action
            }

            QuickActionButton(
                icon: "moon.fill",
                label: "All Off",
                color: .indigo
            ) {
                // All off action
            }

            QuickActionButton(
                icon: "sun.max.fill",
                label: "All On",
                color: .yellow
            ) {
                // All on action
            }
        }
        .padding(.horizontal)
    }
}

// MARK: - Quick Stat Card

struct QuickStatCard: View {
    let icon: String
    let label: String
    let value: String
    let color: Color

    var body: some View {
        VStack(spacing: AppTheme.Spacing.sm) {
            Image(systemName: icon)
                .font(.title2)
                .foregroundColor(color)

            Text(value)
                .font(AppTheme.Typography.title3)
                .fontWeight(.bold)

            Text(label)
                .font(AppTheme.Typography.caption)
                .foregroundColor(AppTheme.Colors.secondaryText)
        }
        .frame(maxWidth: .infinity)
        .padding()
        .cardStyle()
    }
}

// MARK: - Dashboard Category Card

struct DashboardCategoryCard: View {
    let category: DeviceCategory
    let count: Int
    let action: () -> Void

    var body: some View {
        Button(action: action) {
            VStack(spacing: AppTheme.Spacing.md) {
                Image(systemName: category.iconName)
                    .font(.system(size: 40))
                    .foregroundColor(AppTheme.Colors.primary)

                VStack(spacing: 4) {
                    Text(category.displayName)
                        .font(AppTheme.Typography.headline)
                        .foregroundColor(AppTheme.Colors.primaryText)

                    Text("\(count) device\(count == 1 ? "" : "s")")
                        .font(AppTheme.Typography.caption)
                        .foregroundColor(AppTheme.Colors.secondaryText)
                }
            }
            .frame(maxWidth: .infinity)
            .padding(AppTheme.Spacing.lg)
            .cardStyle()
        }
        .buttonStyle(.plain)
    }
}

// MARK: - Quick Action Button

struct QuickActionButton: View {
    let icon: String
    let label: String
    let color: Color
    let action: () -> Void

    var body: some View {
        Button(action: action) {
            VStack(spacing: AppTheme.Spacing.sm) {
                Image(systemName: icon)
                    .font(.title)
                    .foregroundColor(.white)

                Text(label)
                    .font(AppTheme.Typography.caption)
                    .foregroundColor(.white)
            }
            .frame(maxWidth: .infinity)
            .padding()
            .background(color)
            .cornerRadius(AppTheme.CornerRadius.medium)
        }
        .buttonStyle(.plain)
    }
}

// MARK: - Preview

#Preview {
    DashboardView(
        homeKitManager: HomeKitManager(),
        musicManager: MusicManager()
    )
}
