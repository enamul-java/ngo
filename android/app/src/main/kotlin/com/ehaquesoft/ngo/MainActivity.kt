package com.ehaquesoft.ngo

import android.app.Activity
import io.flutter.embedding.android.FlutterActivity

import android.os.BatteryManager
import android.content.Context
import android.content.Intent
import android.os.Build
import android.os.Bundle
import androidx.activity.result.ActivityResultLauncher
import androidx.activity.result.contract.ActivityResultContracts
import io.flutter.embedding.android.FlutterFragmentActivity
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.plugin.common.EventChannel
import io.flutter.plugin.common.MethodChannel

class MainActivity : FlutterFragmentActivity() {

    private val CHANNEL = "com.ehaquesoft.ngo/native"
    private val EVENT_CHANNEL = "com.ehaquesoft.ngo/events"

    private lateinit var nativeActivityLauncher: ActivityResultLauncher<Intent>
    private var pendingResult: MethodChannel.Result? = null

    private lateinit var nativeActivityLauncher2: ActivityResultLauncher<Intent>
    private var pendingResult2: MethodChannel.Result? = null

    override fun onCreate(savedInstanceState: Bundle?) {
        super.onCreate(savedInstanceState)

        registerActivity()
        registerActivity2()
    }

    fun registerActivity(){
        nativeActivityLauncher =
            registerForActivityResult(
                ActivityResultContracts.StartActivityForResult()
            ) { activityResult ->

                val result = pendingResult
                pendingResult = null

                if (result == null) {
                    return@registerForActivityResult
                }

                if (activityResult.resultCode == Activity.RESULT_OK) {

                    val data = activityResult.data

                    val value =
                        data?.getStringExtra("message")

                    result.success(value)

                } else {

                    result.error(
                        "CANCELLED",
                        "Native Activity was cancelled",
                        null
                    )
                }
            }
    }

    fun registerActivity2(){
        nativeActivityLauncher2 =
            registerForActivityResult(
                ActivityResultContracts.StartActivityForResult()
            ) { activityResult ->

                val result = pendingResult2
                pendingResult2 = null

                if (result == null) {
                    return@registerForActivityResult
                }

                if (activityResult.resultCode == Activity.RESULT_OK) {

                    val data = activityResult.data

                    val value =
                        data?.getStringExtra("message")

                    result.success(value)

                } else {

                    result.error(
                        "CANCELLED",
                        "Native Activity was cancelled",
                        null
                    )
                }
            }
    }


    override fun configureFlutterEngine(flutterEngine: FlutterEngine) {
        super.configureFlutterEngine(flutterEngine)

        EventChannel(
            flutterEngine.dartExecutor.binaryMessenger,
            EVENT_CHANNEL
        ).setStreamHandler(
            object : EventChannel.StreamHandler {

                override fun onListen(
                    arguments: Any?,
                    events: EventChannel.EventSink?
                ) {

                    events?.success("Event from Android")
                }

                override fun onCancel(
                    arguments: Any?
                ) {
                }
            }
        )


        MethodChannel(flutterEngine.dartExecutor.binaryMessenger,CHANNEL)
            .setMethodCallHandler { call, result ->
            when (call.method) {
                "openNativeActivity" -> {
                    val message = call.argument<String>("message")
                    pendingResult = result
                    val intent = Intent(
                        this,
                        ActivityForResult::class.java
                    ).apply {
                        putExtra(
                            "message",
                            message
                        )
                    }
                    nativeActivityLauncher.launch(intent)
                }

                "openNativeActivity2" -> {
                    val message = call.argument<String>("message")
                    pendingResult2 = result
                    val intent = Intent(
                        this,
                        ActivityForResult::class.java
                    ).apply {
                        putExtra(
                            "message",
                            message
                        )
                    }
                    nativeActivityLauncher2.launch(intent)
                }

                "getBatteryLevel" -> {
                    val batteryManager =
                        getSystemService(Context.BATTERY_SERVICE)
                                as BatteryManager
                    val batteryLevel =
                        batteryManager.getIntProperty(
                            BatteryManager.BATTERY_PROPERTY_CAPACITY
                        )
                    result.success(batteryLevel)
                }

                "getDeviceInfo" -> {
                    var deviceInfo:String =
                                " Manufacturer: " + Build.MANUFACTURER +
                                " Device Model: " + Build.MODEL
                                "   OS Version: " + Build.VERSION.SDK_INT
                    result.success(deviceInfo)
                }

                "sendSingleValue" -> {
                    // Extract a single value directly
                    val message = call.arguments as? String
                    println("Received single value: $message")
                    result.success("Success")
                }
                "sendMultipleValues" -> {
                    // Extract values from a Map/Dictionary structure
                    val userId = call.argument<Int>("userId")
                    val username = call.argument<String>("username")
                    val isPremium = call.argument<Boolean>("isPremium")

                    println("Received: $userId, $username, $isPremium")
                    result.success("Received: $userId, $username, $isPremium, Thank you for your feedback")
                }

                else -> {
                    result.notImplemented()
                }
            }
        }
    }
}
