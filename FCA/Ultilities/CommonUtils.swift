//
//  CommonUtils.swift
//  FCA
//

import Foundation
import SystemConfiguration

enum ConnectionType {
    case unknown
    case none
    case wWan
    case wifi
}

class CommonUtils {
    static func internetConnected() -> Bool {
        return currentConnectionType() != ConnectionType.none
    }
    
    static func wifiConnected() -> Bool {
        return currentConnectionType() == ConnectionType.wifi
    }
    
    class private func currentConnectionType() -> ConnectionType {
        
        // Setting Socket address, internet style
        var zeroAddressValue = sockaddr_in(sin_len: 0,
                                           sin_family: 0,
                                           sin_port: 0,
                                           sin_addr: in_addr(s_addr: 0),
                                           sin_zero: (0, 0, 0, 0, 0, 0, 0, 0))
        zeroAddressValue.sin_len = UInt8(MemoryLayout.size(ofValue: zeroAddressValue))
        zeroAddressValue.sin_family = sa_family_t(AF_INET)
        
        // Create a pointer to the given argument
        let reachability = withUnsafePointer(to: &zeroAddressValue) {
            $0.withMemoryRebound(to: sockaddr.self, capacity: 1) {zeroAddressValue in
                SCNetworkReachabilityCreateWithAddress(nil, zeroAddressValue)
            }
        }
        
        // Get flags determines if the target is reachable using the current network configuration
        var flagsValue: SCNetworkReachabilityFlags = SCNetworkReachabilityFlags(rawValue: 0)
        if SCNetworkReachabilityGetFlags(reachability!, &flagsValue) == false {
            return ConnectionType.unknown
        }
        
        // Flag indicates the the specified nodename or address can be reached using the current network configuration
        let reachableCase = (flagsValue.rawValue & UInt32(kSCNetworkFlagsReachable)) != 0
        let connectionCase = (flagsValue.rawValue & UInt32(kSCNetworkFlagsConnectionRequired)) != 0
        let ret = (reachableCase && !connectionCase)
        
        if !ret {
            // Don't have internet connect
            return ConnectionType.none
        } else if 0 != (flagsValue.rawValue & ((SCNetworkReachabilityFlags.isWWAN).rawValue)) {
            // Check if address can reached via an EDGE, GPRS
            return ConnectionType.wWan
        } else {
            // Address can reached via an Wifi
            return ConnectionType.wifi
        }
    }
}
