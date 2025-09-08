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
