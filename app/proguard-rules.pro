# ProGuard / R8 rules for Trusted Web Activity (TWA)
-keepattributes *Annotation*
-keepclassmembers class * {
    @org.chromium.base.annotations.CalledByNative <methods>;
}
-keep class com.google.androidbrowserhelper.** { *; }
-keep class androidx.browser.** { *; }
