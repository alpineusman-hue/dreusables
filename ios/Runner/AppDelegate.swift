import UIKit
import Flutter
import GoogleMaps
import FirebaseCore
import FirebaseAuth
import GoogleSignIn

@main
@objc class AppDelegate: FlutterAppDelegate {
  override func application(
    _ application: UIApplication,
    didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?
  ) -> Bool {
    GMSServices.provideAPIKey("AIzaSyCqP_po3VVErDM_bd9sGVUmMNDJwEhHyUA")
    GeneratedPluginRegistrant.register(with: self)
    return super.application(application, didFinishLaunchingWithOptions: launchOptions)
  }

  override func application(
    _ app: UIApplication,
    open url: URL,
    options: [UIApplication.OpenURLOptionsKey: Any] = [:]
  ) -> Bool {
    // Handle Firebase Auth URLs
    if Auth.auth().canHandle(url) {
      return true
    }
    
    // Handle Google Sign-In URLs
    if GIDSignIn.sharedInstance.handle(url) {
      return true
    }
    
    return super.application(app, open: url, options: options)
  }
}