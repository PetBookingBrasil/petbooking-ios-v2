//
//  AppDelegate.swift
//  petbooking-ios-v2
//
//  Created by Ryniere S Silva on 10/04/17.
//  Copyright © 2017 Pet Booking Serviços e Desenvolvimento de Softwares SA. All rights reserved.
//

import UIKit
import FacebookCore
import UserNotifications
import RealmSwift
import Fabric
import Crashlytics
import MarketingCloudSDK

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
    
    var window: UIWindow?
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        SDKApplicationDelegate.shared.application(application, didFinishLaunchingWithOptions: launchOptions)
        Fabric.with([Crashlytics.self])
        
        UINavigationBar.appearance().isTranslucent = false
        UINavigationBar.appearance().barTintColor =  UIColor(hex: "E4002B")
        UINavigationBar.appearance().tintColor = .white
        UINavigationBar.appearance().titleTextAttributes = [NSAttributedStringKey.foregroundColor:UIColor.white]
        UINavigationBar.appearance().setBackgroundImage(UIImage(),
                                                        for: .any,
                                                        barMetrics: .default)
        UINavigationBar.appearance().shadowImage = UIImage()
        UIBarButtonItem.appearance().setBackButtonTitlePositionAdjustment(UIOffsetMake(0, -80.0), for: .default)
        
        
        var backButtonImage = UIImage(named: "back_icon")
        backButtonImage = backButtonImage?.stretchableImage(withLeftCapWidth: 22, topCapHeight: 14)
        UIBarButtonItem.appearance().setBackButtonBackgroundImage(backButtonImage, for: .normal, barMetrics: .default)
        
        PetbookingAPI.sharedInstance.getConsumer { (success, message) in }
        
        if #available(iOS 10.0, *) {
            let center = UNUserNotificationCenter.current()
            center.requestAuthorization(options:[.badge, .alert, .sound]) { (granted, error) in
                guard error == nil else { return }
                
                if granted {
                    DispatchQueue.main.async {
                        application.registerForRemoteNotifications()
                    }
                }
            }
            
        } else {
            let settings = UIUserNotificationSettings(types: [.alert, .badge, .sound], categories: nil)
            application.registerUserNotificationSettings(settings)
            application.registerForRemoteNotifications()
        }
        
        let config = Realm.Configuration(schemaVersion: 2, migrationBlock: { migration, oldSchemaVersion in
            if (oldSchemaVersion < 1) { }
        })
        
        // Tell Realm to use this new configuration object for the default Realm
        Realm.Configuration.defaultConfiguration = config
        
        if let _ = SessionManager.sharedInstance.getCurrentSession() {
            let viewController = HomeContentViewControllerRouter.createModule()
            self.window?.rootViewController = UINavigationController(rootViewController: viewController)
        } else {
            self.window?.rootViewController = PresentationPageViewController()
        }
        
        self.window?.makeKeyAndVisible()
        
        return true
    }
    
    func application(_ app: UIApplication, open url: URL, options: [UIApplicationOpenURLOptionsKey : Any] = [:]) -> Bool {
        return SDKApplicationDelegate.shared.application(app, open:url, options:options)
    }
}

extension AppDelegate: UNUserNotificationCenterDelegate {
    
    func application(_ application: UIApplication, didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data) {
        let token = deviceToken.map { String(format: "%02.2hhx", $0) }.joined()
        print("DEVICE TOKEN = \(token)")
        
        MarketingCloudSDK.sharedInstance().sfmc_setDeviceToken(deviceToken)
        
        UserManager.sharedInstance.saveAPNSToken(tokenValue: token)
    }
    
    func userNotificationCenter(_ center: UNUserNotificationCenter, didReceive response: UNNotificationResponse, withCompletionHandler completionHandler: @escaping () -> Void) {
        
        MarketingCloudSDK.sharedInstance().sfmc_setNotificationRequest(response.notification.request)
        
        completionHandler()
    }
    
    func application(_ application: UIApplication, didReceiveRemoteNotification userInfo: [AnyHashable : Any], fetchCompletionHandler completionHandler: @escaping (UIBackgroundFetchResult) -> Void) {
        let theSilentPushContent = UNMutableNotificationContent()
        theSilentPushContent.userInfo = userInfo
        let theSilentPushRequest = UNNotificationRequest(identifier:UUID().uuidString, content: theSilentPushContent, trigger: nil)
        MarketingCloudSDK.sharedInstance().sfmc_setNotificationRequest(theSilentPushRequest)
        
        completionHandler(.newData)
    }
}

