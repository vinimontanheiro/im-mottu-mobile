import Flutter
import UIKit
import FirebaseCore

@UIApplicationMain
@objc class AppDelegate: FlutterAppDelegate {
    override func application(
        _ application: UIApplication,
        didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?
    ) -> Bool {
        GeneratedPluginRegistrant.register(
            with: self
        )
        
        let controller : FlutterViewController = window?.rootViewController as! FlutterViewController
        AppEventChannel().setup(controller: controller)
        
        if FirebaseApp.app() == nil {
            FirebaseApp.configure()
        }
        
        return super.application(
            application,
            didFinishLaunchingWithOptions: launchOptions
        )
    }
    
    
    
}
