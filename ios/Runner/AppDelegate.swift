import UIKit
import WidgetKit
import Flutter

@UIApplicationMain
@objc class AppDelegate: FlutterAppDelegate {
  override func application(
    _ application: UIApplication,
    didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?
  ) -> Bool {
    
    let controller : FlutterViewController = window?.rootViewController as! FlutterViewController
    let usageChannel = FlutterMethodChannel(name: "amonitor/usage", binaryMessenger: controller.binaryMessenger)
    usageChannel.setMethodCallHandler({
      (call: FlutterMethodCall, result: FlutterResult) -> Void in
      
      if call.method == "getRamUsage" {
        result(Usage._getRamUsage())
      }
      else if call.method == "getDiskUsage" {
        result(Usage._getDiskUsage())
      }
      else if call.method == "getBatteryUsage" {
        let device = UIDevice.current
        device.isBatteryMonitoringEnabled = true
        let state = device.batteryState.rawValue
        var level:Float = -1.0
        if state != UIDevice.BatteryState.unknown.rawValue {
          level = device.batteryLevel
        }
        result([level, state])
      }
      else if call.method == "getNetUsage" {
        let netUsage = Usage._getNetUsage()
        result([netUsage.wifiReceived, netUsage.wifiSent, netUsage.cellularReceived, netUsage.cellularSent])
      }
      else if call.method == "saveNetUsage" {
        if let args = call.arguments as? [String: Int] {
          if let defaults = UserDefaults.init(suiteName: APP_GROUP) {
            for key in ["wifiReceived", "wifiSent", "cellularReceived", "cellularSent"] {
              defaults.setValue(args[key] ?? 0, forKey: key)
            }
          }
          WidgetCenter.shared.reloadAllTimelines()
        } else {
          result(FlutterError())
        }
        result(nil)
      }
      else if call.method == "getBootTime" {
        result([Usage._getBootTime()])
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


