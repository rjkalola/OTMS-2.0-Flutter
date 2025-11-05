import UIKit
import Flutter
import GoogleMaps
import UserNotifications

@main
@objc class AppDelegate: FlutterAppDelegate {
    override func application(
        _ application: UIApplication,
        didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?
    ) -> Bool {
        //    GMSServices.provideAPIKey("AIzaSyDDOWUo-4BVRwrbtkE2kPVz7USJCZqlwd4") // Add this
        GMSServices.provideAPIKey("AIzaSyAdLpTcvwOWzhK4maBtriznqiw5MwBNcZw")  // Add this
        UNUserNotificationCenter.current().delegate = self
        GeneratedPluginRegistrant.register(with: self)
        //New code for badge count in iOS.
        let controller: FlutterViewController = window?.rootViewController as! FlutterViewController
        let channel = FlutterMethodChannel(name: "app_badge_channel", binaryMessenger: controller.binaryMessenger)

        channel.setMethodCallHandler { (call: FlutterMethodCall, result: @escaping FlutterResult) in
            if call.method == "updateBadgeCount" {
                if let args = call.arguments as? [String: Any],
                   let count = args["count"] as? Int {
                    UIApplication.shared.applicationIconBadgeNumber = count
                    result(nil)
                } else {
                    result(FlutterError(code: "INVALID_ARGS", message: "Missing count", details: nil))
                }
            } else if call.method == "removeBadge" {
                UIApplication.shared.applicationIconBadgeNumber = 0
                result(nil)
            } else {
                result(FlutterMethodNotImplemented)
            }
        }
        return super.application(application, didFinishLaunchingWithOptions: launchOptions)
    }

    // This makes notifications show even when the app is foregrounded
    override func userNotificationCenter(
        _ center: UNUserNotificationCenter,
        willPresent notification: UNNotification,
        withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) ->
            Void
    ) {
        completionHandler([.alert, .badge, .sound])
    }
}
