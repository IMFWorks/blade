import UIKit
import Flutter
import blade

@UIApplicationMain
@objc class AppDelegate: FlutterAppDelegate {
  override func application(
    _ application: UIApplication,
    didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?
  ) -> Bool {
    let vc = FirstViewController()
    window.rootViewController  = UINavigationController(rootViewController: vc)
    let flutterdelegate = FlutterBladeDelegate()
    
    flutterdelegate.navigationController = vc.navigationController
    Blade.shared.setup(application: application, delegate: flutterdelegate)
    return super.application(application, didFinishLaunchingWithOptions: launchOptions)
  }
}
