//
//  ScheduleToTheCartAlertViewController.swift
//  petbooking-ios-v2
//
//  Created by Ryniere S Silva on 02/11/17.
//  Copyright © 2017 Pet Booking Serviços e Desenvolvimento de Softwares SA. All rights reserved.
//

import UIKit

class ScheduleToTheCartAlertViewController: UIViewController {

	@IBOutlet weak var titleLabel: UILabel!
	@IBOutlet weak var scheduleMoreButton: UIButton!
	@IBOutlet weak var goToCartButton: UIButton!
	
	weak var delegate:ScheduleToTheCartAlertDelegate?
	
	override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
		goToCartButton.round()
		scheduleMoreButton.round()
		scheduleMoreButton.setBorder(width: 1, color: .white)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
	@IBAction func scheduleMore(_ sender: Any) {
		dismiss(animated: true, completion: nil)
		delegate?.scheduleMore()
	}
	
	@IBAction func goToCart(_ sender: Any) {
		dismiss(animated: false, completion: nil)
		delegate?.goToCart()
	}
	


}

protocol ScheduleToTheCartAlertDelegate: class {
	
	
	func goToCart()
	
	func scheduleMore()
	
	
}
