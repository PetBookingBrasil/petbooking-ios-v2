//
//  ViewController.swift
//  petbooking-ios-v2
//
//  Created by Ryniere S Silva on 10/04/17.
//  Copyright © 2017 Pet Booking Serviços e Desenvolvimento de Softwares SA. All rights reserved.
//

import UIKit
import PINRemoteImage

class ViewController: UIViewController {

	@IBOutlet weak var imageView: UIImageView!
	@IBOutlet weak var nameLabel: UILabel!
	
	override func viewDidLoad() {
		super.viewDidLoad()
		// Do any additional setup after loading the view, typically from a nib.
		
		
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

}

