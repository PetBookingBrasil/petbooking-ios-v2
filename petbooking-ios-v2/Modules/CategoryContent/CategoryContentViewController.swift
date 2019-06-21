//
//  CategoryContentViewController.swift
//  petbooking-ios-v2
//
//  Created by David Batista on 08/02/2018.
//  Copyright © 2018 Pet Booking Serviços e Desenvolvimento de Softwares SA. All rights reserved.
//

import UIKit
import SideMenu

class CategoryContentViewController: UIViewController, CategoryContentViewProtocol {
    
    typealias SegmentioBuilder = CategoryContentSegmentioBuilder
    
    @IBOutlet weak var segmentioView: Segmentio!
    @IBOutlet weak var containerView: UIView!
    @IBOutlet weak var scrollView: UIScrollView!
    
    var presenter: CategoryContentPresenterProtocol?
    var service: ServiceCategory?
    var banner: Banner?
    
    fileprivate lazy var viewControllers: [UIViewController] = {
        return self.preparedViewControllers()
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        title = service?.name ?? "Promoção"
        
        setupScrollView()
        setBackButton()
        setSearchButton()
        
        SegmentioBuilder.buildSegmentioView(segmentioView: segmentioView,
                                            segmentioStyle: .onlyLabel)
        
        segmentioView.selectedSegmentioIndex = 0
        
        segmentioView.valueDidChange = { [weak self] _, segmentIndex in
            if let scrollViewWidth = self?.scrollView.frame.width {
                let contentOffsetX = scrollViewWidth * CGFloat(segmentIndex)
                self?.scrollView.setContentOffset(CGPoint(x: contentOffsetX, y: 0), animated: true)
            }
        }
    }
    
    func setSearchButton() {
        let addButton = UIBarButtonItem()
        addButton.target = self
        addButton.action = #selector(showSearch)
        
        self.navigationItem.rightBarButtonItem = addButton
        self.navigationItem.rightBarButtonItem?.image = UIImage(named: "search")
    }
    
    @objc func showSearch() {
        self.navigationController?.pushViewController(BusinessSearchRouter.createModule(), animated: true)
    }
    
    // MARK: - Setup container view
    fileprivate func setupScrollView() {
        scrollView.contentSize = CGSize(width: UIScreen.main.bounds.width * CGFloat(viewControllers.count),
                                        height: containerView.frame.height)
        
        scrollView.isScrollEnabled = false
        
        for (index, viewController) in viewControllers.enumerated() {
            viewController.view.frame = CGRect(x: UIScreen.main.bounds.width * CGFloat(index),
                                               y: 0,
                                               width: scrollView.frame.width,
                                               height: scrollView.frame.height)
            
            addChildViewController(viewController)
            scrollView.addSubview(viewController.view, options: .useAutoresize) // module's extension
            viewController.didMove(toParentViewController: self)
        }
    }
    
    fileprivate func preparedViewControllers() -> [UIViewController] {
        let businessViewController = BusinessListViewControllerRouter.createModule(businessListType: .list, withBanner: banner, from: service)
        let mapViewController = BusinessListViewControllerRouter.createModule(businessListType: .map, withBanner: banner, from: service)
        
        return [businessViewController, mapViewController]
    }
}
