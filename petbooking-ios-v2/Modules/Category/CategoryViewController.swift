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
    
    var serviceCategoryList: ServiceCategoryList = ServiceCategoryList()
    var selectedServiceCategory: ServiceCategory = ServiceCategory()
    
    var presenter: CategoryPresenterProtocol?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.register(UINib(nibName: "CategoryCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: "CategoryCollectionViewCell")
        
        setBackButton()
        requestCategory()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    func requestCategory() {
        ALLoadingView.manager.showLoadingView(ofType: .basic, windowMode: .fullscreen)
        
        PetbookingAPI.sharedInstance.getCategoryList { (serviceCategoryList, message) in
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
