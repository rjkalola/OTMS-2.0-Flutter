import UIKit
import Flutter
import GoogleMaps

@main
@objc class AppDelegate: FlutterAppDelegate {
  override func application(
    _ application: UIApplication,
    didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?
  ) -> Bool {
//    GMSServices.provideAPIKey("AIzaSyDDOWUo-4BVRwrbtkE2kPVz7USJCZqlwd4") // Add this
     GMSServices.provideAPIKey("AIzaSyAdLpTcvwOWzhK4maBtriznqiw5MwBNcZw") // Add this

    GeneratedPluginRegistrant.register(with: self)
    return super.application(application, didFinishLaunchingWithOptions: launchOptions)
  }
}
