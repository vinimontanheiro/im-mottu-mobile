package com.mottu.marvel

import androidx.annotation.NonNull
import io.flutter.embedding.android.FlutterActivity
import io.flutter.embedding.engine.FlutterEngine

class MainActivity: FlutterActivity(){
    override fun configureFlutterEngine(flutterEngine: FlutterEngine) {
        AppEventChannel().setup(flutterEngine, this.context)
        super.configureFlutterEngine(flutterEngine)
    }
}
