# Samposhi Farm — Trusted Web Activity (TWA) Android Project

This project wraps the **Samposhi Farm Progressive Web App (PWA)** into a high-performance Android APK using Google's official **Trusted Web Activity (TWA)** architecture (`androidbrowserhelper`).

---

## What is a Trusted Web Activity (TWA)?

A **Trusted Web Activity (TWA)** runs your hosted web app directly inside the user's Chrome or system browser engine, without any browser address bar:

- **True Fullscreen Experience**: Looks and feels indistinguishable from a native Android application.
- **Latest Web Standards**: Automatic access to the latest Chromium features, V8 engine speed, modern Service Workers, and Web Push notifications.
- **Instant Updates**: Whenever you deploy updates to your hosted PWA website, users opening this TWA app get the updates immediately without re-installing or updating the APK from the Play Store!
- **Play Store Ready**: 100% compliant with Google Play Store guidelines.

---

## Directory Structure

```
SamposhiFarm_TWA/
├── .github/
│   └── workflows/
│       └── build-twa.yml             # Automated GitHub Actions cloud APK builder
├── .well-known/
│   └── assetlinks.json               # Digital Asset Links template to upload to your web host
├── app/
│   ├── build.gradle                  # App-level build config (URL, packageId, colors)
│   ├── proguard-rules.pro            # R8 optimization rules for TWA
│   └── src/
│       └── main/
│           ├── AndroidManifest.xml   # TWA LauncherActivity, metadata, and autoVerify deep links
│           └── res/
│               ├── drawable/         # Splash screen and foreground drawables
│               ├── mipmap-*/         # Launcher icons (48px to 192px)
│               ├── values/           # strings.xml, colors.xml, styles.xml
│               └── xml/              # filepaths.xml for FileProvider
├── gradle/
│   └── wrapper/                      # Gradle 8.4 wrapper configuration
├── twa-manifest.json                 # Google Bubblewrap CLI specification
├── build_twa_apk.sh                  # One-click local APK build script
├── generate_icons.py                 # Automated icon generator script
├── build.gradle                      # Top-level Gradle configuration
├── settings.gradle                   # Module settings (:app)
├── gradle.properties                 # AndroidX & JVM settings
├── gradlew                           # Gradle wrapper executable
└── README.md                         # This documentation
```

---

## 1. How to Configure Your Hosted PWA URL

Open [`app/build.gradle`](file:///Users/shahidkibs/Documents/Projects/SamposhiFarmAutomation/SamposhiFarm_TWA/app/build.gradle) and edit the `manifestPlaceholders` block:

```groovy
manifestPlaceholders = [
    hostName: "farmapp-pwa.vercel.app",                     // Your HTTPS domain without protocol
    defaultUrl: "https://farmapp-pwa.vercel.app/",          // The full startup URL of your PWA
    launcherName: "Samposhi Farm",                          // App title under the home screen icon
    themeColor: "#22C55E",                                  // Status bar color (Green)
    navigationColor: "#16A34A",                             // Android bottom nav bar color
    backgroundColor: "#F6F8FC",                             // Splash background color
    providerAuthority: "com.samposhi.farm.twa.fileprovider"
]
```

> [!NOTE]
> Pre-configured to point directly to your live Vercel PWA: `https://farmapp-pwa.vercel.app/`.

---

## 2. Removing the Browser URL Bar (Digital Asset Links)

To make Chrome trust the APK and **hide the top URL bar completely**, you must establish a digital handshake between your web server and your Android app's signing key:

1. Locate your Android keystore SHA-256 fingerprint:
   ```bash
   keytool -list -v -keystore your_release_key.jks
   ```
   *(For debug builds, run: `keytool -list -v -keystore ~/.android/debug.keystore -alias androiddebugkey -storepass android -keypass android`)*

2. Open [`SamposhiFarm_TWA/.well-known/assetlinks.json`](file:///Users/shahidkibs/Documents/Projects/SamposhiFarmAutomation/SamposhiFarm_TWA/.well-known/assetlinks.json) and paste your SHA-256 fingerprint:
   ```json
   [
     {
       "relation": ["delegate_permission/common.handle_all_urls"],
       "target": {
         "namespace": "android_app",
         "package_name": "com.samposhi.farm.twa",
         "sha256_cert_fingerprints": [
           "14:6D:E9:7D:0C:5F:6C:A7:A6:10:7B:48:C7:2E:7C:F4:79:33:04:8E:77:E5:A9:72:08:4D:45:90:FD:47:67:EE"
         ]
       }
     }
   ]
   ```

3. Upload this file to your hosting web server at:
   `https://<your-domain>/.well-known/assetlinks.json`
   *(Ensure it is served with `Content-Type: application/json` and returns HTTP status `200 OK`)*.

---

## 3. How to Build the TWA APK

### Option A: Open in Android Studio (Recommended)
1. Open Android Studio.
2. Select **File -> Open...** and navigate to:
   `/Users/shahidkibs/Documents/Projects/SamposhiFarmAutomation/SamposhiFarm_TWA`
3. Wait for Gradle sync to complete.
4. Click **Build -> Build Bundle(s) / APK(s) -> Build APK(s)**.

### Option B: Local Terminal Script
Run the automated build script:
```bash
./build_twa_apk.sh
```

### Option C: Automated Cloud Build (Zero Local Setup)
When this project is pushed to GitHub, the included workflow [`.github/workflows/build-twa.yml`](file:///Users/shahidkibs/Documents/Projects/SamposhiFarmAutomation/SamposhiFarm_TWA/.github/workflows/build-twa.yml) will automatically compile the TWA APK in Ubuntu runners and attach the ready-to-install `SamposhiFarm-TWA.apk` under the **Actions** tab.

### Option D: Using Google's Bubblewrap CLI
If you have Node.js and Bubblewrap installed (`npm i -g @bubblewrap/cli`):
```bash
cd SamposhiFarm_TWA
bubblewrap build
```

---

## Comparison: TWA vs. Offline WebView APK

| Feature | `SamposhiFarm_TWA/` (This Project) | `SamposhiFarm_AndroidApp/` (Offline Container) |
| :--- | :--- | :--- |
| **Engine** | Google Chrome / Chromium Custom Tabs | Android System WebView |
| **Web Asset Storage** | Hosted on public HTTPS server | Bundled directly inside APK (`assets/`) |
| **Updates** | **Instant**: Update your web server, all apps update automatically | Requires rebuilding & distributing a new APK |
| **Offline Performance** | Relies on Service Worker caching | 100% offline out-of-the-box (no initial internet needed) |
| **Local Farm IoT Access** | Remote / Web domain access | Direct cleartext local IP (`192.168.4.1` / Farm Router) |
| **Google Play Store** | **First-class citizen** (Recommended by Google for web apps) | Supported |
