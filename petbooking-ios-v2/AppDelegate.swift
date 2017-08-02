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


@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

	var window: UIWindow?

	func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
		// Override point for customization after application launch.
		
		SDKApplicationDelegate.shared.application(application, didFinishLaunchingWithOptions: launchOptions)
		
		UINavigationBar.appearance().isTranslucent = false
		UINavigationBar.appearance().barTintColor =  UIColor(hex: "E4002B")
		UINavigationBar.appearance().tintColor = .white
		UINavigationBar.appearance().titleTextAttributes = [NSForegroundColorAttributeName:UIColor.white]
		UINavigationBar.appearance().setBackgroundImage(
			UIImage(),
			for: .any,
			barMetrics: .default)
		UINavigationBar.appearance().shadowImage = UIImage()
		UIBarButtonItem.appearance().setBackButtonTitlePositionAdjustment(UIOffsetMake(0, -80.0), for: .default)
		
		
		var backButtonImage = UIImage(named: "back_icon")
		backButtonImage = backButtonImage?.stretchableImage(withLeftCapWidth: 22, topCapHeight: 14)
		UIBarButtonItem.appearance().setBackButtonBackgroundImage(backButtonImage, for: .normal, barMetrics: .default)
		
		PetbookingAPI.sharedInstance.getConsumer { (success, message) in
			
		}
		
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

	func applicationWillResignActive(_ application: UIApplication) {
		// Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
		// Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
	}

	func applicationDidEnterBackground(_ application: UIApplication) {
		// Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
		// If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
	}

	func applicationWillEnterForeground(_ application: UIApplication) {
		// Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
	}

	func applicationDidBecomeActive(_ application: UIApplication) {
		// Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
	}

	func applicationWillTerminate(_ application: UIApplication) {
		// Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
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

