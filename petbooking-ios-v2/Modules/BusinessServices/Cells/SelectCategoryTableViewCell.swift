//
//  SelectCategoryTableViewCell.swift
//  petbooking-ios-v2
//
//  Created by Ryniere S Silva on 22/10/17.
//  Copyright © 2017 Pet Booking Serviços e Desenvolvimento de Softwares SA. All rights reserved.
//

import UIKit

class SelectCategoryTableViewCell: UITableViewCell {

	@IBOutlet weak var titleLabel: UILabel!
	@IBOutlet weak var numberLabel: UILabel!
	@IBOutlet weak var collectionView: UICollectionView!
	
	weak var delegate: SelectCategoryTableViewCellDelegate?
	
	var serviceCategoryList: ServiceCategoryList = ServiceCategoryList()
	var selectedServiceCategory = ServiceCategory()
	
	override func awakeFromNib() {
        super.awakeFromNib()
 
        numberLabel.round()
		numberLabel.setBorder(width: 1, color: UIColor(hex: "E4002B"))
		
		collectionView.delegate = self
		collectionView.dataSource = self
		collectionView.register(UINib(nibName: "ServiceCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: "ServiceCollectionViewCell")
    }
}

extension SelectCategoryTableViewCell: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
	
	func numberOfSections(in collectionView: UICollectionView) -> Int {
		return 1
	}
	
	func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return serviceCategoryList.categories.count
	}
	
	func collectionView(_ collectionView: UICollectionView,
	                    layout collectionViewLayout: UICollectionViewLayout,
	                    sizeForItemAt indexPath: IndexPath) -> CGSize {
		
		let numberOfItemsPerRow = 3
		let flowLayout = collectionViewLayout as! UICollectionViewFlowLayout
		let totalSpace = flowLayout.sectionInset.left
			+ flowLayout.sectionInset.right
			+ (flowLayout.minimumInteritemSpacing * CGFloat(numberOfItemsPerRow - 1))
		let size = Int((collectionView.bounds.width - totalSpace) / CGFloat(numberOfItemsPerRow))
		
		return CGSize(width: size, height: 120)
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
		
		let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "ServiceCollectionViewCell", for: indexPath) as! ServiceCollectionViewCell
		
		let service = serviceCategoryList.categories[indexPath.item]
		
		cell.isSelected = service == selectedServiceCategory
		if service == selectedServiceCategory {
			collectionView.selectItem(at: indexPath, animated: false, scrollPosition: .left)
		}
		
		cell.nameLabel.text = service.name
		cell.pictureImageView.image = UIImage(named: "\(service.slug)-mini")
		
		return cell
	}
	
	func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
		selectedServiceCategory = serviceCategoryList.categories[indexPath.item]

		delegate?.setSelectedCategory(selectedServiceCategory: selectedServiceCategory!)
	}
}

protocol SelectCategoryTableViewCellDelegate: class {
	func setSelectedCategory(selectedServiceCategory:ServiceCategory)
}
