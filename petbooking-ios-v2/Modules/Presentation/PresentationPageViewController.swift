//
//  PresentationPageViewController.swift
//  petbooking-ios-v2
//
//  Created by Ryniere S Silva on 05/05/17.
//  Copyright © 2017 Pet Booking Serviços e Desenvolvimento de Softwares SA. All rights reserved.
//

import UIKit
import Pageboy

class PresentationPageViewController: PageboyViewController, PageboyViewControllerDataSource, PageboyViewControllerDelegate, PresentationParentProtocol {

  var viewControllers = [UIViewController]()

  override func viewDidLoad() {
    super.viewDidLoad()

    // Do any additional setup after loading the view.
    self.view.backgroundColor = .white
    self.delegate = self
    self.dataSource = self

    // Make a view controllers array
    viewControllers.append(PresentationRouter.createModule(index: .first, parentViewController: self))
    viewControllers.append(PresentationRouter.createModule(index: .second, parentViewController: self))
    viewControllers.append(PresentationRouter.createModule(index: .third, parentViewController: self))

    reloadPages()
  }

  override func didReceiveMemoryWarning() {
    super.didReceiveMemoryWarning()
    // Dispose of any resources that can be recreated.
  }

  //
  // MARK: PresentationParentProtocol
  //

  func nextPage() {
    self.scrollToPage(.next, animated: true)
  }

  //
  // MARK: PageboyViewControllerDataSource
  //

  func numberOfViewControllers(in pageboyViewController: PageboyViewController) -> Int {
    return viewControllers.count
  }

  func viewController(for pageboyViewController: PageboyViewController, at index: PageboyViewController.PageIndex) -> UIViewController? {
    return viewControllers[index]
  }

  func defaultPage(for pageboyViewController: PageboyViewController) -> PageboyViewController.Page? {
    return nil
  }

  //
  // MARK: PageboyViewControllerDelegate
  //
  func pageboyViewController(_ pageboyViewController: PageboyViewController,
                             willScrollToPageAtIndex index: Int,
                             direction: PageboyViewController.NavigationDirection,
                             animated: Bool) {

  }

  func pageboyViewController(_ pageboyViewController: PageboyViewController,
                             didScrollToPosition position: CGPoint,
                             direction: PageboyViewController.NavigationDirection,
                             animated: Bool) {

  }

  func pageboyViewController(_ pageboyViewController: PageboyViewController,
                             didScrollToPageAtIndex index: Int,
                             direction: PageboyViewController.NavigationDirection,
                             animated: Bool) {

  }

  func pageboyViewController(_ pageboyViewController: PageboyViewController,
                             didReload viewControllers: [UIViewController],
                             currentIndex: PageboyViewController.PageIndex) {

  }

}
