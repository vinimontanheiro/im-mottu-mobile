//
//  AppEventChannel.swift
//  Runner
//
//  Created by vini on 01/09/24.
//

import Foundation


class AppEventChannel {
    
    func setup(controller: FlutterViewController){
        let eventChannel = FlutterEventChannel(name: "com.mottu.marvel/network_connectivity", binaryMessenger: controller.binaryMessenger)
        eventChannel.setStreamHandler(NetworkConnectivityHandler())
    }
    
}
