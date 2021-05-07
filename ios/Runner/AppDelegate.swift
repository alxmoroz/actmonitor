import UIKit
import Flutter

import Darwin.sys.sysctl
import Darwin.Mach

@UIApplicationMain
@objc class AppDelegate: FlutterAppDelegate {
  override func application(
    _ application: UIApplication,
    didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?
  ) -> Bool {
    
    let controller : FlutterViewController = window?.rootViewController as! FlutterViewController
    let usageChannel = FlutterMethodChannel(name: "amonitor.w-cafe.ru/usage", binaryMessenger: controller.binaryMessenger)
    usageChannel.setMethodCallHandler({
      [weak self] (call: FlutterMethodCall, result: FlutterResult) -> Void in
      
        if call.method == "getRamUsage" {
            self?.getRamUsage(result: result)
        }
        else if call.method == "getDiskUsage" {
            self?.getDiskUsage(result: result)
        }
        else {
            result(FlutterMethodNotImplemented)
            return
        }
    })

    GeneratedPluginRegistrant.register(with: self)
    return super.application(application, didFinishLaunchingWithOptions: launchOptions)
  }
    
  private func getRamUsage(result: FlutterResult) {
    
    let port = mach_host_self()
    var pageSize = vm_size_t()

    var total = 0
    var bufSize = MemoryLayout<UnsafeMutableRawPointer>.stride
    sysctlbyname("hw.memsize", &total, &bufSize, nil, 0)
    
    var vmStats = vm_statistics64_data_t()
    var count = mach_msg_type_number_t(MemoryLayout<vm_statistics64_data_t>.stride / MemoryLayout<integer_t>.stride)
    let machRes = withUnsafeMutablePointer(to: &vmStats) {
        $0.withMemoryRebound(to: integer_t.self, capacity: 1) {
            host_statistics64(mach_host_self(), HOST_VM_INFO64, $0, &count)
        }
    }
    
    guard machRes == KERN_SUCCESS && host_page_size(port, &pageSize) == KERN_SUCCESS else {
        result(nil)
        return
    }

    let pageSize64 = UInt64(pageSize)
    
//    debugPrint(vmStats)
    
    result([
            pageSize64 * UInt64(vmStats.wire_count),
            pageSize64 * UInt64(vmStats.active_count),
            pageSize64 * UInt64(vmStats.inactive_count),
            pageSize64 * UInt64(vmStats.compressor_page_count),
            pageSize64 * UInt64(vmStats.free_count),
            total
    ])
  }
    private func getDiskUsage(result: FlutterResult) {
        var freeDiskSpace:Int64 {
            if let space = try? URL(fileURLWithPath: NSHomeDirectory() as String).resourceValues(forKeys: [URLResourceKey.volumeAvailableCapacityForImportantUsageKey]).volumeAvailableCapacityForImportantUsage {
                return space
            } else {
                return 0
            }
        }
        
        var totalDiskSpace:Int64 {
            if let space = try? URL(fileURLWithPath: NSHomeDirectory() as String).resourceValues(forKeys: [URLResourceKey.volumeTotalCapacityKey]).volumeTotalCapacity {
                return Int64(space)
            } else {
                return 0
            }
        }
        
        result([freeDiskSpace, totalDiskSpace])
}
}


