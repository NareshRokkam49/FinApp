package com.example.flutter_task

import android.bluetooth.BluetoothAdapter
import android.content.Intent
import io.flutter.embedding.android.FlutterActivity
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.plugin.common.MethodChannel

class MainActivity : FlutterActivity() {
    private val CHANNEL = "bluetooth_channel"

    override fun configureFlutterEngine(flutterEngine: FlutterEngine) {
        super.configureFlutterEngine(flutterEngine)
        MethodChannel(flutterEngine.dartExecutor.binaryMessenger, CHANNEL).setMethodCallHandler { call, result ->
            if (call.method == "enableBluetooth") {
                val bluetoothAdapter = BluetoothAdapter.getDefaultAdapter()
                if (bluetoothAdapter != null && !bluetoothAdapter.isEnabled) {
                    val enableBtIntent = Intent(BluetoothAdapter.ACTION_REQUEST_ENABLE)
                    startActivity(enableBtIntent)
                }
                result.success(null)
            } else {
                result.notImplemented()
            }
        }
    }
}
