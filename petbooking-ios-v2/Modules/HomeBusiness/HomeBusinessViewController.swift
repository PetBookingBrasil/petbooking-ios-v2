//
//  HomeBusinessViewController.swift
//  petbooking-ios-v2
//
//  Created Ryniere S Silva on 24/07/17.
//  Copyright © 2017 Pet Booking Serviços e Desenvolvimento de Softwares SA. All rights reserved.
//
//  Template generated by Juanpe Catalán @JuanpeCMiOS
//

import UIKit

class HomeBusinessViewController: UIViewController, HomeBusinessViewProtocol, UIScrollViewDelegate {

	var presenter: HomeBusinessPresenterProtocol?
	
	@IBOutlet weak var segmentioView: Segmentio!
	
	@IBOutlet weak var containerView: UIView!
	@IBOutlet weak var scrollView: UIScrollView!
	var cartButton:MJBadgeBarButton!
	
	var business:Business = Business()
	
	let cartUpdateNotification = Notification.Name(rawValue:"cartUpdateNotification")
	
	fileprivate lazy var viewControllers: [UIViewController] = {
		return self.preparedViewControllers()
	}()

	override func viewDidLoad() {
        super.viewDidLoad()
		
		setBackButton()
		setupScrollView()
		
		
		let customButton = UIButton(type: UIButtonType.custom)
		customButton.frame = CGRect(x: 0, y: 0, width: 35.0, height: 35.0)
		customButton.addTarget(self, action: #selector(self.goToShoppingCart(_:)), for: .touchUpInside)
		customButton.setImage(UIImage(named: "cartIcon"), for: .normal)
		
		cartButton = MJBadgeBarButton()
		cartButton.setup(customButton: customButton)
		
		cartButton.shouldHideBadgeAtZero = false
		cartButton.shouldAnimateBadge = true
		
		cartButton.badgeOriginX = 20.0
		cartButton.badgeOriginY = -4
		
		cartButton.badgeBGColor = UIColor.white
		cartButton.badgeTextColor = UIColor(hex: "E4002B")
		cartButton.badgeFont = UIFont.robotoRegular(ofSize: 14)
		
		cartButton.shouldHideBadgeAtZero = true
		cartButton.badgeValue = "\(0)"
		self.navigationItem.rightBarButtonItem = cartButton
		
		let nc = NotificationCenter.default
		nc.addObserver(forName:cartUpdateNotification, object:nil, queue:nil, using:updateCartBadge)
		
		HomeBusinessSegmentioBuilder.buildSegmentioView(
			segmentioView: segmentioView,
			segmentioStyle: .onlyLabel
		)
		
		segmentioView.selectedSegmentioIndex = selectedSegmentioIndex()
		
		segmentioView.valueDidChange = { [weak self] _, segmentIndex in
			if let scrollViewWidth = self?.scrollView.frame.width {
				let contentOffsetX = scrollViewWidth * CGFloat(segmentIndex)
				self?.scrollView.setContentOffset(
					CGPoint(x: contentOffsetX, y: 0),
					animated: true
				)
			}
		}
		
		title = business.name
    }
	
	func updateCartBadge(notification:Notification) -> Void {
		
		
		let schedule = ScheduleManager.sharedInstance.getSchedule(business:business)
		var quantity = 0
		for petSchedule in schedule.petsSchedule {
			
			for categories in petSchedule.categories {
				quantity += categories.services.count
			}
			
		}
		
		cartButton.badgeValue = "\(quantity)"

	}
	
	func goToShoppingCart(_ sender: Any) {
		
		let cart = CartRouter.createModule(business:business)
		
		self.navigationController?.pushViewController(cart, animated: true)
		
	}
	
	// MARK: - Setup container view
	
	fileprivate func setupScrollView() {
		scrollView.delegate = self
		scrollView.contentSize = CGSize(
			width: UIScreen.main.bounds.width * CGFloat(viewControllers.count),
			height: containerView.frame.height
		)
		scrollView.isScrollEnabled = false
		
		for (index, viewController) in viewControllers.enumerated() {
			viewController.view.frame = CGRect(
				x: UIScreen.main.bounds.width * CGFloat(index),
				y: 0,
				width: scrollView.frame.width,
				height: scrollView.frame.height
			)
			addChildViewController(viewController)
			scrollView.addSubview(viewController.view, options: .useAutoresize) // module's extension
			viewController.didMove(toParentViewController: self)
		}
	}
	
	fileprivate func preparedViewControllers() -> [UIViewController] {
		let listViewController = BusinessServicesRouter.createModule(business: self.business)
		let mapViewController = BusinessInformationRouter.createModule(business: self.business)
		
		return [
			listViewController,
			mapViewController
		]
	}
	
	fileprivate func selectedSegmentioIndex() -> Int {
		return 0
	}
	

}