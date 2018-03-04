//
//  CartWebViewController.swift
//  petbooking-ios-v2
//
//  Created Ryniere S Silva on 03/08/17.
//  Copyright © 2017 Pet Booking Serviços e Desenvolvimento de Softwares SA. All rights reserved.
//
//  Template generated by Juanpe Catalán @JuanpeCMiOS
//

import UIKit
import WebKit
import ALLoadingView

class CartWebViewController: UIViewController, CartWebViewProtocol {
	
	static let HTTP_PROTOCOL = "https://"
	static let BASE_URL = Bundle.main.infoDictionary!["BASE_URL"] as! String
	static let API_VERSION = "/v2"
	static let WEB_BASE_URL = "\(HTTP_PROTOCOL)\(BASE_URL)\(API_VERSION)"
	
	var webView: WKWebView!
	var presenter: CartWebPresenterProtocol?
	
	var cart:Cart! = Cart()
	
	override func viewDidLoad() {
		super.viewDidLoad()
		
		setBackButton()
		title = "Pagamento"
		
		ALLoadingView.manager.showLoadingView(ofType: .basic, windowMode: .fullscreen)
		PetbookingAPI.sharedInstance.userInfo { (user, message) in
			self.loadWebView()
		}
	}
	
	func loadWebView() {
		let configuration = WKWebViewConfiguration()
		let controller = WKUserContentController()
		controller.add(self, name: "observe")
		configuration.userContentController = controller
		
		webView = WKWebView(frame: view.frame, configuration: configuration)
		webView.navigationDelegate = self
		
		view.addSubview(webView)
		
		guard let user = UserManager.sharedInstance.getCurrentUser() else { return }
		guard let url = URL(string: "\(CartWebViewController.WEB_BASE_URL)/webviews/payments/\(cart.id)/\(user.authToken)/new") else { return }
		
		webView.load(URLRequest(url: url))
	}
}

extension CartWebViewController: WKNavigationDelegate {
	
	func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
		ALLoadingView.manager.hideLoadingView()
	}
	
	func webView(_ webView: WKWebView, didFail navigation: WKNavigation!, withError error: Error) {
		ALLoadingView.manager.hideLoadingView()
	}
}

extension CartWebViewController: WKScriptMessageHandler {
	
	func userContentController(_ userContentController: WKUserContentController, didReceive message: WKScriptMessage) {
		
		guard let result = message.body as? String else {
			return
		}
		
		if result == "ok" {
			let when = DispatchTime.now() + 2 // change 2 to desired number of seconds
			DispatchQueue.main.asyncAfter(deadline: when) {
				self.navigationController?.popToRootViewController(animated: true)
				NotificationCenter.default.post(name: .goToAgenda, object: nil)
			}
		}
	}
}
