//
//  CategoryViewController.swift
//  petbooking-ios-v2
//
//  Created by David Batista on 07/02/2018.
//  Copyright © 2018 Pet Booking Serviços e Desenvolvimento de Softwares SA. All rights reserved.
//

import UIKit
import ALLoadingView

class CategoryViewController: UIViewController, CategoryViewProtocol {
    
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var bannerHeightConstraint: NSLayoutConstraint!
    @IBOutlet weak var bannerPageControl: UIPageControl!
    @IBOutlet weak var bannerCollectionView: UICollectionView!
    
    var serviceCategoryList: ServiceCategoryList = ServiceCategoryList()
    var selectedServiceCategory: ServiceCategory = ServiceCategory()
    
    var presenter: CategoryPresenterProtocol?
    var bannerDelegate: BannerControlDelegate?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        bannerDelegate = BannerControlDelegate(collectionView: bannerCollectionView, bannerPageControl: bannerPageControl, presenter: presenter)
        bannerCollectionView.delegate = bannerDelegate
        bannerCollectionView.dataSource = bannerDelegate
        
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.register(UINib(nibName: "CategoryCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: "CategoryCollectionViewCell")
        
        setBackButton()
        requestCategory()
        
        presenter?.getReview()
    }
    
    func showReviewable(_ review: ReviewableList) {
        let alertVC = ReviewRouter.createModule(reviews: review)
        alertVC.modalPresentationStyle = .overCurrentContext
        alertVC.modalTransitionStyle = .crossDissolve
        present(alertVC, animated: true, completion: nil)
    }
    
    func requestCategory() {
        ALLoadingView.manager.showLoadingView(ofType: .basic, windowMode: .fullscreen)
        
        PetbookingAPI.sharedInstance.getBanner { (bannerList, _) in
            if let bannerList = bannerList {
                self.bannerPageControl.numberOfPages = bannerList.banners.count
                self.bannerPageControl.currentPage = 0
                self.bannerHeightConstraint.constant = 120
                self.bannerDelegate?.setBanners(bannerList)
            } else {
                self.bannerHeightConstraint.constant = 0
            }
        }
        
        PetbookingAPI.sharedInstance.getCategoryList { (serviceCategoryList, _) in
            ALLoadingView.manager.hideLoadingView()

            guard let serviceCategoryList = serviceCategoryList else { return }
            
            self.serviceCategoryList = serviceCategoryList
            self.collectionView.reloadData()
        }
    }
}

extension CategoryViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return serviceCategoryList.categories.count
    }
    
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        let numberOfItemsPerRow = 2
        
        let flowLayout = collectionViewLayout as! UICollectionViewFlowLayout
        let totalSpace = flowLayout.sectionInset.left + flowLayout.sectionInset.right
            + (flowLayout.minimumInteritemSpacing * CGFloat(numberOfItemsPerRow - 1))
        let size = Int((collectionView.bounds.width - totalSpace) / CGFloat(numberOfItemsPerRow))
        
        return CGSize(width: size, height: size)
    }
    
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 1.0
    }
    
    func collectionView(_ collectionView: UICollectionView, layout
        collectionViewLayout: UICollectionViewLayout,
                        minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 1.0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "CategoryCollectionViewCell", for: indexPath) as! CategoryCollectionViewCell
        
        let service = serviceCategoryList.categories[indexPath.item]
        
        if service == selectedServiceCategory {
            collectionView.selectItem(at: indexPath, animated: false, scrollPosition: .left)
        }
        
        cell.pictureImageView.image = UIImage(named: service.slug)
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let service = serviceCategoryList.categories[indexPath.item]
        
        presenter?.showCategoryContent(from: service)
    }
}

class BannerControlDelegate: NSObject, UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    var presenter: CategoryPresenterProtocol?
    var collectionView: UICollectionView!
    var bannerPageControl: UIPageControl!
    var bannerList = [Banner]()
    
    init(collectionView: UICollectionView, bannerPageControl: UIPageControl, presenter: CategoryPresenterProtocol?) {
        super.init()
        
        self.presenter = presenter
        self.collectionView = collectionView
        self.bannerPageControl = bannerPageControl
        
        self.collectionView.setContentOffset(.zero, animated: false)
        
        self.collectionView.register(UINib(nibName: "BannerCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: "BannerCollectionViewCell")
    }
    
    func setBanners(_ banners: BannerList) {
        self.bannerList = banners.banners
        collectionView.reloadData()
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return bannerList.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "BannerCollectionViewCell", for: indexPath) as! BannerCollectionViewCell
        cell.setCell(with: bannerList[indexPath.row])
        
        return cell
    }
    
    func scrollViewWillEndDragging(_ scrollView: UIScrollView, withVelocity velocity: CGPoint, targetContentOffset: UnsafeMutablePointer<CGPoint>) {
        
        //Get the cell's width plus spacing
        let cellWidthIncludingSpacing = collectionView.frame.width + 10.0
        
        //This is the expected offset when the collectionView's scrollView stops scrolling.
        //The new offset after a scroll action has been perfomed
        var offset = targetContentOffset.pointee
        
        //The index is calculated by taking the distance (offset.x) from x = 0 (origin.x) divided by the cellWidthIncludingSpacing.
        //for example if offset.x = 750 and  cellWidthIncludingSpacing = 316 then the index = 737 / 316 = 2.332278...
        //The value here is in CGFloat
        let index = (offset.x + scrollView.contentInset.left) / cellWidthIncludingSpacing
        
        //Here we round the index to get a whole number
        //for example if we round 2.332278 we'll get 2
        let roundedIndex = round(index)
        
        //Now we calculate the new offset based on the rounded index to make the cell centered
        offset = CGPoint(x: roundedIndex * cellWidthIncludingSpacing - scrollView.contentInset.left, y: -scrollView.contentInset.top)
        
        //Last we set the new offset.
        targetContentOffset.pointee = offset
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let offSet = scrollView.contentOffset.x
        let width = scrollView.frame.width
        let horizontalCenter = width / 2
        
        bannerPageControl.currentPage = Int(offSet + horizontalCenter) / Int(width)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return collectionView.bounds.size
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let banner = bannerList[indexPath.row]
        
        self.presenter?.showBannerContent(from: banner)
    }
}
