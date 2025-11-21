# FrameHub - Project Status

**Last Updated**: November 21, 2025  
**Status**: 🚧 Planning Complete - Ready to Start Development  
**Repository**: https://github.com/peterZR/FrameHub

## Quick Links

- [Repository](https://github.com/peterZR/FrameHub)
- [Issues](https://github.com/peterZR/FrameHub/issues)
- [Milestones](https://github.com/peterZR/FrameHub/milestones)
- [README](README.md)
- [Contributing Guide](CONTRIBUTING.md)

## Project Overview

FrameHub is a wall-mounted iPad smart home control center featuring:
- 🏠 Complete HomeKit integration (lights, climate, locks, sensors, cameras)
- 🎵 Music streaming (Spotify + SoundCloud)
- 📸 Intelligent screensaver with burn-in prevention
- 🌤️ Weather display via WeatherKit
- 📹 Security camera live feeds
- 💡 Motion detection for screen wake

**Target Device**: iPad 5th gen (2017) running iPadOS 16.7.10  
**Tech Stack**: Swift, SwiftUI, HomeKit, Spotify SDK, WeatherKit

## Development Roadmap

### ✅ Phase 0: Planning (Completed)
- [x] Repository created
- [x] README with tech stack
- [x] Milestones defined
- [x] 20 issues created
- [x] Contributing guidelines

### 🎯 Phase 1: Core Foundation (Current - 7 issues)

**Goal**: Build the foundation with HomeKit integration and basic controls

| Issue | Title | Status |
|-------|-------|--------|
| [#1](https://github.com/peterZR/FrameHub/issues/1) | Set up Xcode project with required capabilities | 🔴 Open |
| [#2](https://github.com/peterZR/FrameHub/issues/2) | Create MVVM architecture and project structure | 🔴 Open |
| [#3](https://github.com/peterZR/FrameHub/issues/3) | Implement HomeKit device discovery | 🔴 Open |
| [#4](https://github.com/peterZR/FrameHub/issues/4) | Build adaptive dashboard UI (landscape/portrait) | 🔴 Open |
| [#5](https://github.com/peterZR/FrameHub/issues/5) | Implement lights control (Philips Hue) | 🔴 Open |
| [#6](https://github.com/peterZR/FrameHub/issues/6) | Implement climate control (Tado thermostat) | 🔴 Open |
| [#7](https://github.com/peterZR/FrameHub/issues/7) | Implement lock control (Nuki smart locks) | 🔴 Open |

**Next Steps**:
1. Start with Issue #1: Set up Xcode project
2. Then Issue #2: Create architecture
3. Then Issue #3: HomeKit discovery

---

### 📦 Phase 2: Music Integration (4 issues)

**Goal**: Add Spotify and SoundCloud music streaming

| Issue | Title | Status |
|-------|-------|--------|
| [#8](https://github.com/peterZR/FrameHub/issues/8) | Integrate Spotify SDK | 🔴 Open |
| [#9](https://github.com/peterZR/FrameHub/issues/9) | Build music player UI | 🔴 Open |
| [#10](https://github.com/peterZR/FrameHub/issues/10) | Implement background audio playback | 🔴 Open |
| [#11](https://github.com/peterZR/FrameHub/issues/11) | Add SoundCloud integration | 🔴 Open |

---

### 🎨 Phase 3: Enhanced Features (4 issues)

**Goal**: Add screensaver, weather, cameras, and motion detection

| Issue | Title | Status |
|-------|-------|--------|
| [#12](https://github.com/peterZR/FrameHub/issues/12) | Build photo screensaver with burn-in prevention | 🔴 Open |
| [#13](https://github.com/peterZR/FrameHub/issues/13) | Integrate WeatherKit for weather display | 🔴 Open |
| [#14](https://github.com/peterZR/FrameHub/issues/14) | Add security camera live feeds | 🔴 Open |
| [#15](https://github.com/peterZR/FrameHub/issues/15) | Implement camera-based motion detection | 🔴 Open |

---

### 🚀 Phase 4: Polish & App Store (5 issues)

**Goal**: Optimize, secure, and publish to App Store

| Issue | Title | Status |
|-------|-------|--------|
| [#16](https://github.com/peterZR/FrameHub/issues/16) | Build settings and preferences screen | 🔴 Open |
| [#17](https://github.com/peterZR/FrameHub/issues/17) | Optimize for Guided Access Mode | 🔴 Open |
| [#18](https://github.com/peterZR/FrameHub/issues/18) | Performance optimization and memory management | 🔴 Open |
| [#19](https://github.com/peterZR/FrameHub/issues/19) | Security hardening and privacy compliance | 🔴 Open |
| [#20](https://github.com/peterZR/FrameHub/issues/20) | App Store preparation and submission | 🔴 Open |

---

## Progress Summary

| Metric | Count |
|--------|-------|
| **Total Issues** | 20 |
| **Open Issues** | 20 |
| **Completed Issues** | 0 |
| **Progress** | 0% |

### By Phase
- Phase 1: 0/7 (0%)
- Phase 2: 0/4 (0%)
- Phase 3: 0/4 (0%)
- Phase 4: 0/5 (0%)

## Recent Activity

- **Nov 21, 2025**: Project created
- **Nov 21, 2025**: All 20 issues created
- **Nov 21, 2025**: Documentation complete (README, CONTRIBUTING)
- **Nov 21, 2025**: Ready to start development!

## Next Immediate Actions

1. ✅ Create GitHub repository - **DONE**
2. ✅ Write comprehensive README - **DONE**
3. ✅ Create milestones and issues - **DONE**
4. 🔄 Start Issue #1: Set up Xcode project - **NEXT**
5. ⏳ Start Issue #2: Create architecture - **PENDING**

## Dependencies & Prerequisites

Before starting development, ensure you have:

- [ ] **Xcode 15+** installed
- [ ] **Apple Developer Account** (for HomeKit entitlements)
- [ ] **Spotify Developer Account** ([Sign up](https://developer.spotify.com/dashboard))
- [ ] **iPad running iPadOS 16.2+** for testing
- [ ] **HomeKit devices** already set up in Apple Home app
- [ ] **iCloud account** (same on Mac and iPad)

## External Services Setup

### Required for Development

1. **Spotify Developer**
   - Create app at https://developer.spotify.com/dashboard
   - Set redirect URI: `framehub://spotify-callback`
   - Get Client ID and Client Secret

2. **Apple Developer**
   - Enable HomeKit capability
   - Enable WeatherKit
   - Configure app ID and signing

### Optional for Later

3. **SoundCloud Developer** (Phase 2)
   - Research current API status
   - Register if API available

## Known Considerations

### Technical Constraints
- iPad 5th gen (2017) cannot upgrade past iPadOS 16.7.10
- App must target iPadOS 16.2 minimum for new HomeKit architecture
- Limited to HomeKit local network (no cloud required)
- Spotify SDK requires Spotify app installed on device

### Design Decisions
- Prioritize Spotify over SoundCloud (user preference)
- Camera motion detection as optional feature (privacy)
- External motion sensor as alternative (more reliable)
- Screensaver essential for burn-in prevention
- Guided Access Mode for kiosk deployment

## Contributing

See [CONTRIBUTING.md](CONTRIBUTING.md) for development guidelines.

---

**Let's build an amazing smart home control center!** 🚀
