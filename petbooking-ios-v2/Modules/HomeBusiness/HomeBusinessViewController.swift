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
import Segmentio

class HomeBusinessViewController: UIViewController, HomeBusinessViewProtocol {

	var presenter: HomeBusinessPresenterProtocol?
	
	@IBOutlet weak var segmentioView: Segmentio!
	
	@IBOutlet weak var containerView: UIView!
	@IBOutlet weak var scrollView: UIScrollView!
	
	var business:Business = Business()
	
	fileprivate lazy var viewControllers: [UIViewController] = {
		return self.preparedViewControllers()
	}()

	override func viewDidLoad() {
        super.viewDidLoad()
		
		setupScrollView()
		
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
	
	// MARK: - Setup container view
	
	fileprivate func setupScrollView() {
		scrollView.contentSize = CGSize(
			width: UIScreen.main.bounds.width * CGFloat(viewControllers.count),
			height: containerView.frame.height
		)
		
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
