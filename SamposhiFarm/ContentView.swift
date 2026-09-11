//
//  ContentView.swift
//  SamposhiFarm
//
//  Created for Samposhi Farm Automation.
//

import SwiftUI
import WebKit

struct ContentView: View {
    var body: some View {
        ZStack {
            Color(red: 0.039, green: 0.051, blue: 0.071)
                .edgesIgnoringSafeArea(.all)
            
            FarmWebView()
                .edgesIgnoringSafeArea(.all)
        }
    }
}

struct FarmWebView: UIViewRepresentable {
    func makeUIView(context: Context) -> WKWebView {
        let preferences = WKPreferences()
        preferences.javaScriptCanOpenWindowsAutomatically = true
        
        let pagePreferences = WKWebpagePreferences()
        pagePreferences.allowsContentJavaScript = true
        
        let config = WKWebViewConfiguration()
        config.preferences = preferences
        config.defaultWebpagePreferences = pagePreferences
        config.allowsInlineMediaPlayback = true
        config.mediaTypesRequiringUserActionForPlayback = []
        
        // Enable local file access and cross-origin file access
        config.preferences.setValue(true, forKey: "allowFileAccessFromFileURLs")
        config.setValue(true, forKey: "allowUniversalAccessFromFileURLs")
        
        let webView = WKWebView(frame: .zero, configuration: config)
        webView.navigationDelegate = context.coordinator
        webView.uiDelegate = context.coordinator
        
        // Prevent white flash during loading
        webView.isOpaque = false
        webView.backgroundColor = UIColor(red: 0.039, green: 0.051, blue: 0.071, alpha: 1.0)
        webView.scrollView.backgroundColor = UIColor(red: 0.039, green: 0.051, blue: 0.071, alpha: 1.0)
        webView.scrollView.bounces = true
        webView.scrollView.contentInsetAdjustmentBehavior = .never
        
        // Locate www/index.html in the bundle
        if let url = Bundle.main.url(forResource: "index", withExtension: "html", subdirectory: "www") {
            webView.loadFileURL(url, allowingReadAccessTo: Bundle.main.bundleURL)
        } else if let altUrl = Bundle.main.url(forResource: "index", withExtension: "html") {
            webView.loadFileURL(altUrl, allowingReadAccessTo: Bundle.main.bundleURL)
        } else {
            let errorHTML = """
            <!DOCTYPE html>
            <html>
            <body style="background:#0a0d12;color:#fff;font-family:sans-serif;text-align:center;padding:50px 20px;">
                <h2 style="color:#00ff9d;">Samposhi Farm Automation</h2>
                <p style="color:#8ba3bc;">Initializing assets... Please ensure 'www' folder is included in target bundle resources.</p>
            </body>
            </html>
            """
            webView.loadHTMLString(errorHTML, baseURL: nil)
        }
        
        return webView
    }

    func updateUIView(_ uiView: WKWebView, context: Context) {}

    func makeCoordinator() -> Coordinator {
        Coordinator()
    }

    class Coordinator: NSObject, WKNavigationDelegate, WKUIDelegate {
        // iOS 15+ camera permission for WebRTC/QR Barcode scanner
        @available(iOS 15.0, *)
        func webView(_ webView: WKWebView, requestMediaCapturePermissionFor origin: WKSecurityOrigin, initiatedByFrame frame: WKFrameInfo, type: WKMediaCaptureType, decisionHandler: @escaping (WKPermissionDecision) -> Void) {
            decisionHandler(.grant)
        }
        
        func webView(_ webView: WKWebView, didFailProvisionalNavigation navigation: WKNavigation!, withError error: Error) {
            print("FarmWebView load failed: \(error.localizedDescription)")
        }
    }
}
