package com.example.myapp

import android.content.Intent
import android.content.pm.PackageManager
import android.os.Bundle
import io.flutter.embedding.android.FlutterActivity
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.plugin.common.MethodChannel

class MainActivity: FlutterActivity() {
    private val CHANNEL = "com.example.myapp/openApp"

    override fun configureFlutterEngine(flutterEngine: FlutterEngine) {
        super.configureFlutterEngine(flutterEngine)
        MethodChannel(flutterEngine.dartExecutor.binaryMessenger, CHANNEL).setMethodCallHandler { call, result ->
            if (call.method == "openApp") {
                val packageName = call.argument<String>("packageName")
                if (packageName != null) {
                    try {
                        val launchIntent: Intent? = packageManager.getLaunchIntentForPackage(packageName)
                        if (launchIntent != null) {
                            startActivity(launchIntent)
                            result.success(true)
                        } else {
                            result.success(false)
                        }
                    } catch (e: Exception) {
                        result.error("UNAVAILABLE", "Failed to open app: ${e.message}", null)
                    }
                } else {
                    result.error("INVALID_ARGUMENT", "Package name is required", null)
                }
            } else {
                result.notImplemented()
            }
        }
    }
}
