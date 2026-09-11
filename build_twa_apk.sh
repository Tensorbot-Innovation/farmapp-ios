#!/usr/bin/env bash
# ==============================================================================
# Samposhi Farm Automation — Trusted Web Activity (TWA) APK Builder
# ==============================================================================
set -e

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
ROOT_DIR="$(cd "$SCRIPT_DIR/.." && pwd)"

echo "================================================================="
echo " Samposhi Farm Automation — Trusted Web Activity (TWA) Builder   "
echo "================================================================="

cd "$SCRIPT_DIR"

# 1. Generate fresh icons
python3 "$SCRIPT_DIR/generate_icons.py"

# 2. Check Java availability
if ! command -v java >/dev/null 2>&1; then
    echo ""
    echo "[\033[93mNOTICE\033[0m] Java Runtime (JDK 17) was not detected in PATH."
    echo ""
    echo "To compile this TWA APK locally on your Mac, choose one of these options:"
    echo "  1. Open in Android Studio:"
    echo "     Launch Android Studio -> File -> Open -> Select '$SCRIPT_DIR'"
    echo "     Then click: Build -> Build Bundle(s) / APK(s) -> Build APK(s)"
    echo ""
    echo "  2. Install OpenJDK via Homebrew:"
    echo "     brew install openjdk@17"
    echo "     sudo ln -sfn /opt/homebrew/opt/openjdk@17/libexec/openjdk.jdk /Library/Java/JavaVirtualMachines/openjdk-17.jdk"
    echo ""
    echo "  3. Automated Cloud Build (Zero Setup):"
    echo "     Push this project to GitHub — GitHub Actions will automatically"
    echo "     build and attach 'SamposhiFarm-TWA.apk' under the Actions tab!"
    echo "================================================================="
    exit 0
fi

echo "[\033[92mBUILD\033[0m] Found Java: $(java -version 2>&1 | head -n 1)"

# 3. Ensure gradle wrapper jar exists
mkdir -p gradle/wrapper
if [ ! -f gradle/wrapper/gradle-wrapper.jar ]; then
    echo "[\033[92mBUILD\033[0m] Downloading gradle-wrapper.jar..."
    curl -fsSL -o gradle/wrapper/gradle-wrapper.jar https://raw.githubusercontent.com/gradle/gradle/v8.4.0/gradle/wrapper/gradle-wrapper.jar || \
    curl -fsSL -o gradle/wrapper/gradle-wrapper.jar https://repo.maven.apache.org/maven2/org/gradle/gradle-wrapper/8.4/gradle-wrapper-8.4.jar || true
fi

# 4. Compile TWA APK
chmod +x gradlew
echo "[\033[92mBUILD\033[0m] Compiling TWA APK with Gradle..."
./gradlew assembleDebug --no-daemon

OUT_APK="$SCRIPT_DIR/app/build/outputs/apk/debug/app-debug.apk"
if [ -f "$OUT_APK" ]; then
    FINAL_APK="$SCRIPT_DIR/SamposhiFarm-TWA-debug.apk"
    cp "$OUT_APK" "$FINAL_APK"
    echo "================================================================="
    echo "[\033[92mSUCCESS\033[0m] TWA APK compiled successfully!"
    echo "  Output location: $FINAL_APK"
    echo "================================================================="
fi
