# Contributing to FrameHub

Thank you for your interest in FrameHub! This document provides guidelines for development.

## Project Organization

### Milestones

The project is organized into 4 development phases:

1. **Phase 1: Core Foundation** (7 issues)
   - Xcode project setup
   - MVVM architecture
   - HomeKit integration
   - Basic device controls (lights, climate, locks)
   - Dashboard UI

2. **Phase 2: Music Integration** (4 issues)
   - Spotify SDK integration
   - SoundCloud support
   - Music player UI
   - Background audio playback

3. **Phase 3: Enhanced Features** (4 issues)
   - Photo screensaver with burn-in prevention
   - WeatherKit integration
   - Security camera feeds
   - Motion detection for screen wake

4. **Phase 4: Polish & App Store** (5 issues)
   - Settings screen
   - Guided Access optimization
   - Performance optimization
   - Security hardening
   - App Store submission

### Labels

Issues are tagged with these labels:

- `feature` - New feature implementation
- `homekit` - HomeKit-related work
- `music` - Music streaming features
- `ui` - User interface work
- `security` - Security and privacy
- `performance` - Performance optimization
- `enhancement` - Improvements to existing features
- `bug` - Bug fixes
- `documentation` - Documentation updates

## Development Workflow

### Getting Started

1. Check the [current milestone](https://github.com/peterZR/FrameHub/milestones)
2. Pick an issue from the active phase
3. Create a feature branch: `git checkout -b feature/issue-number-description`
4. Implement the feature following the tasks in the issue
5. Test thoroughly on iPad hardware
6. Commit with descriptive messages
7. Push and create a pull request

### Branch Naming

- Feature: `feature/#1-xcode-setup`
- Bug fix: `bugfix/#23-camera-crash`
- Enhancement: `enhancement/#15-better-motion-detection`

### Commit Messages

Follow this format:
```
Brief description (50 chars or less)

More detailed explanation if needed. Wrap at 72 characters.

- Bullet points for multiple changes
- Reference issues with #issue-number

Closes #issue-number
```

Example:
```
Add HomeKit device discovery (#3)

Implement HMHomeManager integration to discover all HomeKit
accessories and categorize them by type.

- Created HomeKitManager service
- Added device models for lights, thermostats, locks
- Implemented authorization flow
- Added error handling

Closes #3
```

## Code Standards

### Swift Style Guide

- Follow [Swift API Design Guidelines](https://swift.org/documentation/api-design-guidelines/)
- Use SwiftLint (configuration in `.swiftlint.yml`)
- 4 spaces for indentation
- Maximum line length: 120 characters
- Use meaningful variable and function names

### SwiftUI Best Practices

- Keep views small and focused
- Extract reusable components
- Use `@StateObject` for view models
- Use `@ObservedObject` for passed-in objects
- Prefer `@Environment` for dependency injection
- Use `PreviewProvider` for all views

### Architecture

FrameHub follows **MVVM** (Model-View-ViewModel) architecture:

```
View (SwiftUI)
  ↓
ViewModel (@StateObject)
  ↓
Service/Manager
  ↓
Model
```

#### Example Structure

```swift
// Model
struct Light: Identifiable {
    let id: UUID
    var name: String
    var isOn: Bool
    var brightness: Double
}

// Service
class HomeKitManager: ObservableObject {
    @Published var lights: [Light] = []

    func toggleLight(_ light: Light) {
        // HomeKit logic
    }
}

// ViewModel
class LightsViewModel: ObservableObject {
    @Published var lights: [Light] = []
    private let homeKitManager: HomeKitManager

    init(homeKitManager: HomeKitManager) {
        self.homeKitManager = homeKitManager
    }

    func toggle(_ light: Light) {
        homeKitManager.toggleLight(light)
    }
}

// View
struct LightsView: View {
    @StateObject var viewModel: LightsViewModel

    var body: some View {
        List(viewModel.lights) { light in
            Toggle(light.name, isOn: /* binding */)
        }
    }
}
```

## Testing

### Manual Testing

Each feature should be tested:
- On iPad 5th generation (target device)
- In both landscape and portrait orientation
- With Guided Access Mode enabled
- With low battery conditions
- Over extended periods (24+ hours for stability)

### Testing Checklist

Before marking an issue complete:
- [ ] Feature works as described
- [ ] No crashes or errors
- [ ] Tested on physical iPad
- [ ] Works in Guided Access Mode
- [ ] Both orientations supported
- [ ] Error handling works correctly
- [ ] Performance is acceptable
- [ ] No memory leaks

## Security & Privacy

### Sensitive Data

- **Never commit** API keys, tokens, or secrets
- Use `Config.swift` for credentials (gitignored)
- Store tokens in Keychain
- Use environment variables for CI/CD

### Privacy

- Request permissions with clear explanations
- Process sensitive data on-device only
- No analytics or tracking
- Respect user privacy choices

## Issue Workflow

### Issue States

1. **Open** - Not started
2. **In Progress** - Actively being worked on
3. **Review** - Pull request created, awaiting review
4. **Closed** - Completed and merged

### Marking Issues

When you start working on an issue:
- Comment "Working on this" or assign yourself
- Create a branch
- Keep the issue updated with progress

When creating a PR:
- Reference the issue number in PR description
- Include "Closes #issue-number" in commit message
- Add screenshots/videos for UI changes

## Questions?

- Check existing issues and discussions
- Review the [README](README.md)
- Open a new issue for questions or clarifications

---

Happy coding! Let's build an amazing smart home control center! 🏠🎵📱
