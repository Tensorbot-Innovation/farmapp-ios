# Samposhi Farm Automation — iOS Application

Native iOS Project built with SwiftUI and `WKWebView`, providing a native, zero-latency experience for iPhone and iPad with offline embedded assets.

---

## 🚀 How to Build iOS App Without Xcode (Cloud CI/CD)

Just like the Android APK, you **do not need Xcode or a Mac** to build this iOS application! This repository includes a pre-configured **GitHub Actions** cloud pipeline in [`.github/workflows/build-ios.yml`](.github/workflows/build-ios.yml) that compiles the iOS app on Apple Silicon cloud servers and generates an installable `.ipa` artifact.

### 1. Trigger the Build on GitHub
- Pushing your code will **automatically trigger the build**!
- Or trigger manually anytime:
  1. Open your repository on GitHub in your browser.
  2. Click the **Actions** tab at the top.
  3. Select **"Build Samposhi Farm iOS IPA"** on the left.
  4. Click **Run workflow** $\rightarrow$ **Run workflow**.

### 2. Download the Generated `.ipa`
- Once the build completes (approx. 2 minutes), click on the completed run.
- Scroll down to the **Artifacts** section at the bottom.
- Click **`SamposhiFarm-iOS-IPA`** to download `SamposhiFarm-v2.2.ipa`.

---

## 📲 How to Install the `.ipa` on iPhone (Without Xcode)

Unlike Android which allows installing untrusted APKs directly with one tap, Apple requires iOS apps to be signed with an Apple ID. Here are the easiest ways to install it:

### Method A: Sideloadly (Recommended — Easiest 1-Click for Windows & Mac)
1. Download and install **Sideloadly** (Free tool from [sideloadly.io](https://sideloadly.io)).
2. Connect your iPhone to your PC or Mac via USB (or same Wi-Fi).
3. Open Sideloadly — your iPhone will appear under **iDevice**.
4. Drag & drop `SamposhiFarm-v2.2.ipa` into Sideloadly.
5. Enter your regular free **Apple ID** (used by Apple to sign the personal install profile; free, no paid developer account required).
6. Click **Start**. In ~30 seconds, the app installs onto your iPhone home screen!
7. **First Launch Only**: On your iPhone, open **Settings** $\rightarrow$ **General** $\rightarrow$ **VPN & Device Management** $\rightarrow$ Tap your Apple ID $\rightarrow$ Tap **Trust**.

---

### Method B: AltStore
If you use [AltStore](https://altstore.io), you can simply send the downloaded `SamposhiFarm-v2.2.ipa` to AltStore on your iPhone to install it over Wi-Fi.

---

### Method C: Zero-Install PWA (No Xcode, No Sideloading, Never Expires)
If you do not want to sideload or use a PC at all:
1. Open Safari on your iPhone.
2. Navigate to your hosted web app or local farm address (e.g. `SamposhiFarm_PWA/`).
3. Tap the **Share** button (box with upward arrow at bottom of Safari).
4. Tap **"Add to Home Screen"** and tap **Add**.
5. It launches as a full-screen, standalone OLED dark app without browser address bars, communicating directly with the hardware at 0ms latency!

---

## 🛠️ Optional: Open in Xcode (For Mac Developers)

If you have Xcode installed and prefer building locally:
1. Open `SamposhiFarm.xcodeproj` in Xcode.
2. Under **Signing & Capabilities**, select your Team / Apple ID.
3. Select your connected iPhone from the device target menu.
4. Press `Cmd + R` to run.

---

## 📁 Directory Structure

```
SamposhiFarm_iOSApp/
├── .github/workflows/
│   └── build-ios.yml                # Automated Cloud Xcode CI/CD Builder
├── SamposhiFarm.xcodeproj/          # Xcode project configuration
│   ├── project.pbxproj
│   └── xcshareddata/xcschemes/     # Shared scheme for headless builds
├── SamposhiFarm/
│   ├── SamposhiFarmApp.swift        # SwiftUI App lifecycle entry point
│   ├── ContentView.swift            # WKWebView container with ATS & camera hooks
│   ├── Info.plist                   # App permissions & ATS local networking config
│   ├── Assets.xcassets/             # App icons & visual catalog
│   └── www/                         # Embedded web app (HTML, CSS, JS, SVGs)
└── README.md
```
