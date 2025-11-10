import UIKit
import WidgetKit
import Flutter
import workmanager_apple

@main
@objc class AppDelegate: FlutterAppDelegate {
  static func registerPlugins(with registry: FlutterPluginRegistry) {
    GeneratedPluginRegistrant.register(with: registry)
  }

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

    UIApplication.shared.setMinimumBackgroundFetchInterval(TimeInterval(60*15))

    AppDelegate.registerPlugins(with: self)
    
    WorkmanagerPlugin.setPluginRegistrantCallback { registry in
      AppDelegate.registerPlugins(with: registry)
    }

    return super.application(application, didFinishLaunchingWithOptions: launchOptions)
  }
}


