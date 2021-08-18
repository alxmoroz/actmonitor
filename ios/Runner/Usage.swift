import Flutter

import Darwin.sys.sysctl
import Darwin.Mach

struct NetUsage {
  var wifiReceived: Int64 = 0
  var wifiSent: Int64 = 0
  var cellularReceived: Int64 = 0
  var cellularSent: Int64 = 0
  
  mutating func add(_ other: NetUsage) {
    wifiSent += other.wifiSent
    wifiReceived += other.wifiReceived
    cellularSent += other.cellularSent
    cellularReceived += other.cellularReceived
  }
}

@objc class Usage : NSObject {
  static func _getRamUsage() -> Array<Int64> {
    
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
      return []
    }
    
    let pageSize64 = Int64(pageSize)
    
    return [
      pageSize64 * Int64(vmStats.wire_count),
      pageSize64 * Int64(vmStats.active_count),
      pageSize64 * Int64(vmStats.inactive_count),
      pageSize64 * Int64(vmStats.compressor_page_count),
      pageSize64 * Int64(vmStats.free_count),
      Int64(total)
    ]
  }
  
  static func getRamUsage(result: FlutterResult) {
    result(_getRamUsage())
  }
  
  static func _getDiskUsage() -> Array<Int64> {
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
    return  [freeDiskSpace, totalDiskSpace]
  }
  
  static func getDiskUsage(result: FlutterResult) {
    result(_getDiskUsage())
  }
  
  static func getBatteryUsage(result: FlutterResult) {
    let device = UIDevice.current
    device.isBatteryMonitoringEnabled = true
    let state = device.batteryState.rawValue
    var level:Float = -1.0
    if state != UIDevice.BatteryState.unknown.rawValue {
      level = device.batteryLevel
    }
    result([level, state])
  }
  
  static func getNetUsageForIface(from addrPtr: UnsafeMutablePointer<ifaddrs>) -> NetUsage? {
    let name: String! = String(cString: addrPtr.pointee.ifa_name)
    let addr = addrPtr.pointee.ifa_addr.pointee
    guard addr.sa_family == UInt8(AF_LINK) else { return nil }
    
    var networkData: UnsafeMutablePointer<if_data>?
    var netUsage = NetUsage()
    let cellularPrefix = "pdp_ip"
    let wifiPrefix = "en"
    
    if name.hasPrefix(wifiPrefix) {
      networkData = unsafeBitCast(addrPtr.pointee.ifa_data, to: UnsafeMutablePointer<if_data>.self)
      if let data = networkData {
        netUsage.wifiSent += Int64(data.pointee.ifi_obytes)
        netUsage.wifiReceived += Int64(data.pointee.ifi_ibytes)
      }
    } else if name.hasPrefix(cellularPrefix) {
      networkData = unsafeBitCast(addrPtr.pointee.ifa_data, to: UnsafeMutablePointer<if_data>.self)
      if let data = networkData {
        netUsage.cellularSent += Int64(data.pointee.ifi_obytes)
        netUsage.cellularReceived += Int64(data.pointee.ifi_ibytes)
      }
    }
    return netUsage
  }
  
  static func _getNetUsage() -> NetUsage {
    var ifaddr: UnsafeMutablePointer<ifaddrs>?
    var netUsageInfo = NetUsage()
    
    if getifaddrs(&ifaddr) == 0 {
      while let addr = ifaddr {
        guard let info = getNetUsageForIface(from: addr) else {
          ifaddr = addr.pointee.ifa_next
          continue
        }
        netUsageInfo.add(info)
        ifaddr = addr.pointee.ifa_next
      }
      freeifaddrs(ifaddr)
    }
    return netUsageInfo
  }
  
  static func getNetUsage(result: FlutterResult) {
    let netUsageInfo = _getNetUsage()
    result([netUsageInfo.wifiReceived, netUsageInfo.wifiSent, netUsageInfo.cellularReceived, netUsageInfo.cellularSent])
  }
  
  static func saveNetUsage(args: [String: Any]) {
    debugPrint(args["wifiReceived"] as? Int64 ?? 0)
  }
  
  
  static func getBootTime(result: FlutterResult) {
    
    var mib = [ CTL_KERN, KERN_BOOTTIME ]
    var bootTime = timeval()
    var bootTimeSize = MemoryLayout<timeval>.size
    
    if sysctl(&mib, UInt32(mib.count), &bootTime, &bootTimeSize, nil, 0) == 0 {
      result([Int64(bootTime.tv_sec)])
    }
    else {
      result([])
    }
  }
}


