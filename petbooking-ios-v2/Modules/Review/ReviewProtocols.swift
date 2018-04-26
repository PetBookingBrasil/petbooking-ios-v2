//
//  ReviewProtocols.swift
//  petbooking-ios-v2
//
//  Created by David Batista on 20/04/2018.
//  Copyright © 2018 Pet Booking Serviços e Desenvolvimento de Softwares SA. All rights reserved.
//

import Foundation

//MARK: Wireframe -
protocol ReviewWireframeProtocol: class { }

//MARK: Presenter -
protocol ReviewPresenterProtocol: class {
    func loadPet(_ petId: Int)
    func show(pet: Pet)

}

//MARK: Interactor -
protocol ReviewInteractorProtocol: class {
    var presenter: ReviewPresenterProtocol? { get set }
    
    func loadPet(_ petId: Int)
}

//MARK: View -
protocol ReviewViewProtocol: class {
    var reviewList: ReviewableList? { get set }
    var presenter: ReviewPresenterProtocol? { get set }
    
    func show(pet: Pet)
}
