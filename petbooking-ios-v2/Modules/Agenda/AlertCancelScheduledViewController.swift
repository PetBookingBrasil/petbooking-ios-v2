//
//  AlertCancelScheduledViewController.swift
//  petbooking-ios-v2
//
//  Created by Ryniere S Silva on 10/08/17.
//  Copyright © 2017 Pet Booking Serviços e Desenvolvimento de Softwares SA. All rights reserved.
//

import UIKit

class AlertCancelScheduledViewController: UIViewController {
    
    @IBOutlet weak var popupContentContainerView: UIView!
    @IBOutlet weak var backButton: UIButton!
    @IBOutlet weak var cancelScheduledButton: UIButton!
  
    var scheduledService:ScheduledService! = ScheduledService()
    
    weak var delegate:AlertCancelScheduledDelegate?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        cancelScheduledButton.round()
        backButton.round()
        backButton.setBorder(width: 1, color: .white)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    @IBAction func cancelScheduled(_ sender: Any) {
        dismiss(animated: true, completion: nil)
        delegate?.cancelScheduledService(scheduledService: scheduledService)
    }
    
    @IBAction func back(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
}

protocol AlertCancelScheduledDelegate: class {
    func cancelScheduledService(scheduledService:ScheduledService)
}
