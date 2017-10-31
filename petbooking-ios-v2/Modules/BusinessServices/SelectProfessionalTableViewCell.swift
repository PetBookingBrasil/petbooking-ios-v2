//
//  SelectProfessionalTableViewCell.swift
//  petbooking-ios-v2
//
//  Created by Ryniere S Silva on 30/10/17.
//  Copyright © 2017 Pet Booking Serviços e Desenvolvimento de Softwares SA. All rights reserved.
//

import UIKit

class SelectProfessionalTableViewCell: UITableViewCell {
	
	@IBOutlet weak var numberLabel: UILabel!
	@IBOutlet weak var collectionView: UICollectionView!
	
	var selectedService:Service = Service()
	var professionalList:ProfessionalList! = ProfessionalList()
	
	weak var delegate:SelectProfessionalTableViewCellDelegate?
	
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
		numberLabel.round()
		numberLabel.setBorder(width: 1, color: UIColor(hex: "E4002B"))
		
		collectionView.delegate = self
		collectionView.dataSource = self
		collectionView.register(UINib(nibName: "ProfessionalCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: "ProfessionalCollectionViewCell")
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}

extension SelectProfessionalTableViewCell: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
	
	func numberOfSections(in collectionView: UICollectionView) -> Int {
		
		return 1
	}
	
	func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
		
		return professionalList.professionals.count
	}
	
	func collectionView(_ collectionView: UICollectionView,
	                    layout collectionViewLayout: UICollectionViewLayout,
	                    sizeForItemAt indexPath: IndexPath) -> CGSize {
		return CGSize(width: self.frame.width / 3, height: 120)
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
		
		
		let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "ProfessionalCollectionViewCell", for: indexPath) as! ProfessionalCollectionViewCell
		
		let professional = professionalList.professionals[indexPath.item]
		
		cell.nameLabel.text = professional.name
		
		if let url = URL(string: professional.photoThumbUrl) {
			cell.profileImageView.pin_setImage(from: url)
		}

		
		return cell
		
	}
	
	func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
		
		let professional = professionalList.professionals[indexPath.item]
		
		delegate?.setSelectedProfessional(professional: professional)
		
		
	}
	
}

protocol SelectProfessionalTableViewCellDelegate: class {
	
	
	func setSelectedProfessional(professional:Professional)
	
}
