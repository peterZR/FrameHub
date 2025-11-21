# Xcode Project Integration Guide

Your Xcode project has been created! Now we need to integrate the organized folder structure.

## Current Status ✅

- ✅ Xcode project created at: `FrameHub/FrameHub.xcodeproj`
- ✅ Organized folder structure created
- ✅ Files moved to proper locations:
  - `App/FrameHubApp.swift`
  - `Features/Dashboard/ContentView.swift`
  - `Resources/Assets.xcassets`
  - `Resources/Info.plist` (with privacy descriptions)

## Next Steps in Xcode

### Step 1: Remove Old File References

1. **Open Xcode** project: `FrameHub/FrameHub.xcodeproj`
2. In the **Project Navigator** (left sidebar), you'll see the old flat structure
3. **Select and Delete** these items (choose "Remove Reference" when prompted, NOT "Move to Trash"):
   - `FrameHubApp.swift` (if it appears at root level)
   - `ContentView.swift` (if it appears at root level)
   - `Assets.xcassets` (if it appears at root level)

### Step 2: Add Organized Folder Structure

1. **Right-click** on the `FrameHub` group (blue folder icon) in Project Navigator
2. Select **"Add Files to 'FrameHub'..."**
3. Navigate to: `FrameHub/FrameHub/FrameHub/`
4. Select the following folders (hold Cmd to select multiple):
   - `App`
   - `Core`
   - `Features`
   - `Shared`
   - `Resources`
5. In the options dialog:
   - ✅ "Create groups" (NOT "Create folder references")
   - ✅ "Add to targets: FrameHub"
   - Click **"Add"**

### Step 3: Configure Deployment Target & Devices

1. Click on the **FrameHub project** (blue icon) in Project Navigator
2. Select the **FrameHub target** in the main area
3. In the **General** tab:
   - **Minimum Deployments**: Change to `iPadOS 16.2`
   - **Supported Destinations**:
     - Remove iPhone (click the - button)
     - Keep iPad only

4. Scroll down to **Deployment Info**:
   - **iPhone Orientation**: (Not applicable since iPad only)
   - **iPad Orientation**: Ensure all are checked:
     - ✅ Portrait
     - ✅ Upside Down
     - ✅ Landscape Left
     - ✅ Landscape Right

### Step 4: Enable Capabilities

1. Still in the **FrameHub target**, click the **Signing & Capabilities** tab
2. Make sure **"Automatically manage signing"** is checked
3. Select your **Team** from the dropdown
4. Click **"+ Capability"** button and add:

   **a) HomeKit**
   - Search for "HomeKit"
   - Click to add
   - This enables HomeKit entitlement

   **b) Background Modes**
   - Search for "Background Modes"
   - Click to add
   - In the options that appear, check:
     - ✅ **Audio, AirPlay, and Picture in Picture**

### Step 5: Configure Info.plist

The Info.plist is already created with all privacy descriptions in `Resources/Info.plist`. But we need to tell Xcode to use it:

1. Select the **FrameHub target**
2. Go to **Build Settings** tab
3. Search for "Info.plist"
4. Under **Packaging**, find **"Info.plist File"**
5. Set value to: `FrameHub/Resources/Info.plist`

**OR** you can manually merge the privacy descriptions into Xcode's generated Info.plist:

1. In Project Navigator, find and click **Info.plist** (might be under FrameHub folder)
2. Right-click in the property list → **"Add Row"** and add these keys:

| Key | Type | Value |
|-----|------|-------|
| `Privacy - HomeKit Usage Description` | String | `FrameHub needs access to your HomeKit devices to control lights, thermostats, locks, and other smart home accessories from this control panel.` |
| `Privacy - Camera Usage Description` | String | `FrameHub uses the camera for optional motion detection to wake the screen when you approach. No images are stored or transmitted.` |
| `Privacy - Photo Library Usage Description` | String | `FrameHub accesses your photo library to display photos in the screensaver mode, helping prevent screen burn-in. Photos are only displayed locally and never uploaded.` |
| `Privacy - Location When In Use Usage Description` | String | `FrameHub uses your approximate location to display weather information. Location data is only used for weather and is not stored or shared.` |

3. Add URL Scheme for Spotify:
   - Add `URL types` (Array) if not exists
   - Add Item 0 (Dictionary)
   - Inside it:
     - `URL identifier`: `cc.zoneride.FrameHub`
     - `URL Schemes` (Array):
       - Item 0: `framehub`

### Step 6: Build and Test!

1. Select an **iPad simulator** from the device dropdown (or your physical iPad)
2. Press **⌘ + B** to build
3. Fix any file reference errors if they appear
4. Once it builds successfully, press **⌘ + R** to run
5. You should see the **FrameHub welcome screen** with:
   - House icon
   - "FrameHub" title
   - Feature list

### Step 7: Verify Structure in Xcode

After adding files, your Project Navigator should look like:

```
FrameHub (project)
└── FrameHub (group - blue folder)
    ├── App
    │   └── FrameHubApp.swift
    ├── Core
    │   ├── HomeKit
    │   ├── Music
    │   ├── Camera
    │   └── Weather
    ├── Features
    │   ├── Dashboard
    │   │   └── ContentView.swift
    │   ├── Lights
    │   ├── Climate
    │   ├── Security
    │   ├── Music
    │   ├── Screensaver
    │   └── Settings
    ├── Shared
    │   ├── Views
    │   ├── Components
    │   └── Extensions
    └── Resources
        ├── Assets.xcassets
        └── Info.plist
```

## Troubleshooting

### "No such file or directory" build errors
- Make sure all files are added to the FrameHub target
- Right-click the file → **"Show File Inspector"** (right sidebar)
- Under **Target Membership**, check ✅ **FrameHub**

### Files appear with red text
- The file references are broken
- Right-click → **Delete** (Remove Reference)
- Re-add the files using "Add Files to FrameHub..."

### Build succeeds but app crashes immediately
- Check that FrameHubApp.swift is in the target
- Verify @main attribute exists in FrameHubApp
- Check that Assets.xcassets is properly added

### HomeKit capability not available
- You need a paid Apple Developer account
- Make sure you're signed in to Xcode with your Apple ID
- Go to Xcode → Settings → Accounts

## Success Criteria ✅

When everything is set up correctly:
- ✅ Project builds without errors (⌘ + B)
- ✅ App runs on iPad simulator (⌘ + R)
- ✅ Shows FrameHub welcome screen
- ✅ Organized folder structure visible in Project Navigator
- ✅ HomeKit capability enabled
- ✅ Background Modes (Audio) enabled
- ✅ Deployment target set to iPadOS 16.2
- ✅ iPad only (no iPhone)

## Next: Commit to Git

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
- Organized project structure (MVVM)
- Created welcome screen with feature overview

Closes #1"
git push
```

---

**Need help?** Let me know what errors you're seeing!
