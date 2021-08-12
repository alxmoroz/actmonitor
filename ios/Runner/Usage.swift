import Flutter

import Darwin.sys.sysctl
import Darwin.Mach

@objc class Usage : NSObject {
    static func _getRamUsage() -> Array<UInt64> {
        
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
        
        let pageSize64 = UInt64(pageSize)

        return [
            pageSize64 * UInt64(vmStats.wire_count),
            pageSize64 * UInt64(vmStats.active_count),
            pageSize64 * UInt64(vmStats.inactive_count),
            pageSize64 * UInt64(vmStats.compressor_page_count),
            pageSize64 * UInt64(vmStats.free_count),
            UInt64(total)
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
    
    struct NetUsageInfo {
        var wifiReceived: UInt64 = 0
        var wifiSent: UInt64 = 0
        var cellularReceived: UInt64 = 0
        var cellularSent: UInt64 = 0
        
        mutating func updateInfoByAdding(_ info: NetUsageInfo) {
            wifiSent += info.wifiSent
            wifiReceived += info.wifiReceived
            cellularSent += info.cellularSent
            cellularReceived += info.cellularReceived
        }
    }

    static func getNetUsageInfo(from infoPointer: UnsafeMutablePointer<ifaddrs>) -> NetUsageInfo? {
        let pointer = infoPointer
        let name: String! = String(cString: pointer.pointee.ifa_name)
        let addr = pointer.pointee.ifa_addr.pointee
        guard addr.sa_family == UInt8(AF_LINK) else { return nil }
        
        return netUsageInfo(from: pointer, name: name)
    }
    
    static func netUsageInfo(from pointer: UnsafeMutablePointer<ifaddrs>, name: String) -> NetUsageInfo {
        var networkData: UnsafeMutablePointer<if_data>?
        var netUsageInfo = NetUsageInfo()
        let cellularPrefix = "pdp_ip"
        let wifiPrefix = "en"
        
        if name.hasPrefix(wifiPrefix) {
            networkData = unsafeBitCast(pointer.pointee.ifa_data, to: UnsafeMutablePointer<if_data>.self)
            if let data = networkData {
                netUsageInfo.wifiSent += UInt64(data.pointee.ifi_obytes)
                netUsageInfo.wifiReceived += UInt64(data.pointee.ifi_ibytes)
            }
            
        } else if name.hasPrefix(cellularPrefix) {
            networkData = unsafeBitCast(pointer.pointee.ifa_data, to: UnsafeMutablePointer<if_data>.self)
            if let data = networkData {
                netUsageInfo.cellularSent += UInt64(data.pointee.ifi_obytes)
                netUsageInfo.cellularReceived += UInt64(data.pointee.ifi_ibytes)
            }
        }
        return netUsageInfo
    }
    
    static func getNetUsage(result: FlutterResult) {
        
        var ifaddr: UnsafeMutablePointer<ifaddrs>?
        var dataUsageInfo = NetUsageInfo()

        if getifaddrs(&ifaddr) == 0 {
            while let addr = ifaddr {
                guard let info = getNetUsageInfo(from: addr) else {
                    ifaddr = addr.pointee.ifa_next
                    continue
                }
                dataUsageInfo.updateInfoByAdding(info)
                ifaddr = addr.pointee.ifa_next
            }
            
            freeifaddrs(ifaddr)
        }

        // debugPrint(dataUsageInfo.wifiReceived)
        
        result([dataUsageInfo.wifiReceived, dataUsageInfo.wifiSent, dataUsageInfo.cellularReceived, dataUsageInfo.cellularSent])
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


