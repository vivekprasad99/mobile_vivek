package com.mmsfl.plugings.app_launch_check

import android.app.Activity
import android.app.admin.DevicePolicyManager
import android.content.ComponentName
import android.content.Context
import android.os.Build
import android.os.Bundle
import android.os.PersistableBundle
import android.util.Log
import android.view.WindowManager
import androidx.annotation.NonNull
import androidx.annotation.RequiresApi
import io.flutter.embedding.android.FlutterActivity

import io.flutter.embedding.engine.plugins.FlutterPlugin
import io.flutter.embedding.engine.plugins.activity.ActivityAware
import io.flutter.embedding.engine.plugins.activity.ActivityPluginBinding
import io.flutter.plugin.common.MethodCall
import io.flutter.plugin.common.MethodChannel
import io.flutter.plugin.common.MethodChannel.MethodCallHandler
import io.flutter.plugin.common.MethodChannel.Result

/** AppLaunchCheckPlugin */
class AppLaunchCheckPlugin : FlutterActivity(), FlutterPlugin, MethodCallHandler, ActivityAware {
    private lateinit var channel: MethodChannel

    private var myActivity: Activity? = null
    private val dualAppId999 = "999"
    private val dot = '.'


    @RequiresApi(Build.VERSION_CODES.LOLLIPOP)
    override fun onAttachedToEngine(flutterPluginBinding: FlutterPlugin.FlutterPluginBinding) {
        channel = MethodChannel(flutterPluginBinding.binaryMessenger, "app_launch_check")
        channel.setMethodCallHandler(this)
    }

    @RequiresApi(Build.VERSION_CODES.LOLLIPOP)
    override fun onMethodCall(call: MethodCall, result: Result) {
        when (call.method) {
            "getPlatformVersion" -> {
                result.success("Android ${Build.VERSION.RELEASE}")
            }

            AppConstants.checkDeviceCloned -> {

                val resultMap = mutableMapOf<String, String>()

                var isValidApp = true
                val applicationID = call.argument<String>(AppConstants.applicationID) ?: ""

                val workProfileAllowedFlag: Boolean =
                    call.argument<Boolean>(AppConstants.workProfileAllowedFlag) ?: true

                if (applicationID.isBlank() || applicationID.isEmpty()) {
                    resultMap[AppConstants.responseResultKey] = AppConstants.failureID
                    resultMap[AppConstants.responseMessageKey] = AppConstants.failureAppIdMessage
                    result.success(resultMap.toMap())
                    return
                }

                myActivity?.let {

                    val path: String = it.filesDir.path
                    //This will detect if app is accessed through Work Profile
                    val devicePolicyManager =
                        myActivity?.getSystemService(Context.DEVICE_POLICY_SERVICE) as DevicePolicyManager
                    val activeAdmins: List<ComponentName>? = devicePolicyManager.activeAdmins
                    val appPackageDotCount = applicationID.count { it == '.' }

                    if (getDotCount(path, appPackageDotCount) > appPackageDotCount) {
                        ///"Package Mismatch"
                        ///"Cloned App"
                        isValidApp = false
                        Log.d("AppCloneCheckerPlugin", "Package ID Mismatch")
                    } else if (path.contains(dualAppId999)) {
                        ///"Package Directory Mismatch"
                        ///"Cloned App"
                        isValidApp = false
                        Log.d("AppCloneCheckerPlugin", "Package Mismatch")
                    } else if (!workProfileAllowedFlag && activeAdmins != null) {
                        ///"Used through Work Profile"
                        ///"Cloned App"
                        val gmsPackages =
                            activeAdmins.filter { filter -> filter.packageName == "com.google.android.gms" }
                        val samsungDevice =
                            activeAdmins.any { filter -> filter.packageName.contains("com.samsung") }

                        if (samsungDevice) {
                            activeAdmins.forEach { admin ->
                                if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.LOLLIPOP) {
                                    if (devicePolicyManager.isProfileOwnerApp(admin.packageName)) {
                                        isValidApp = false
                                    }
                                }
                            }
                        } else {
                            if (gmsPackages.size != activeAdmins.size) {
                                Log.d("AppCloneCheckerPlugin", "Work Mode")
                                isValidApp = false
                            } else {
//                                isValidApp = false
                            }
                        }
                    } else {

                    }

                }


                if (myActivity != null && isValidApp) {
                    resultMap[AppConstants.responseResultKey] = AppConstants.successID
                    resultMap[AppConstants.responseMessageKey] = AppConstants.successMessage
                    result.success(resultMap.toMap())
                } else {
                    resultMap[AppConstants.responseResultKey] = AppConstants.failureID
                    resultMap[AppConstants.responseMessageKey] = AppConstants.failureMessage
                    result.success(resultMap.toMap())
                }

            }


//

            else -> {
                result.notImplemented()
            }
        }
    }

    override fun onCreate(savedInstanceState: Bundle?, persistentState: PersistableBundle?) {
        super.onCreate(savedInstanceState, persistentState)
        window.setFlags(
            WindowManager.LayoutParams.FLAG_SECURE, WindowManager.LayoutParams.FLAG_SECURE
        )
    }

    override fun onDetachedFromEngine(@NonNull binding: FlutterPlugin.FlutterPluginBinding) {
        channel.setMethodCallHandler(null)
    }


    @RequiresApi(Build.VERSION_CODES.LOLLIPOP)
    override fun onAttachedToActivity(binding: ActivityPluginBinding) {
        this.myActivity = binding.activity
    }

    @RequiresApi(Build.VERSION_CODES.LOLLIPOP)
    override fun onDetachedFromActivityForConfigChanges() {
        this.myActivity = null
    }

    @RequiresApi(Build.VERSION_CODES.LOLLIPOP)
    override fun onReattachedToActivityForConfigChanges(binding: ActivityPluginBinding) {
        this.myActivity = binding.activity

    }

    override fun onDetachedFromActivity() {
        this.myActivity = null
    }

    private fun getDotCount(path: String, appPackageDotCount: Int): Int {
        var count = 0
        for (element in path) {
            if (count > appPackageDotCount) {
                break
            }
            if (element == dot) {
                count++
            }
        }
        return count
    }

}
