//
//  NetworkConnectivity.swift
//  Runner
//
//  Created by vini on 01/09/24.
//

import Foundation
import Network

class NetworkConnectivityHandler: NSObject, FlutterStreamHandler {
    private var eventSink: FlutterEventSink?
    let monitor = NWPathMonitor()
    
    override init() {
        let queue = DispatchQueue(label: "NetworkConnectivity")
        monitor.start(queue: queue)
    }
    
    var connected: Bool {
        get {
            return monitor.currentPath.usesInterfaceType(.wifi) || monitor.currentPath.usesInterfaceType(.cellular)
        }
    }
    
    func onListen(withArguments arguments: Any?, eventSink: @escaping FlutterEventSink) -> FlutterError? {
        print("onListen......")
        self.eventSink = eventSink
        self.eventSink!(connected)
        
        monitor.pathUpdateHandler = { path in
            self.eventSink!(path.status == .satisfied)
        }
        
        return nil
    }
    
    
    func onCancel(withArguments arguments: Any?) -> FlutterError? {
        eventSink = nil
        return nil
    }
    
}
