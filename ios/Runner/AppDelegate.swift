import UIKit
import Flutter

@UIApplicationMain
@objc class AppDelegate: FlutterAppDelegate {
    override func application(
        _ application: UIApplication,
        didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?
    ) -> Bool {
        
        let controller : FlutterViewController = window?.rootViewController as! FlutterViewController
        let usageChannel = FlutterMethodChannel(name: "amonitor.w-cafe.ru/usage", binaryMessenger: controller.binaryMessenger)
        usageChannel.setMethodCallHandler({
            (call: FlutterMethodCall, result: FlutterResult) -> Void in
            
            if call.method == "getRamUsage" {
                Usage.getRamUsage(result: result)
            }
            else if call.method == "getDiskUsage" {
                Usage.getDiskUsage(result: result)
            }
            else if call.method == "getBatteryUsage" {
                Usage.getBatteryUsage(result: result)
            }
            else if call.method == "getNetUsage" {
                Usage.getNetUsage(result: result)
            }
            else {
                result(FlutterMethodNotImplemented)
                return
            }
        })
        
        GeneratedPluginRegistrant.register(with: self)
        return super.application(application, didFinishLaunchingWithOptions: launchOptions)
    }
}


