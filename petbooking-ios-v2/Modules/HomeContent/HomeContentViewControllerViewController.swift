//
//  HomeContentViewControllerViewController.swift
//  petbooking-ios-v2
//
//  Created Ryniere S Silva on 14/06/17.
//  Copyright © 2017 Pet Booking Serviços e Desenvolvimento de Softwares SA. All rights reserved.
//
//  Template generated by Juanpe Catalán @JuanpeCMiOS
//

import UIKit
import SideMenu

class HomeContentViewControllerViewController: UIViewController, HomeContentViewControllerViewProtocol {
	
	@IBOutlet weak var segmentioView: Segmentio!
	
	@IBOutlet weak var containerView: UIView!
	@IBOutlet weak var scrollView: UIScrollView!
	var presenter: HomeContentViewControllerPresenterProtocol?
	
	
	fileprivate lazy var viewControllers: [UIViewController] = {
		return self.preparedViewControllers()
	}()
	
	override func viewDidLoad() {
		super.viewDidLoad()
		
		
		navigationItem.title = "Estabelecimentos"//UIImageView(image: UIImage(named: "logoNavigationBar"))
		
		// Define the menus
		let menuLeftNavigationController = UISideMenuNavigationController(rootViewController: SideMenuRouter.createModule())
		menuLeftNavigationController.leftSide = true
		// UISideMenuNavigationController is a subclass of UINavigationController, so do any additional configuration
		// of it here like setting its viewControllers. If you're using storyboards, you'll want to do something like:
		// let menuLeftNavigationController = storyboard!.instantiateViewController(withIdentifier: "LeftMenuNavigationController") as! UISideMenuNavigationController
		SideMenuManager.menuLeftNavigationController = menuLeftNavigationController
		SideMenuManager.menuEnableSwipeGestures = false
		
		// Enable gestures. The left and/or right menus must be set up above for these to work.
		// Note that these continue to work on the Navigation Controller independent of the view controller it displays!
		SideMenuManager.menuAddPanGestureToPresent(toView: self.navigationController!.navigationBar)
		SideMenuManager.menuAddScreenEdgePanGesturesToPresent(toView: self.navigationController!.view)
		SideMenuManager.menuAnimationBackgroundColor = UIColor.clear
		SideMenuManager.menuShadowRadius = 0
		SideMenuManager.menuShadowOpacity = 0
		//SideMenuManager.menuBlurEffectStyle = .dark
		SideMenuManager.menuPushStyle = .popWhenPossible
		
		navigationItem.leftBarButtonItem = UIBarButtonItem(image: UIImage(named:"menu"), style: .plain, target: self, action: #selector(showLeftMenu))
		
		setupScrollView()
		
		SegmentioBuilder.buildSegmentioView(
			segmentioView: segmentioView,
			segmentioStyle: .onlyImage
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
		
		NotificationCenter.default.addObserver(self, selector: #selector(HomeContentViewControllerViewController.goToAgenda), name: .goToAgenda, object: nil)
		
	}
	
	override func viewDidAppear(_ animated: Bool) {
		super.viewDidAppear(animated)
		
	}
	
	
	func goToAgenda() {
		self.navigationController?.pushViewController(AgendaRouter.createModule(), animated: true)
	}
	func showLeftMenu() {
		present(SideMenuManager.menuLeftNavigationController!, animated: true, completion: nil)
	}
	
	// MARK: - Setup container view
	
	fileprivate func setupScrollView() {
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
		let listViewController = BusinessListViewControllerRouter.createModule()
		let mapViewController = BusinessListViewControllerRouter.createModule(businessListType: .map)
		
		return [
			listViewController,
			mapViewController
		]
	}
	
	fileprivate func selectedSegmentioIndex() -> Int {
		return 0
	}
}
