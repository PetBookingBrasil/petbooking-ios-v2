//
//  ReviewViewController.swift
//  petbooking-ios-v2
//
//  Created by David Batista on 20/04/2018.
//  Copyright © 2018 Pet Booking Serviços e Desenvolvimento de Softwares SA. All rights reserved.
//

import UIKit

class ReviewViewController: UIViewController, ReviewViewProtocol {
    
    var presenter: ReviewPresenterProtocol?
    
    // MARK: Outlet
    @IBOutlet weak var petImageView: UIImageView!
    @IBOutlet weak var petNameLabel: UILabel!
    @IBOutlet weak var serviceImageView: UIImageView!
    @IBOutlet weak var serviceNameLabel: UILabel!
    @IBOutlet weak var serviceDateLabel: UILabel!
    @IBOutlet weak var businessesImageView: UIImageView!
    @IBOutlet weak var businessesNameLabel: UILabel!
    @IBOutlet weak var employmentImageView: UIImageView!
    @IBOutlet weak var employmentNameLabel: UILabel!
    @IBOutlet weak var employmentDescriptionLabel: UILabel!
    @IBOutlet weak var commentTextView: UITextView!

    override func viewDidLoad() {
        super.viewDidLoad()
        
//        setuptOutlets()
    }
    
    func setuptOutlets() {
      
        petImageView.round()
        serviceImageView.round()
        businessesImageView.round()
        employmentImageView.round()
        
        commentTextView.setBorder(width: 1, color: UIColor.init(hex: "515151"))
    }

    @IBAction func sendButtonTapped() {
        
    }
}

extension ReviewViewController: UITextViewDelegate {
    
}
