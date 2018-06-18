//
//  ReviewViewController.swift
//  petbooking-ios-v2
//
//  Created by David Batista on 07/04/2018.
//  Copyright © 2018 Pet Booking Serviços e Desenvolvimento de Softwares SA. All rights reserved.
//

import UIKit
import ALLoadingView

class ReviewViewController: UIViewController, ReviewViewProtocol {    
    
    // MARK: Variables
    var reviewList: ReviewableList?
    var presenter: ReviewPresenterProtocol?
    
    //
    var review: Reviewable?
    
    // MARK: Outlets
    @IBOutlet weak var containerView: UIView!
    
    @IBOutlet weak var petImageView: UIImageView!
    @IBOutlet weak var petNameLabel: UILabel!
    
    @IBOutlet weak var serviceImaveView: UIImageView!
    @IBOutlet weak var serviceNameLabel: UILabel!
    @IBOutlet weak var serviceDateLabel: UILabel!
    
    @IBOutlet weak var businessImageView: UIImageView!
    @IBOutlet weak var businessNameLabel: UILabel!
    
    @IBOutlet weak var professionalImaveView: UIImageView!
    @IBOutlet weak var professionalNameLabel: UILabel!
    
    @IBOutlet weak var comentTextView: UITextView!
    
    @IBOutlet weak var sendButton: UIButton!
    
    // MARK: Stars Buttons
    var attendanceStar = 0
    @IBOutlet weak var attendanceOneButton: UIButton!
    @IBOutlet weak var attendanceTwoButton: UIButton!
    @IBOutlet weak var attendanceThreeButton: UIButton!
    @IBOutlet weak var attendanceFourButton: UIButton!
    @IBOutlet weak var attendanceFiveButton: UIButton!
    
    var serviceStar = 0
    @IBOutlet weak var serviceOneButton: UIButton!
    @IBOutlet weak var serviceTwoButton: UIButton!
    @IBOutlet weak var serviceThreeButton: UIButton!
    @IBOutlet weak var serviceFourButton: UIButton!
    @IBOutlet weak var serviceFiveButton: UIButton!
    
    var environmentStar = 0
    @IBOutlet weak var environmentOneButton: UIButton!
    @IBOutlet weak var environmentTwoButton: UIButton!
    @IBOutlet weak var environmentThreeButton: UIButton!
    @IBOutlet weak var environmentFourButton: UIButton!
    @IBOutlet weak var environmentFiveButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupView()
    }

    func setupView() {
        review = reviewList?.reviewables.removeLast()
        
        containerView.layer.cornerRadius = 10
        containerView.layer.masksToBounds = true
        
        comentTextView.delegate = self
        petImageView.round()
        serviceImaveView.round()
        businessImageView.round()
        professionalImaveView.round()
        
        comentTextView.setBorder(width: 1, color: .lightGray)
        
        if let included = reviewList?.included {
            renderPet(review!.petId, in: included)
            renderService(review!.serviceId, in: included)
            renderBusiness(review!.businessId, in: included)
            renderEmployment(review!.employmentId, in: included)
        }
        
        sendButton.round()
    }

    func renderPet(_ petId: Int, in includeds: [Included]) {
        for pet in includeds where pet.id == String(petId) {
            if pet.type == "pets" {
                petNameLabel.text = pet.name
                
                if pet.kind == "dog" {
                    petImageView.image = UIImage(named:"avatar-padrao-cachorro")
                } else {
                    petImageView.image = UIImage(named:"avatar-padrao-gato")
                }
                
                if pet.photo.contains("http") {
                    if let url = URL(string: pet.photo) {
                        petImageView.pin_setImage(from: url)
                    }
                } else {
                    if let url = URL(string: "https://cdn.petbooking.com.br\(pet.photo)") {
                        petImageView.pin_setImage(from: url)
                    }
                }
            }
        }
    }
    
    func renderService(_ serviceId: String, in includeds: [Included]) {
        serviceNameLabel.text = review?.serviceName
        serviceDateLabel.text = review?.date

        for service in includeds where service.id == serviceId {
            if service.type == "services" {
                for category in includeds where category.id == service.categoryId {
                    if category.type == "service_categories" {
                        serviceImaveView.image = UIImage(named: "\(category.slug)-mini")
                    }
                }
            }
        }
    }
    
    func renderBusiness(_ businessId: String, in includeds: [Included]) {
        for business in includeds where business.id == businessId {
            if business.type == "businesses" {
                businessNameLabel.text = business.name
            }
        }
    }
    
    func renderEmployment(_ employmentId: String, in includeds: [Included]) {
        for employment in includeds where employment.id == employmentId {
            if employment.type == "employments" {
                professionalNameLabel.text = employment.name
                
                if employment.avatar.contains("http") {
                    if let url = URL(string: employment.avatar) {
                        professionalImaveView.pin_setImage(from: url)
                    }
                } else {
                    if let url = URL(string: "https://cdn.petbooking.com.br\(employment.avatar)") {
                        professionalImaveView.pin_setImage(from: url)
                    }
                }
            }
        }
    }
    
    @IBAction func sendButtonTapped(_ sender: Any) {
        ALLoadingView.manager.showLoadingView(ofType: .basic, windowMode: .fullscreen)
        
        var description = ""
        if comentTextView.textColor != .lightGray {
            if comentTextView.text.trimmingCharacters(in: .whitespaces) != "" {
                description = comentTextView.text
            }
        }
        
        PetbookingAPI().postReview(comment: description, businessRating: environmentStar, employmentRating: attendanceStar, serviceRating: serviceStar, eventId: review!.id) { (success, message) in
            ALLoadingView.manager.hideLoadingView()
            
            if self.reviewList!.reviewables.count > 0 {
                self.setupView()
            } else {
                self.dismiss(animated: true, completion: nil)
            }
        }
    }
}

