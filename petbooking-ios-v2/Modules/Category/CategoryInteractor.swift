//
//  CategoryInteractor.swift
//  petbooking-ios-v2
//
//  Created by David Batista on 07/02/2018.
//  Copyright © 2018 Pet Booking Serviços e Desenvolvimento de Softwares SA. All rights reserved.
//

import UIKit
import ALLoadingView

class CategoryInteractor: CategoryInteractorProtocol {    
    weak var presenter: CategoryPresenterProtocol?
    
    func getReview() {
        
        PetbookingAPI.sharedInstance.getReviewable { (reviewable, message) in
            if let reviewable = reviewable, reviewable.reviewables.count > 0 {
                self.presenter?.loadReview(reviewList: reviewable)
            } else {
                ALLoadingView.manager.hideLoadingView()
            }
        }
    }

}
