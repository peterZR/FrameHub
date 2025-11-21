# Xcode Project Setup Instructions

Since Xcode projects are best created through the Xcode GUI for proper capability configuration, follow these steps:

## Step 1: Create New Xcode Project

1. **Open Xcode**
2. Click **"Create New Project"** or go to `File > New > Project`
3. Select **iOS** → **App** template
4. Click **Next**

## Step 2: Configure Project Settings

Fill in the project details:

- **Product Name**: `FrameHub`
- **Team**: Select your Apple Developer Team
- **Organization Identifier**: `cc.zoneride` (or your preferred identifier)
- **Bundle Identifier**: Will auto-generate as `cc.zoneride.FrameHub`
- **Interface**: `SwiftUI`
- **Language**: `Swift`
- **Storage**: `None` (we'll handle persistence manually if needed)
- **Include Tests**: ✅ (optional but recommended)

Click **Next**

## Step 3: Choose Save Location

**IMPORTANT**: Save to this location:
```
/Users/peterconijn/Library/CloudStorage/GoogleDrive-peter@zoneride.cc/My Drive/ZoneRide/Projects/FrameHub
```

⚠️ **When prompted about creating a Git repository, select "Don't create"** since we already have one set up.

## Step 4: Configure Deployment Target

After the project opens:

1. Select the **FrameHub project** in the Project Navigator (left sidebar)
2. Select the **FrameHub target** in the main editor
3. In the **General** tab:
   - **Deployment Target**: Change to `16.2` (minimum for new HomeKit architecture)
   - **Devices**: Select `iPad` only (uncheck iPhone)
   - **Supported Device Orientations (iPad)**:
     - ✅ Portrait
     - ✅ Upside Down
     - ✅ Landscape Left
     - ✅ Landscape Right

## Step 5: Enable Required Capabilities

1. Select the **FrameHub target**
2. Click the **Signing & Capabilities** tab
3. Click **"+ Capability"** button and add the following:

### Required Capabilities:
1. **HomeKit**
   - This will add the HomeKit entitlement

2. **Background Modes**
   - Check ✅ **Audio, AirPlay, and Picture in Picture**
   - This allows music to play in background

## Step 6: Configure Info.plist Privacy Descriptions

The project should have auto-generated an Info.plist. Add these privacy keys:

1. In Project Navigator, find and open **Info.plist**
2. Add the following keys (Right-click → Add Row):

| Key | Type | Value |
|-----|------|-------|
| `Privacy - HomeKit Usage Description` | String | `FrameHub needs access to your HomeKit devices to control lights, thermostats, locks, and other smart home accessories from this control panel.` |
| `Privacy - Camera Usage Description` | String | `FrameHub uses the camera for optional motion detection to wake the screen when you approach. No images are stored or transmitted.` |
| `Privacy - Photo Library Usage Description` | String | `FrameHub accesses your photo library to display photos in the screensaver mode, helping prevent screen burn-in. Photos are only displayed locally and never uploaded.` |
| `Privacy - Location When In Use Usage Description` | String | `FrameHub uses your approximate location to display weather information. Location data is only used for weather and is not stored or shared.` |

**Or** you can replace the entire Info.plist with the one we've already created at:
```
FrameHub/Resources/Info.plist
```

## Step 7: Set Up URL Scheme (for Spotify callback)

In **Info.plist**, add:

1. Add `URL types` (Array)
2. Inside it, add Item 0 (Dictionary)
3. Inside Item 0, add:
   - `URL identifier` (String): `cc.zoneride.FrameHub`
   - `URL Schemes` (Array)
     - Item 0 (String): `framehub`

## Step 8: Organize Project Structure

Now replace the default files with our organized structure:

1. **Delete** the default `ContentView.swift` and `FrameHubApp.swift` from Xcode
2. In Finder, **delete** the auto-generated `FrameHub` folder inside the project directory
3. **Move** our pre-created `FrameHub` folder (with App, Core, Features, Shared, Resources) into the project directory
4. In Xcode, **right-click the project** → **Add Files to "FrameHub"**
5. Select the **FrameHub folder** and check:
   - ✅ "Copy items if needed" (already in place, so won't copy)
   - ✅ "Create groups"
   - ✅ Add to targets: FrameHub

## Step 9: Build and Test

1. Select an iPad simulator (or your physical iPad if connected)
2. Press **⌘ + B** to build
3. If it builds successfully, press **⌘ + R** to run
4. You should see the FrameHub welcome screen!

## Step 10: Commit to Git

Once everything builds successfully:

```bash
cd ~/FrameHub
git add .
git commit -m "Add Xcode project with required capabilities (#1)

- Created iOS iPad app with SwiftUI
- Set deployment target to iPadOS 16.2
- Enabled HomeKit capability
- Enabled Background Modes (Audio)
- Added all required privacy descriptions
- Configured URL scheme for Spotify callback
- Set up proper project structure (MVVM)

Closes #1"
git push
```

## Troubleshooting

### "No such module 'SwiftUI'" error
- Make sure deployment target is iOS 13.0 or later (we're using 16.2)

### Signing errors
- Select your Team in Signing & Capabilities
- Xcode should automatically manage signing

### HomeKit capability not available
- Make sure you're logged in with an Apple Developer account
- HomeKit requires a paid developer account

### Build errors about missing files
- Make sure all files are properly added to the target
- Check that FrameHubApp.swift is marked as belonging to the FrameHub target

---

## Next Steps

After completing this setup:

✅ **Issue #1 Complete**: Xcode project set up
➡️ **Issue #2 Next**: Create MVVM architecture and project structure

---

**Need Help?** Check the [README](README.md) or open an issue on GitHub.
