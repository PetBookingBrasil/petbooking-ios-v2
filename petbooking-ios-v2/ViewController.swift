//
//  ViewController.swift
//  petbooking-ios-v2
//
//  Created by Ryniere S Silva on 10/04/17.
//  Copyright © 2017 Pet Booking Serviços e Desenvolvimento de Softwares SA. All rights reserved.
//

import UIKit
import PINRemoteImage
import SideMenu

class ViewController: UIViewController {

	@IBOutlet weak var imageView: UIImageView!
	@IBOutlet weak var nameLabel: UILabel!
	
	override func viewDidLoad() {
		super.viewDidLoad()
		// Do any additional setup after loading the view, typically from a nib.
		
		// Define the menus
		let menuLeftNavigationController = UISideMenuNavigationController(rootViewController: SideMenuRouter.createModule())
		menuLeftNavigationController.leftSide = true
		// UISideMenuNavigationController is a subclass of UINavigationController, so do any additional configuration
		// of it here like setting its viewControllers. If you're using storyboards, you'll want to do something like:
		// let menuLeftNavigationController = storyboard!.instantiateViewController(withIdentifier: "LeftMenuNavigationController") as! UISideMenuNavigationController
		SideMenuManager.menuLeftNavigationController = menuLeftNavigationController
		
		// Enable gestures. The left and/or right menus must be set up above for these to work.
		// Note that these continue to work on the Navigation Controller independent of the view controller it displays!
		SideMenuManager.menuAddPanGestureToPresent(toView: self.navigationController!.navigationBar)
		SideMenuManager.menuAddScreenEdgePanGesturesToPresent(toView: self.navigationController!.view)
		SideMenuManager.menuAnimationBackgroundColor = UIColor.clear
		SideMenuManager.menuShadowRadius = 0
		SideMenuManager.menuShadowOpacity = 0
		SideMenuManager.menuPushStyle = .replace
		
		navigationItem.leftBarButtonItem = UIBarButtonItem(image: UIImage(named:"menu"), style: .plain, target: self, action: #selector(showLeftMenu))
		
		
	}
	
	override func viewWillAppear(_ animated: Bool) {
		super.viewWillAppear(animated)
		
		
		PetbookingAPI.sharedInstance.userInfo { (user, message) in
			
			if let currentUser = user {
				
				self.nameLabel.text = currentUser.name
				
				if currentUser.avatarUrlThumb.contains("http") {
					if let url = URL(string: currentUser.avatarUrlThumb) {
						self.imageView.pin_setImage(from: url)
					}
				} else {
					if let url = URL(string: "https://cdn.petbooking.com.br/\(currentUser.avatarUrlThumb)") {
						self.imageView.pin_setImage(from: url)
					}
				}

			}
		}
	}

	override func didReceiveMemoryWarning() {
		super.didReceiveMemoryWarning()
		// Dispose of any resources that can be recreated.
	}

	@IBAction func logout(_ sender: Any) {
		
		UserManager.sharedInstance.logOut()
		
		self.present(PresentationRouter.createFirstModule(), animated: true, completion: nil)
	}
	
	func showLeftMenu() {
		present(SideMenuManager.menuLeftNavigationController!, animated: true, completion: nil)
	}

}

