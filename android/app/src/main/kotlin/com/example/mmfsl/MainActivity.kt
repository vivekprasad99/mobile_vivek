package com.example.mmfsl

import android.app.Activity
import android.app.admin.DevicePolicyManager
import android.content.ComponentName
import android.content.Context
import android.net.ConnectivityManager
import android.os.Build
import android.util.Log
import androidx.annotation.NonNull
import com.example.check_rooted_device.AppConstants
import io.flutter.embedding.android.FlutterActivity
import io.flutter.embedding.android.FlutterFragmentActivity
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.embedding.engine.plugins.FlutterPlugin
import io.flutter.embedding.engine.plugins.activity.ActivityAware
import io.flutter.embedding.engine.plugins.activity.ActivityPluginBinding
import io.flutter.plugin.common.MethodCall
import io.flutter.plugin.common.MethodChannel
import android.app.PendingIntent
import android.content.Intent
import android.net.Uri
import com.salesforce.marketingcloud.MarketingCloudConfig
import com.salesforce.marketingcloud.notifications.NotificationCustomizationOptions
import com.salesforce.marketingcloud.notifications.NotificationManager
import com.salesforce.marketingcloud.messages.push.PushMessageManager
import com.salesforce.marketingcloud.MCReceiver
import androidx.core.content.ContextCompat.getSystemService
import com.salesforce.marketingcloud.notifications.NotificationMessage
import com.salesforce.marketingcloud.sfmcsdk.InitializationStatus
import com.salesforce.marketingcloud.sfmcsdk.SFMCSdk
import com.salesforce.marketingcloud.sfmcsdk.SFMCSdkModuleConfig
import io.flutter.app.FlutterApplication
import java.util.Random
import android.content.BroadcastReceiver
import androidx.core.app.NotificationCompat
import androidx.core.app.NotificationManagerCompat
import com.salesforce.marketingcloud.messages.inbox.InboxMessage


class MainActivity : FlutterFragmentActivity(), FlutterPlugin, MethodChannel.MethodCallHandler, ActivityAware {

    private val CHANNEL = "is_vpn"
    private val TAG = "SFMC"
    private lateinit var channel: MethodChannel
    private val dualAppId999 = "999"
    private val dot = '.'
    private var myActivity: Activity? = null


    override fun configureFlutterEngine(@NonNull flutterEngine: FlutterEngine) {
        super.configureFlutterEngine(flutterEngine)
        MethodChannel(flutterEngine.dartExecutor.binaryMessenger, CHANNEL)
            .setMethodCallHandler { call: MethodCall, result: MethodChannel.Result ->
                if (call.method == "isVpnConnected") {
                    val isConnected = isVpnConnected()
                    result.success(isConnected)
                } else {
                    result.notImplemented()
                }
            }
            configureSFMC()
    }

    private fun isVpnConnected(): Boolean {
        val connectivityManager = getSystemService(Context.CONNECTIVITY_SERVICE) as ConnectivityManager
        return if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.Q) {
            val vpnNetwork = connectivityManager.activeNetwork
            vpnNetwork != null
        } else {
            // VPN detection for older Android versions
            // Implement your own logic here, as it varies depending on the VPN setup
            false
        }
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