extension ReviewViewController: UITextViewDelegate {
    
    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        guard textView.text.count <= 500 else { return false }
        
        return true
    }
    
    func textViewDidBeginEditing(_ textView: UITextView) {
        if textView.textColor == .lightGray {
            textView.text = ""
            textView.textColor = .black
        }
    }
    
    func textViewDidEndEditing(_ textView: UITextView) {
        if textView.text.isEmpty {
            textView.text = "Adicione seu comentário"
            textView.textColor = .lightGray
        }
    }
}

extension ReviewViewController {

    @IBAction func attendanceButtonTapped(_ sender: UIButton) {
        switch sender {
        case attendanceOneButton:
            attendanceStar = 1
            markStar(attendanceOneButton)
            desmarkStar(attendanceTwoButton)
            desmarkStar(attendanceThreeButton)
            desmarkStar(attendanceFourButton)
            desmarkStar(attendanceFiveButton)
            
        case attendanceTwoButton:
            attendanceStar = 2
            markStar(attendanceOneButton)
            markStar(attendanceTwoButton)
            desmarkStar(attendanceThreeButton)
            desmarkStar(attendanceFourButton)
            desmarkStar(attendanceFiveButton)
            
        case attendanceThreeButton:
            attendanceStar = 3
            markStar(attendanceOneButton)
            markStar(attendanceTwoButton)
            markStar(attendanceThreeButton)
            desmarkStar(attendanceFourButton)
            desmarkStar(attendanceFiveButton)
            
        case attendanceFourButton:
            attendanceStar = 4
            markStar(attendanceOneButton)
            markStar(attendanceTwoButton)
            markStar(attendanceThreeButton)
            markStar(attendanceFourButton)
            desmarkStar(attendanceFiveButton)
            
        case attendanceFiveButton:
            attendanceStar = 5
            markStar(attendanceOneButton)
            markStar(attendanceTwoButton)
            markStar(attendanceThreeButton)
            markStar(attendanceFourButton)
            markStar(attendanceFiveButton)
            
        default:
            break
        }
    }
    
    @IBAction func serviceButtonTapped(_ sender: UIButton) {
        switch sender {
        case serviceOneButton:
            serviceStar = 1
            markStar(serviceOneButton)
            desmarkStar(serviceTwoButton)
            desmarkStar(serviceThreeButton)
            desmarkStar(serviceFourButton)
            desmarkStar(serviceFiveButton)
            
        case serviceTwoButton:
            serviceStar = 2
            markStar(serviceOneButton)
            markStar(serviceTwoButton)
            desmarkStar(serviceThreeButton)
            desmarkStar(serviceFourButton)
            desmarkStar(serviceFiveButton)
            
        case serviceThreeButton:
            serviceStar = 3
            markStar(serviceOneButton)
            markStar(serviceTwoButton)
            markStar(serviceThreeButton)
            desmarkStar(serviceFourButton)
            desmarkStar(serviceFiveButton)
            
        case serviceFourButton:
            serviceStar = 4
            markStar(serviceOneButton)
            markStar(serviceTwoButton)
            markStar(serviceThreeButton)
            markStar(serviceFourButton)
            desmarkStar(serviceFiveButton)
            
        case serviceFiveButton:
            serviceStar = 5
            markStar(serviceOneButton)
            markStar(serviceTwoButton)
            markStar(serviceThreeButton)
            markStar(serviceFourButton)
            markStar(serviceFiveButton)
            
        default:
            break
        }
    }

    @IBAction func environmentButtonTapped(_ sender: UIButton) {
        switch sender {
        case environmentOneButton:
            environmentStar = 1
            markStar(environmentOneButton)
            desmarkStar(environmentTwoButton)
            desmarkStar(environmentThreeButton)
            desmarkStar(environmentFourButton)
            desmarkStar(environmentFiveButton)
            
        case environmentTwoButton:
            environmentStar = 2
            markStar(environmentOneButton)
            markStar(environmentTwoButton)
            desmarkStar(environmentThreeButton)
            desmarkStar(environmentFourButton)
            desmarkStar(environmentFiveButton)
            
        case environmentThreeButton:
            environmentStar = 3
            markStar(environmentOneButton)
            markStar(environmentTwoButton)
            markStar(environmentThreeButton)
            desmarkStar(environmentFourButton)
            desmarkStar(environmentFiveButton)
            
        case environmentFourButton:
            environmentStar = 4
            markStar(environmentOneButton)
            markStar(environmentTwoButton)
            markStar(environmentThreeButton)
            markStar(environmentFourButton)
            desmarkStar(environmentFiveButton)
            
        case environmentFiveButton:
            environmentStar = 5
            markStar(environmentOneButton)
            markStar(environmentTwoButton)
            markStar(environmentThreeButton)
            markStar(environmentFourButton)
            markStar(environmentFiveButton)
            
        default:
            break
        }
    }
    
    func markStar(_ button: UIButton) {
        button.setImage(#imageLiteral(resourceName: "review_star_selected"), for: .normal)
    }
    
    func desmarkStar(_ button: UIButton) {
        button.setImage(#imageLiteral(resourceName: "review_star"), for: .normal)
    }
    
}










