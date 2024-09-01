package com.mottu.marvel

import android.content.Context
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.plugin.common.EventChannel

class AppEventChannel {

    fun setup(flutterEngine: FlutterEngine, context:Context){
        EventChannel(flutterEngine.dartExecutor.binaryMessenger, "com.mottu.marvel/network_connectivity").setStreamHandler(
            NetworkConnectivityHandler(context)
        )
    }
}