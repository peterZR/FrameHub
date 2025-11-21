# FrameHub

> A modern, wall-mounted iPad smart home control center with music streaming and intelligent screensaver features.

## Overview

FrameHub transforms your iPad into an elegant, always-on smart home control panel. Designed for wall-mounted iPads running in Guided Access mode, it provides seamless control of HomeKit devices, music streaming, security cameras, and weather—all with a beautiful screensaver to prevent screen burn-in.

## Features

### 🏠 Smart Home Control (HomeKit)
- **Lights**: Control Philips Hue and any HomeKit-compatible lights (brightness, color, scenes)
- **Climate**: Manage Tado thermostats and heating systems
- **Security**: Lock/unlock Nuki smart locks and view security cameras
- **Sensors**: Monitor motion, temperature, humidity, and contact sensors
- **Extensible**: Supports all HomeKit device categories:
  - Smart plugs and switches
  - Window coverings (blinds, curtains)
  - Garage doors
  - Fans and air purifiers
  - Security systems
  - And more...

### 🎵 Music Streaming
- **Spotify Integration**: Full playback control with Spotify SDK
- **SoundCloud Support**: Stream music from SoundCloud (planned)
- Background audio playback
- Now playing display with album art

### 📸 Intelligent Screensaver
- **Photo Slideshow**: Display personal photos when idle
- **Burn-in Prevention**: Automatic screensaver activation
- **Tap to Wake**: Simple tap returns to control panel
- **Motion Detection**: Optional camera-based motion detection to wake display

### 🌤️ Additional Features
- **Weather Display**: Real-time weather using WeatherKit
- **Camera Feeds**: Live view from HomeKit security cameras
- **Adaptive Layout**: Supports both landscape and portrait orientation
- **Kiosk Mode**: Optimized for Guided Access Mode (permanently mounted)

## Tech Stack

### Platform & Requirements
- **Target Device**: iPad (5th generation or newer)
- **Minimum iOS**: iPadOS 16.2
- **Development**: Xcode 15+, Swift 5.9+
- **UI Framework**: SwiftUI
- **Architecture**: MVVM with Combine

### Core Frameworks
- **HomeKit**: Smart home device discovery and control
- **Spotify iOS SDK**: Music streaming and playback
- **AVFoundation**: Camera access for motion detection
- **WeatherKit**: Weather data and forecasts
- **PhotoKit**: Photo library access for screensaver
- **UIKit**: Guided Access Mode support

### Required Capabilities
- HomeKit
- Background Modes (Audio)
- Camera (Motion detection)
- Photo Library Access
- Network

### Music Services
- Spotify iOS SDK (primary)
- SoundCloud API (planned)
- Local playback control with background audio support

## Project Structure

```
FrameHub/
├── FrameHub/
│   ├── App/
│   │   └── FrameHubApp.swift
│   ├── Core/
│   │   ├── HomeKit/
│   │   │   ├── HomeKitManager.swift
│   │   │   └── Models/
│   │   ├── Music/
│   │   │   ├── SpotifyManager.swift
│   │   │   └── SoundCloudManager.swift
│   │   ├── Camera/
│   │   │   └── MotionDetector.swift
│   │   └── Weather/
│   │       └── WeatherService.swift
│   ├── Features/
│   │   ├── Dashboard/
│   │   ├── Lights/
│   │   ├── Climate/
│   │   ├── Security/
│   │   ├── Music/
│   │   ├── Screensaver/
│   │   └── Settings/
│   ├── Shared/
│   │   ├── Views/
│   │   ├── Components/
│   │   └── Extensions/
│   └── Resources/
│       ├── Assets.xcassets
│       └── Info.plist
├── README.md
├── LICENSE
└── .gitignore
```

## Setup & Installation

### Prerequisites
1. **Apple Developer Account** (for HomeKit entitlements)
2. **Spotify Developer Account** ([Create here](https://developer.spotify.com/dashboard))
3. **iPad** running iPadOS 16.2 or later
4. **HomeKit Setup** with devices already paired in Apple Home app
5. **Xcode 15+** installed on Mac

### Configuration

1. **Clone the repository**
   ```bash
   git clone https://github.com/PeterZR/FrameHub.git
   cd FrameHub
   ```

2. **Configure Spotify**
   - Create a Spotify app in the [Spotify Developer Dashboard](https://developer.spotify.com/dashboard)
   - Add redirect URI: `framehub://spotify-callback`
   - Copy your Client ID and Client Secret
   - Create `Config.swift` with your credentials (see `Config.example.swift`)

3. **HomeKit Setup**
   - Enable HomeKit capability in Xcode project
   - Ensure your iPad and Mac are on the same iCloud account
   - HomeKit devices must be already set up in Apple Home app

4. **Build & Run**
   - Open `FrameHub.xcodeproj` in Xcode
   - Select your iPad as the target device
   - Build and run (⌘R)

### Guided Access Mode Setup

For kiosk/wall-mounted operation:

1. Go to **Settings > Accessibility > Guided Access**
2. Enable Guided Access
3. Set a passcode
4. Launch FrameHub
5. Triple-click the side button to enable Guided Access

## Security & Privacy

### App Store Preparation
- Code signing with valid certificates
- Privacy policy for camera, photo, and music access
- HomeKit security review compliance
- Spotify developer terms compliance

### Data Handling
- **HomeKit**: All data stays local, controlled by Apple's HomeKit framework
- **Camera**: Motion detection processed on-device, no data stored or transmitted
- **Photos**: Accessed locally for screensaver, never uploaded
- **Music**: Authenticated via Spotify OAuth 2.0
- **Weather**: Provided by Apple WeatherKit

### Permissions Required
- **HomeKit**: Control smart home devices
- **Camera**: Optional motion detection for screen wake
- **Photos**: Screensaver photo slideshow
- **Music**: Spotify and SoundCloud playback
- **Location**: Weather data (approximate location only)

## Development Roadmap

See [GitHub Projects](https://github.com/PeterZR/FrameHub/projects) and [Milestones](https://github.com/PeterZR/FrameHub/milestones) for detailed planning.

### Phase 1: Core Foundation
- Project setup and architecture
- HomeKit device discovery
- Basic device controls (lights, thermostats, locks)
- Adaptive UI layout (landscape/portrait)

### Phase 2: Music Integration
- Spotify SDK integration
- Music player UI
- Background audio playback
- SoundCloud integration

### Phase 3: Enhanced Features
- Photo screensaver with burn-in prevention
- Camera motion detection
- Weather display
- Security camera live feeds

### Phase 4: Polish & App Store
- Settings and customization
- Guided Access optimization
- Performance optimization
- App Store submission

## Contributing

This is a personal project, but suggestions and bug reports are welcome via GitHub Issues.

## License

MIT License - See [LICENSE](LICENSE) for details

## Acknowledgments

- Built with SwiftUI and HomeKit
- Music powered by Spotify
- Weather data from Apple WeatherKit
- Designed for iPad wall-mounted installations

---

**Status**: 🚧 In Development
**Version**: 0.1.0 (Alpha)
**Last Updated**: November 2025
