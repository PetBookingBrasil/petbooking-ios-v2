//
//  SideMenuRouter.swift
//  petbooking-ios-v2
//
//  Created Ryniere S Silva on 18/05/17.
//  Copyright © 2017 Pet Booking Serviços e Desenvolvimento de Softwares SA. All rights reserved.
//
//  Template generated by Juanpe Catalán @JuanpeCMiOS
//

import UIKit
import SideMenu

class SideMenuRouter: SideMenuWireframeProtocol {
    
    weak var viewController: UIViewController?
    
    static func createModule() -> UIViewController {
        // Change to get view from storyboard if not using progammatic UI
        let view = SideMenuViewController(nibName: nil, bundle: nil)
        let interactor = SideMenuInteractor()
        let router = SideMenuRouter()
        let presenter = SideMenuPresenter(interface: view, interactor: interactor, router: router)
        
        view.presenter = presenter
        interactor.presenter = presenter
        router.viewController = view
        
        return view
    }
    
    func didTapLogout() {
        let loginViewController = UINavigationController(rootViewController: LoginRouter.createModule())
        
        self.viewController?.dismiss(animated: true) {
            let window = UIApplication.shared.windows[0]
            
            UIView.transition(from: window.rootViewController!.view,
                              to: loginViewController.view,
                              duration: 0.65,
                              options: .transitionFlipFromBottom) { finished in
                                window.rootViewController = loginViewController
            }
        }
    }
    
    func didTapMyPets() {
        self.viewController?.navigationController?.pushViewController(MyPetsRouter.createModule(), animated: true)
    }
    
    func showProfile() {
        self.viewController?.navigationItem.backBarButtonItem = UIBarButtonItem(title: "", style: UIBarButtonItemStyle.plain, target: nil, action: nil)
        self.viewController?.navigationController?.pushViewController(SignupRouter.createModule(signupType: .editProfile), animated: true)
    }
    
    func showFavorites() {
        self.viewController?.navigationController?.pushViewController(BusinessListViewControllerRouter.createModule(businessListType: .favorites), animated: true)
    }
    
    func showSchedule() {
        self.viewController?.navigationController?.pushViewController(AgendaRouter.createModule(), animated: true)
    }
    
    func showPayments() {
        var authToken = ""
        if let session = SessionManager.sharedInstance.getCurrentSession() {
            authToken = session.authToken
        }

        let paymentsURL = "https://beta.petbooking.com.br/v2/webviews/credit_cards/\(authToken)"
        let webviewRequest = WebviewRequest(title: "Formas de Pagamento", url: URL(string: paymentsURL))
        
        let paymentView = WebviewRouter.createModule(from: webviewRequest)
        self.viewController?.navigationController?.pushViewController(paymentView, animated: true)
    }
    
    func showSearch() {
        self.viewController?.navigationController?.pushViewController(BusinessSearchRouter.createModule(), animated: true)
    }
}
