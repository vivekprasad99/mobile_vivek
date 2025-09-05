import UIKit
import Flutter
import GoogleMaps
import SFMCSDK
import MarketingCloudSDK
import UserNotifications
import FirebaseCore

@UIApplicationMain
@objc class AppDelegate: FlutterAppDelegate {
    //sfmc configuration
    var appID: String = KeyManager().getValue(key: "MC_APP_ID") as! String;
    var accessToken: String = KeyManager().getValue(key: "MC_ACCESS_TOKEN") as! String;
    var appEndpointURL: String = KeyManager().getValue(key: "MC_SERVER_URL") as! String;
    var mid: String = KeyManager().getValue(key: "MC_MID") as! String;

    // Define features of MobilePush your app will use.
    let analytics = true
    var notificationPayload: [AnyHashable: Any]?

  override func application(
    _ application: UIApplication,
    didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?
  ) -> Bool {

    if launchOptions != nil {
          let controller : FlutterViewController = window?.rootViewController as! FlutterViewController
          let batteryChannel = FlutterMethodChannel(name: "com.example.mfsl/sfmcNotificationSwift",
                                                      binaryMessenger: controller.binaryMessenger)
          batteryChannel.invokeMethod("getIOSsfmcNotification", arguments: ["id": launchOptions])
      }
    GeneratedPluginRegistrant.register(with: self)
    //sfmc config
    self.configureSDK()
        if let APIKEY = KeyManager().getValue(key: "MAPS_API_KEY") as? String {
            GMSServices.provideAPIKey(APIKEY)
        }
    return super.application(application, didFinishLaunchingWithOptions: launchOptions)
  }


  func configureSDK() {
        let appEndpoint = URL(string: appEndpointURL)!

        // Use the Mobile Push Config Builder to configure the Mobile Push Module. This gives you the maximum flexibility in SDK configuration.
        // The builder lets you configure the module parameters at runtime.
        let mobilePushConfiguration = PushConfigBuilder(appId: appID)
            .setAccessToken(accessToken)
            .setMarketingCloudServerUrl(appEndpoint)
            .setMid(mid)
            .setAnalyticsEnabled(analytics)
            .build()

        // Set the completion handler to take action when module initialization is completed. The result indicates if initialization was sucesfull or not.
        // Seting the completion handler is optional.
        let completionHandler: (OperationResult) -> () = { result in
            if result == .success {
                // module is fully configured and ready for use
                self.setupMobilePush()
            } else {
                print("configuration failed.");
            }
        }

        // Once you've created the mobile push configuration, intialize the SDK.
        SFMCSdk.initializeSdk(ConfigBuilder().setPush(config: mobilePushConfiguration, onCompletion: completionHandler).build())
    }

    func setupMobilePush() {
        // Make sure to dispatch this to the main thread, as UNUserNotificationCenter will present UI.
        DispatchQueue.main.async {
            // Set the UNUserNotificationCenterDelegate to a class adhering to thie protocol.
            // In this exmple, the AppDelegate class adheres to the protocol (see below)
            // and handles Notification Center delegate methods from iOS.
            UNUserNotificationCenter.current().delegate = self

            // Request authorization from the user for push notification alerts.
            UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .sound, .badge], completionHandler: {(_ granted: Bool, _ error: Error?) -> Void in
                if error == nil {
                    if granted == true {
                        // Your application may want to do something specific if the user has granted authorization
                        // for the notification types specified; it would be done here.
                    }
                }
            })

            // In any case, your application should register for remote notifications *each time* your application
            // launches to ensure that the push token used by MobilePush (for silent push) is updated if necessary.

            // Registering in this manner does *not* mean that a user will see a notification - it only means
            // that the application will receive a unique push token from iOS.
            UIApplication.shared.registerForRemoteNotifications()
        }
    }


    // MobilePush SDK: REQUIRED IMPLEMENTATION
    override func application(_ application: UIApplication, didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data) {
        SFMCSdk.requestPushSdk { mp in
            mp.setDeviceToken(deviceToken)
        }
    }

    // MobilePush SDK: REQUIRED IMPLEMENTATION
    override func application(_ application: UIApplication, didFailToRegisterForRemoteNotificationsWithError error: Error) {
        print(error)
    }

    // MobilePush SDK: REQUIRED IMPLEMENTATION
    /** This delegate method offers an opportunity for applications with the "remote-notification" background mode to fetch appropriate new data in response to an incoming remote notification. You should call the fetchCompletionHandler as soon as you're finished performing that operation, so the system can accurately estimate its power and data cost.
     This method will be invoked even if the application was launched or resumed because of the remote notification. The respective delegate methods will be invoked first. Note that this behavior is in contrast to application:didReceiveRemoteNotification:, which is not called in those cases, and which will not be invoked if this method is implemented. **/
    override func application(_ application: UIApplication, didReceiveRemoteNotification userInfo: [AnyHashable : Any], fetchCompletionHandler completionHandler: @escaping (UIBackgroundFetchResult) -> Void) {

        SFMCSdk.requestPushSdk { mp in
            mp.setNotificationUserInfo(userInfo)
        }

        completionHandler(.newData)
    }


        // The method will be called on the delegate when the user responded to the notification by opening the application, dismissing the notification or choosing a UNNotificationAction. The delegate must be set before the application returns from applicationDidFinishLaunching:.
    override func userNotificationCenter(_ center: UNUserNotificationCenter, didReceive response: UNNotificationResponse, withCompletionHandler completionHandler: @escaping () -> Void) {

        // Required: tell the MarketingCloudSDK about the notification. This will collect MobilePush analytics
        // and process the notification on behalf of your application.
        SFMCSdk.requestPushSdk { mp in
            mp.setNotificationRequest(response.notification.request)
        }

        completionHandler()
    }

    // The method will be called on the delegate only if the application is in the foreground. If the method is not implemented or the handler is not called in a timely manner then the notification will not be presented. The application can choose to have the notification presented as a sound, badge, alert and/or in the notification list. This decision should be based on whether the information in the notification is otherwise visible to the user.
    override  func userNotificationCenter(_ center: UNUserNotificationCenter, willPresent notification: UNNotification, withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {

        completionHandler(.alert)
    }
}
