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


@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
	
	var window: UIWindow?
	
	func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
		SDKApplicationDelegate.shared.application(application, didFinishLaunchingWithOptions: launchOptions)
		
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
				// Enable or disable features based on authorization.
				guard error == nil else {
					//Display Error.. Handle Error.. etc..
					return
				}
				
				if granted {
					application.registerForRemoteNotifications()
				}
			}
			application.registerForRemoteNotifications()
			
		} else {
			// Fallback on earlier versions
			let settings = UIUserNotificationSettings(types: [.alert, .badge, .sound], categories: nil)
			application.registerUserNotificationSettings(settings)
			application.registerForRemoteNotifications()
		}
		
		let config = Realm.Configuration(
			// Set the new schema version. This must be greater than the previously used
			// version (if you've never set a schema version before, the version is 0).
			schemaVersion: 2,
			
			// Set the block which will be called automatically when opening a Realm with
			// a schema version lower than the one set above
			migrationBlock: { migration, oldSchemaVersion in
		// We haven’t migrated anything yet, so oldSchemaVersion == 0
		if (oldSchemaVersion < 1) {
		// Nothing to do!
		// Realm will automatically detect new properties and removed properties
		// And will update the schema on disk automatically
		}
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
		
	func application(_ application: UIApplication, didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data) {
		let token = deviceToken.map { String(format: "%02.2hhx", $0) }.joined()
		print("DEVICE TOKEN = \(token)")
		
		UserManager.sharedInstance.saveAPNSToken(tokenValue: token)
	}
	
	func application(_ application: UIApplication, didFailToRegisterForRemoteNotificationsWithError error: Error) {
		print(error)
	}
	
	func application(_ application: UIApplication, didReceiveRemoteNotification userInfo: [AnyHashable : Any]) {
		print(userInfo)
	}
}