    override fun onMethodCall(call: MethodCall, result: MethodChannel.Result) {
        when (call.method) {

            AppConstants.getPlatformVersion -> {
                result.success("Android ${android.os.Build.VERSION.RELEASE}")
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

                    if (getDotCount(path, appPackageDotCount)>appPackageDotCount) {
                        ///"Package Mismatch"
                        ///"Cloned App"
                        isValidApp = false
                        Log.d("AppCloneCheckerPlugin","Package ID Mismatch")
                    } else if (path.contains(dualAppId999)) {
                        ///"Package Directory Mismatch"
                        ///"Cloned App"
                        isValidApp = false
                        Log.d("AppCloneCheckerPlugin","Package Mismatch")
                    } else if (!workProfileAllowedFlag && activeAdmins != null) {
                        ///"Used through Work Profile"
                        ///"Cloned App"
                        val gmsPackages = activeAdmins.filter { filter -> filter.packageName == "com.google.android.gms" }
                        val samsungDevice = activeAdmins.any { filter -> filter.packageName.contains("com.samsung") }

                        if(samsungDevice){
                            activeAdmins.forEach { admin ->
                                if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.LOLLIPOP) {
                                    if (devicePolicyManager.isProfileOwnerApp(admin.packageName)) {
                                        isValidApp = false
                                    }
                                }
                            }
                        }else{
                            if (gmsPackages.size != activeAdmins.size) {
                                Log.d("AppCloneCheckerPlugin", "Work Mode")
                                isValidApp = false
                            } else {

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
            else -> {
                result.notImplemented()
            }
        }
    }

    private fun configureSFMC() {
        SFMCSdk.configure(applicationContext, SFMCSdkModuleConfig.build {
            pushModuleConfig = MarketingCloudConfig.builder().apply {
                setApplicationId(BuildConfig.MC_APP_ID)
                setAccessToken(BuildConfig.MC_ACCESS_TOKEN)
                setMarketingCloudServerUrl(BuildConfig.MC_SERVER_URL)
                setSenderId(BuildConfig.MC_SENDER_ID)
                setAnalyticsEnabled(true)
                setNotificationCustomizationOptions(
                    NotificationCustomizationOptions.create { context, notificationMessage ->
                        val builder = NotificationManager.getDefaultNotificationBuilder(
                            context,
                            notificationMessage,
                            NotificationManager.createDefaultNotificationChannel(context),
                            R.mipmap.ic_launcher
                        )
                        builder.setContentIntent(
                            NotificationManager.redirectIntentForAnalytics(
                                context,
                                getPendingIntent(context, notificationMessage),
                                notificationMessage,
                                true
                            )
                        )
                        builder
                    }
                )
            }.build(applicationContext)
        }) { initStatus ->
            when (initStatus.status) {
                InitializationStatus.SUCCESS -> Log.d(TAG, "SFMC SDK Initialization Successful")
                InitializationStatus.FAILURE -> Log.d(TAG, "SFMC SDK Initialization Failed")
                else -> Log.d(TAG, "SFMC SDK Initialization Status: Unknown")
            }
        }
    }

private fun getPendingIntent(
        context: Context,
        notificationMessage: NotificationMessage
    ): PendingIntent {
        Log.d(TAG, notificationMessage.payload.toString())
        val intent = if (notificationMessage.url.isNullOrEmpty()) {
            context.packageManager.getLaunchIntentForPackage(context.packageName)
        } else {
            Intent(Intent.ACTION_VIEW, Uri.parse(notificationMessage.url))
        }
        return PendingIntent.getActivity(context, Random().nextInt(), intent, provideIntentFlags())
    }
    private fun provideIntentFlags(): Int {
        return if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.S) {
            PendingIntent.FLAG_UPDATE_CURRENT or PendingIntent.FLAG_IMMUTABLE
        } else {
            PendingIntent.FLAG_UPDATE_CURRENT
        }
    }

    override fun onAttachedToActivity(binding: ActivityPluginBinding) {
        this.myActivity = binding.activity
    }

    override fun onDetachedFromActivityForConfigChanges() {
        this.myActivity = null
    }

    override fun onReattachedToActivityForConfigChanges(binding: ActivityPluginBinding) {
        this.myActivity = binding.activity
    }

    override fun onDetachedFromActivity() {
        TODO("Not yet implemented")
    }

    override fun onAttachedToEngine(binding: FlutterPlugin.FlutterPluginBinding) {
        channel = MethodChannel(binding.binaryMessenger, "app_clone_checker")
        channel.setMethodCallHandler(this)
    }

    override fun onDetachedFromEngine(binding: FlutterPlugin.FlutterPluginBinding) {
        this.myActivity = null
    }


}
