import Foundation
import Darwin.sys.sysctl
import Darwin.Mach

let APP_GROUP = "group.ru.aeonika.AMonitor.Widgets"

struct NetUsage {
  var wifiReceived: Int = 0
  var wifiSent: Int = 0
  var cellularReceived: Int = 0
  var cellularSent: Int = 0
  
  mutating func add(_ other: NetUsage) {
    wifiSent += other.wifiSent
    wifiReceived += other.wifiReceived
    cellularSent += other.cellularSent
    cellularReceived += other.cellularReceived
  }
}

@objc class Usage : NSObject {
  static func _getRamUsage() -> Array<Int> {
    
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
    
    let pageSize64 = Int(pageSize)
    
    return [
      pageSize64 * Int(vmStats.wire_count),
      pageSize64 * Int(vmStats.active_count),
      pageSize64 * Int(vmStats.inactive_count),
      pageSize64 * Int(vmStats.compressor_page_count),
      pageSize64 * Int(vmStats.free_count),
      Int(total)
    ]
  }

  static func _getDiskUsage() -> Array<Int> {
    var freeDiskSpace:Int {
      if let space = try? URL(fileURLWithPath: NSHomeDirectory() as String).resourceValues(forKeys: [URLResourceKey.volumeAvailableCapacityForImportantUsageKey]).volumeAvailableCapacityForImportantUsage {
        return Int(space)
      } else {
        return 0
      }
    }
    
    var totalDiskSpace:Int {
      if let space = try? URL(fileURLWithPath: NSHomeDirectory() as String).resourceValues(forKeys: [URLResourceKey.volumeTotalCapacityKey]).volumeTotalCapacity {
        return Int(space)
      } else {
        return 0
      }
    }
    return  [freeDiskSpace, totalDiskSpace]
  }
  
  static func _getNetUsageForIface(from addrPtr: UnsafeMutablePointer<ifaddrs>) -> NetUsage? {
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
        netUsage.wifiSent += Int(data.pointee.ifi_obytes)
        netUsage.wifiReceived += Int(data.pointee.ifi_ibytes)
      }
    } else if name.hasPrefix(cellularPrefix) {
      networkData = unsafeBitCast(addrPtr.pointee.ifa_data, to: UnsafeMutablePointer<if_data>.self)
      if let data = networkData {
        netUsage.cellularSent += Int(data.pointee.ifi_obytes)
        netUsage.cellularReceived += Int(data.pointee.ifi_ibytes)
      }
    }
    return netUsage
  }
  
  static func _getNetUsage() -> NetUsage {
    var ifaddr: UnsafeMutablePointer<ifaddrs>?
    var netUsage = NetUsage()
    
    if getifaddrs(&ifaddr) == 0 {
      while let addr = ifaddr {
        guard let info = _getNetUsageForIface(from: addr) else {
          ifaddr = addr.pointee.ifa_next
          continue
        }
        netUsage.add(info)
        ifaddr = addr.pointee.ifa_next
      }
      freeifaddrs(ifaddr)
    }
    return netUsage
  }
  
  static func getNetUsageFromDefaults() -> NetUsage {
    var netUsage = NetUsage()
    if let defaults = UserDefaults.init(suiteName: APP_GROUP) {
      netUsage.wifiReceived = defaults.integer(forKey: "wifiReceived")
      netUsage.wifiSent = defaults.integer(forKey: "wifiSent")
      netUsage.cellularReceived = defaults.integer(forKey: "cellularReceived")
      netUsage.cellularSent = defaults.integer(forKey: "cellularSent")
    }
    return netUsage
  }
  
  static func _getBootTime() -> [Int] {
    
    var mib = [ CTL_KERN, KERN_BOOTTIME ]
    var bootTime = timeval()
    var bootTimeSize = MemoryLayout<timeval>.size
    
    var res: [Int] = [];
    
    if sysctl(&mib, UInt32(mib.count), &bootTime, &bootTimeSize, nil, 0) == 0 {
      res = [bootTime.tv_sec]
    }

    return res
  }
}


