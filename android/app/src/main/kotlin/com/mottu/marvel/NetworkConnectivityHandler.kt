package com.mottu.marvel

import android.annotation.SuppressLint
import android.content.Context
import android.net.ConnectivityManager
import android.net.Network
import android.net.NetworkCapabilities
import android.net.NetworkRequest
import android.os.Build
import android.os.Handler
import android.os.Looper
import android.provider.Settings
import androidx.core.content.ContextCompat.getSystemService
import io.flutter.plugin.common.EventChannel


open class NetworkConnectivityHandler(context: Context) : EventChannel.StreamHandler {
    private var ctx: Context? = null
    private var connected: Boolean = true
    private var eventSink: EventChannel.EventSink? = null
    private val uiThreadHandler: Handler = Handler(Looper.getMainLooper())
    
    val airplaneModeEnabled: Boolean
        get() {
             return Settings.System.getInt(ctx?.contentResolver,
                Settings.Global.AIRPLANE_MODE_ON, 0) != 0
        }

    fun handleResult(value:Boolean){
        try {
            if (eventSink != null){
                uiThreadHandler.post {
                    try {
                        eventSink.run {
                            eventSink?.success(value && !airplaneModeEnabled)
                        }
                    }catch (ex: RuntimeException){
                        println(ex)
                    }
                }
            }
        }catch (ex: RuntimeException){
            println(ex)
        }

    }

    private val networkCallback = object : ConnectivityManager.NetworkCallback() {
        override fun onAvailable(network: Network) {
            handleResult(true)
            super.onAvailable(network)
        }

        override fun onCapabilitiesChanged(
            network: Network,
            networkCapabilities: NetworkCapabilities
        ) {
            super.onCapabilitiesChanged(network, networkCapabilities)
            connected = !airplaneModeEnabled && networkCapabilities.hasCapability(NetworkCapabilities.NET_CAPABILITY_INTERNET)
                    && (networkCapabilities.hasTransport(NetworkCapabilities.TRANSPORT_WIFI)
                    || networkCapabilities.hasTransport(NetworkCapabilities.TRANSPORT_CELLULAR)
                    || networkCapabilities.hasTransport(NetworkCapabilities.TRANSPORT_ETHERNET))
        }

        override fun onLost(network: Network) {
            handleResult(false)
            super.onLost(network)
        }
    }

    init {
        ctx = context
        val networkRequest = NetworkRequest.Builder()
            .addCapability(NetworkCapabilities.NET_CAPABILITY_INTERNET)
            .addTransportType(NetworkCapabilities.TRANSPORT_WIFI)
            .addTransportType(NetworkCapabilities.TRANSPORT_CELLULAR)
            .build()
        val connectivityManager =
            getSystemService(context, ConnectivityManager::class.java) as ConnectivityManager
        connectivityManager.registerNetworkCallback(networkRequest, networkCallback)
    }

    @SuppressLint("NetworkConnectivity")
    override fun onListen(p0: Any?, sink: EventChannel.EventSink) {
        eventSink = sink
        val connectivityManager =
            ctx?.let { getSystemService(it, ConnectivityManager::class.java) } as ConnectivityManager
        if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.Q) {
            val capabilities =
                connectivityManager.getNetworkCapabilities(connectivityManager.activeNetwork)
            eventSink?.success(!airplaneModeEnabled && capabilities != null && (capabilities.hasTransport(NetworkCapabilities.TRANSPORT_CELLULAR)
                    || capabilities.hasTransport(NetworkCapabilities.TRANSPORT_WIFI)
                    || capabilities.hasTransport(NetworkCapabilities.TRANSPORT_ETHERNET)))
        } else {
            val activeNetworkInfo = connectivityManager.activeNetworkInfo
                eventSink?.success(!airplaneModeEnabled && activeNetworkInfo != null && activeNetworkInfo.isConnected)
            }

    }

    override fun onCancel(p0: Any?) {
        eventSink = null
    }
}