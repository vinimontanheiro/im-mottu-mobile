import Flutter
import UIKit

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
        
        return super.application(
            application,
            didFinishLaunchingWithOptions: launchOptions
        )
    }
    
    
    
}
