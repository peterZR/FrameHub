//
//  AppTheme.swift
//  FrameHub
//
//  Created by Peter Conijn on 21/11/2025.
//

import SwiftUI

/// App-wide theme configuration
struct AppTheme {
    // MARK: - Colors

    struct Colors {
        // Primary colors
        static let primary = Color.blue
        static let secondary = Color.purple
        static let accent = Color.blue

        // Background colors
        static let background = Color(.systemBackground)
        static let secondaryBackground = Color(.secondarySystemBackground)
        static let cardBackground = Color(.systemBackground)

        // Text colors
        static let primaryText = Color.primary
        static let secondaryText = Color.secondary
        static let tertiaryText = Color(.tertiaryLabel)

        // Status colors
        static let success = Color.green
        static let warning = Color.orange
        static let error = Color.red
        static let info = Color.blue

        // Gradient colors
        static let gradientStart = Color.blue.opacity(0.5)
        static let gradientEnd = Color.purple.opacity(0.5)
    }

    // MARK: - Typography

    struct Typography {
        // Headers
        static let largeTitle = Font.largeTitle.weight(.bold)
        static let title = Font.title.weight(.semibold)
        static let title2 = Font.title2.weight(.semibold)
        static let title3 = Font.title3.weight(.medium)

        // Body text
        static let body = Font.body
        static let bodyBold = Font.body.weight(.semibold)
        static let callout = Font.callout
        static let caption = Font.caption
        static let caption2 = Font.caption2

        // Special
        static let headline = Font.headline
        static let subheadline = Font.subheadline
    }

    // MARK: - Spacing

    struct Spacing {
        static let xs: CGFloat = 4
        static let sm: CGFloat = 8
        static let md: CGFloat = 16
        static let lg: CGFloat = 24
        static let xl: CGFloat = 32
        static let xxl: CGFloat = 48
    }

    // MARK: - Corner Radius

    struct CornerRadius {
        static let small: CGFloat = 8
        static let medium: CGFloat = 12
        static let large: CGFloat = 16
        static let xlarge: CGFloat = 24
    }

    // MARK: - Shadows

    struct Shadow {
        static let small = 2.0
        static let medium = 5.0
        static let large = 10.0
    }

    // MARK: - Icons

    struct Icons {
        // Home & Navigation
        static let home = "house.fill"
        static let settings = "gearshape.fill"
        static let back = "chevron.left"
        static let close = "xmark"

        // HomeKit Devices
        static let light = "lightbulb.fill"
        static let thermostat = "thermometer"
        static let lock = "lock.fill"
        static let unlock = "lock.open.fill"
        static let camera = "video.fill"
        static let sensor = "sensor.fill"
        static let plug = "powerplug.fill"
        static let fan = "fan.fill"
        static let window = "blinds.vertical.closed"

        // Music
        static let music = "music.note"
        static let play = "play.fill"
        static let pause = "pause.fill"
        static let next = "forward.fill"
        static let previous = "backward.fill"
        static let shuffle = "shuffle"
        static let repeat_ = "repeat"
        static let spotify = "music.note.house.fill"

        // Other Features
        static let photo = "photo.fill"
        static let weather = "cloud.sun.fill"
        static let motion = "figure.walk.motion"
        static let screensaver = "photo.on.rectangle"
    }
}

// MARK: - View Extensions

extension View {
    /// Apply card styling
    func cardStyle() -> some View {
        self
            .padding()
            .background(AppTheme.Colors.cardBackground)
            .cornerRadius(AppTheme.CornerRadius.medium)
            .shadow(radius: AppTheme.Shadow.medium)
    }

    /// Apply gradient background
    func gradientBackground() -> some View {
        self
            .background(
                LinearGradient(
                    gradient: Gradient(colors: [
                        AppTheme.Colors.gradientStart,
                        AppTheme.Colors.gradientEnd
                    ]),
                    startPoint: .topLeading,
                    endPoint: .bottomTrailing
                )
            )
    }
}
