//
//  HomeKitDiscoveryView.swift
//  FrameHub
//
//  Created by Peter Conijn on 21/11/2025.
//

import SwiftUI

struct HomeKitDiscoveryView: View {
    @StateObject private var viewModel: HomeKitViewModel
    @Environment(\.colorScheme) var colorScheme

    init(homeKitManager: HomeKitManager) {
        _viewModel = StateObject(wrappedValue: HomeKitViewModel(homeKitManager: homeKitManager))
    }

    var body: some View {
        ScrollView {
            VStack(spacing: AppTheme.Spacing.lg) {
                // Header
                headerView

                // Status Card
                statusCard

                // Device Categories
                if viewModel.isAuthorized {
                    if viewModel.hasDevices {
                        deviceCategoriesView
                    } else {
                        emptyStateView
                    }
                } else {
                    authorizationPromptView
                }
            }
            .padding()
        }
        .gradientBackground()
        .navigationTitle("HomeKit Devices")
    }

    // MARK: - Header

    private var headerView: some View {
        VStack(spacing: AppTheme.Spacing.sm) {
            Image(systemName: AppTheme.Icons.home)
                .font(.system(size: 50))
                .foregroundColor(AppTheme.Colors.primary)

            Text(viewModel.homeName)
                .font(AppTheme.Typography.title)

            Text(viewModel.authorizationStatusMessage)
                .font(AppTheme.Typography.caption)
                .foregroundColor(AppTheme.Colors.secondaryText)
        }
        .padding()
        .cardStyle()
    }

    // MARK: - Status Card

    private var statusCard: some View {
        HStack(spacing: AppTheme.Spacing.md) {
            StatusBadge(
                icon: "checkmark.circle.fill",
                label: "Connected",
                value: viewModel.isAuthorized ? "Yes" : "No",
                color: viewModel.isAuthorized ? AppTheme.Colors.success : AppTheme.Colors.error
            )

            Divider()

            StatusBadge(
                icon: "square.grid.2x2.fill",
                label: "Devices",
                value: "\(viewModel.totalDeviceCount)",
                color: AppTheme.Colors.primary
            )

            Divider()

            StatusBadge(
                icon: "folder.fill",
                label: "Categories",
                value: "\(viewModel.deviceGroups.count)",
                color: AppTheme.Colors.secondary
            )
        }
        .padding()
        .cardStyle()
    }

    // MARK: - Device Categories

    private var deviceCategoriesView: some View {
        VStack(alignment: .leading, spacing: AppTheme.Spacing.md) {
            Text("Device Categories")
                .font(AppTheme.Typography.title2)
                .padding(.horizontal)

            LazyVGrid(columns: [
                GridItem(.flexible()),
                GridItem(.flexible())
            ], spacing: AppTheme.Spacing.md) {
                ForEach(DeviceCategory.allCases, id: \.self) { category in
                    let count = viewModel.deviceCount(for: category)
                    if count > 0 {
                        CategoryCard(
                            category: category,
                            count: count
                        )
                    }
                }
            }
            .padding(.horizontal)
        }
    }

    // MARK: - Empty State

    private var emptyStateView: some View {
        VStack(spacing: AppTheme.Spacing.lg) {
            Image(systemName: "questionmark.square.dashed")
                .font(.system(size: 60))
                .foregroundColor(AppTheme.Colors.tertiaryText)

            Text("No Devices Found")
                .font(AppTheme.Typography.title2)

            Text("Make sure your HomeKit devices are set up in the Home app")
                .font(AppTheme.Typography.body)
                .foregroundColor(AppTheme.Colors.secondaryText)
                .multilineTextAlignment(.center)
                .padding(.horizontal, AppTheme.Spacing.xl)

            Button(action: {
                viewModel.refreshDevices()
            }) {
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

    // MARK: - Authorization Prompt

    private var authorizationPromptView: some View {
        VStack(spacing: AppTheme.Spacing.lg) {
            Image(systemName: "lock.shield.fill")
                .font(.system(size: 60))
                .foregroundColor(AppTheme.Colors.warning)

            Text("HomeKit Access Required")
                .font(AppTheme.Typography.title2)

            Text("FrameHub needs permission to access your HomeKit devices")
                .font(AppTheme.Typography.body)
                .foregroundColor(AppTheme.Colors.secondaryText)
                .multilineTextAlignment(.center)
                .padding(.horizontal, AppTheme.Spacing.xl)

            Button(action: {
                viewModel.requestAuthorization()
            }) {
                Label("Grant Access", systemImage: "key.fill")
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

// MARK: - Status Badge

struct StatusBadge: View {
    let icon: String
    let label: String
    let value: String
    let color: Color

    var body: some View {
        VStack(spacing: 8) {
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
    }
}

// MARK: - Category Card

struct CategoryCard: View {
    let category: DeviceCategory
    let count: Int

    var body: some View {
        VStack(spacing: AppTheme.Spacing.sm) {
            Image(systemName: category.iconName)
                .font(.title)
                .foregroundColor(AppTheme.Colors.primary)

            Text(category.displayName)
                .font(AppTheme.Typography.callout)
                .fontWeight(.semibold)

            Text("\(count) device\(count == 1 ? "" : "s")")
                .font(AppTheme.Typography.caption)
                .foregroundColor(AppTheme.Colors.secondaryText)
        }
        .frame(maxWidth: .infinity)
        .padding()
        .cardStyle()
    }
}

// MARK: - Preview

#Preview {
    HomeKitDiscoveryView(homeKitManager: HomeKitManager())
}
