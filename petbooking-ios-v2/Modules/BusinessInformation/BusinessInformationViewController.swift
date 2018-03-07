//
//  BusinessInformationViewController.swift
//  petbooking-ios-v2
//
//  Created Ryniere S Silva on 03/08/17.
//  Copyright © 2017 Pet Booking Serviços e Desenvolvimento de Softwares SA. All rights reserved.
//
//  Template generated by Juanpe Catalán @JuanpeCMiOS
//

import UIKit
import MapKit
import RateView
import AKNumericFormatter

class BusinessInformationViewController: ExpandableTableViewController, BusinessInformationViewProtocol {
	
	@IBOutlet weak var tableViewHeightConstraint: NSLayoutConstraint!
	@IBOutlet weak var rateLabel: UILabel!
	@IBOutlet weak var rateCountLabel: UILabel!
	@IBOutlet weak var rateView: RateView!
	@IBOutlet weak var tableView: ExpandableTableView!
	@IBOutlet weak var webviewHeightConstraint: NSLayoutConstraint!
	
	@IBOutlet weak var contactViewHeightConstraint: NSLayoutConstraint!
	
	@IBOutlet weak var socialNetworkViewWidthConstraint: NSLayoutConstraint!
	@IBOutlet weak var websiteViewWidthConstraint: NSLayoutConstraint!
	@IBOutlet weak var descriptionTitleLabel: UILabel!
	@IBOutlet weak var descripitionSeparatorView: UIView!
	@IBOutlet weak var descriptionTitleViewHeightConstraint: NSLayoutConstraint!
	@IBOutlet weak var descriptionLabelBottonSpaceConstraint: NSLayoutConstraint!
	@IBOutlet weak var descriptionViewHeightConstraint: NSLayoutConstraint!
	@IBOutlet weak var descriptionView: UIView!
	@IBOutlet weak var favoriteButton: UIButton!
	@IBOutlet weak var businessNameLabel: UILabel!
	@IBOutlet weak var descriptionLabel: UILabel!
	@IBOutlet weak var phoneNumberLabel: UILabel!
	@IBOutlet weak var websiteLabel: UILabel!
	@IBOutlet weak var addressLabel: UILabel!
	@IBOutlet weak var distanceLabel: UILabel!
	@IBOutlet weak var businessImageView: UIImageView!
	@IBOutlet weak var mapView: MKMapView!
	@IBOutlet weak var distanceView: UIView!
	@IBOutlet weak var socialNetworksCollectionView: UICollectionView!
	
	var business: Business! = Business()
	var reviewList: ReviewList = ReviewList()
	
	var socialNetworks: [SocialNetworkEnum] = [SocialNetworkEnum]()
	
	var presenter: BusinessInformationPresenterProtocol?
	
	override func viewDidLoad() {
		super.viewDidLoad()
		
		businessImageView.image = UIImage(named: "business-placeholder-image")
		if let url = URL(string: business.photoUrl) {
			businessImageView.pin_setImage(from: url)
		}
		
		businessNameLabel.text = business.name
		descriptionLabel.text = business.businessDescription
		
		var phoneMask = "(**) ****-****"
		
		if business.phone.count == 11 {
			phoneMask = "(**) *****-****"
		}
		
		let phoneFormatted = AKNumericFormatter.formatString(business.phone, usingMask: phoneMask, placeholderCharacter: "*".utf16.first!)
		phoneNumberLabel.text = phoneFormatted
		distanceLabel.text = "\(business.distance)km"
		distanceLabel.sizeToFit()
		distanceView.round()
		distanceView.setBorder(width: 1, color: .red)
		websiteLabel.text = business.website
		addressLabel.text = "\(business.street), \(business.streetNumber), \(business.neighborhood)"
		
		rateView.starFillColor = UIColor(hex: "F2C94C")
		rateView.starFillMode = .init(1)
		rateView.starSize = 13
		rateView.rating = Float(business.rating)
		rateLabel.text = "\(business.rating)"
		rateCountLabel.round()
		rateCountLabel.setBorder(width: 1, color: UIColor(hex: "BFBFBF"))
		rateCountLabel.text = "\(business.ratingCount)"
		
		expandableTableView.expandableDelegate = self
		expandableTableView.register(UINib(nibName: "ReviewsHeaderTableViewCell", bundle: nil), forCellReuseIdentifier: "ReviewsHeaderTableViewCell")
		expandableTableView.register(UINib(nibName: "ReviewCommentSubRowTableViewCell", bundle: nil), forCellReuseIdentifier: "ReviewCommentSubRowTableViewCell")

		let coordinateRegion = MKCoordinateRegionMakeWithDistance(business.location, 1000, 1000)
		
		mapView.setRegion(coordinateRegion, animated: false)
		
		let annotation = MKPointAnnotation()
		
		annotation.coordinate = CLLocationCoordinate2D(latitude: business.location.latitude, longitude: business.location.longitude)
		mapView.addAnnotation(annotation)
		
		socialNetworksCollectionView.register(UINib(nibName: "SocialNetworkCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: "SocialNetworkCollectionViewCell")
		
		let cellSize = CGSize(width:40 , height:40)
		let layout = UICollectionViewFlowLayout()
		layout.itemSize = cellSize
		layout.scrollDirection = .horizontal
		layout.minimumLineSpacing = 5
		layout.minimumInteritemSpacing = 0
		layout.sectionInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
		socialNetworksCollectionView.collectionViewLayout = layout
		
		let imageName = business.isFavorited() ? "heartFilledIcon" : "heartIcon"
		favoriteButton.setBackgroundImage(UIImage(named:imageName), for: .normal)
		
		if !business.facebook.isBlank {
			socialNetworks.append(.facebook)
		}
		
		if !business.instagram.isBlank {
			socialNetworks.append(.instagram)
		}
		
		if !business.twitter.isBlank {
			socialNetworks.append(.twitter)
		}
		
		if !business.googleplus.isBlank {
			socialNetworks.append(.googleplus)
		}
		
		if !business.snapchat.isBlank {
			socialNetworks.append(.snapchat)
		}
		
		socialNetworksCollectionView.reloadData()
	}
	
	override func viewWillAppear(_ animated: Bool) {
		super.viewWillAppear(animated)
		
		PetbookingAPI.sharedInstance.getBusinessReviews(business: business) { (reviewList, message) in
			
			guard let reviewList = reviewList else {
				return
			}
			self.reviewList = reviewList
			self.tableViewHeightConstraint.constant = CGFloat((self.reviewList.reviews.count + 1) * 60)
			self.expandableTableView.reloadData()
		}
	}
	
	override func viewDidLayoutSubviews() {
		super.viewDidLayoutSubviews()
		
		if business.businessDescription.isBlank {
			descriptionViewHeightConstraint.constant = 0
			descriptionLabelBottonSpaceConstraint.constant = 0
			descriptionTitleViewHeightConstraint.constant = 0
			descripitionSeparatorView.isHidden = true
			descriptionTitleLabel.isHidden = true
			
		}
		
		if business.phone.isBlank {
			contactViewHeightConstraint.constant = 0
		}
		
		if business.website.isBlank {
			websiteViewWidthConstraint.constant = 0
		}
		
		if socialNetworks.isEmpty {
			socialNetworkViewWidthConstraint.constant = 0
		}
		
		if socialNetworks.isEmpty && business.website.isBlank {
			webviewHeightConstraint.constant = 0
		}
		
		self.view.setNeedsUpdateConstraints()
	}
	
	@IBAction func addToFavorites(_ sender: Any) {
		let imageName = !business.isFavorited() ? "heartFilledIcon" : "heartIcon"
		favoriteButton.setBackgroundImage(UIImage(named:imageName), for: .normal)
		
		if business.isFavorited() {
			PetbookingAPI.sharedInstance.removeBusinessFromFavorite(business: business) { (success, message) in
				if success {
					self.business.favoriteId = 0
				}
			}
		} else {
			PetbookingAPI.sharedInstance.addBusinessToFavorite(business: business) { (success, message) in }
		}
	}
	
	@IBAction func callPhoneNumber(_ sender: Any) {
		guard let business = self.business else { return }
		
		let localCode = PhoneCodesConstants.getLocalCodeforCarrier()
		
		if let url = URL(string: "tel://0\(localCode!)\(business.phone)"), UIApplication.shared.canOpenURL(url) {
			if #available(iOS 10, *) {
				UIApplication.shared.open(url)
			} else {
				UIApplication.shared.openURL(url)
			}
		}
	}
}

extension BusinessInformationViewController: MKMapViewDelegate {
	
	func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
		if !(annotation is MKPointAnnotation) { return nil }
		
		var annotationView = mapView.dequeueReusableAnnotationView(withIdentifier: "demo")
		
        if annotationView == nil {
			annotationView = MKAnnotationView(annotation: annotation, reuseIdentifier: "demo")
			annotationView!.canShowCallout = true
		} else {
			annotationView!.annotation = annotation
		}
		
		annotationView!.image = UIImage(named: "business_pin")
		
		return annotationView
	}
	
	@IBAction func openMapsOptions(_ sender: Any) {
		
		let location = business.location
		
		Localide.sharedManager.promptForDirections(toLocation: location) { (usedApp, fromMemory, openedLinkSuccessfully) in
			print("The user picked \(usedApp.appName)")
		}
	}
}

extension BusinessInformationViewController: UICollectionViewDelegate, UICollectionViewDataSource {
	
	func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
		return socialNetworks.count
	}
	
	func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
		
		let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "SocialNetworkCollectionViewCell", for: indexPath) as! SocialNetworkCollectionViewCell
		
		let socialNetwork = socialNetworks[indexPath.item]
		
		cell.imageView.image = UIImage(named: socialNetwork.rawValue)
		return cell
	}
	
	func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
		
		let socialNetwork = socialNetworks[indexPath.item]
		
		switch socialNetwork {
		case .facebook:
            open(url: business.facebook, withTitle: "Facebook")
 
        case .instagram:
            open(url: business.instagram, withTitle: "Instagram")

		case .twitter:
            open(url: business.twitter, withTitle: "Twitter")

			if let url = URL(string: business.twitter) {
				if UIApplication.shared.canOpenURL(url) {
					UIApplication.shared.open(url, options: [:], completionHandler: nil)
				}
			}

        case .googleplus:
            open(url: business.googleplus, withTitle: "Google+")

			if let url = URL(string: business.googleplus) {
				if UIApplication.shared.canOpenURL(url) {
					UIApplication.shared.open(url, options: [:], completionHandler: nil)
				}
			}
            
		case .snapchat:
            open(url: business.snapchat, withTitle: "Snapchat")
		}
	}
    
    func open(url: String, withTitle title: String) {
        let webviewRequest = WebviewRequest(title: title, url: URL(string: url))
        
        let webview = WebviewRouter.createModule(from: webviewRequest)
        self.navigationController?.pushViewController(webview, animated: true)
    }
}

extension BusinessInformationViewController: ExpandableTableViewDelegate {
	
	// Rows
	func expandableTableView(_ expandableTableView: ExpandableTableView, numberOfRowsInSection section: Int) -> Int {
		return reviewList.reviews.count
	}
    
	func expandableTableView(_ expandableTableView: ExpandableTableView, cellForRowAtExpandableIndexPath expandableIndexPath: ExpandableIndexPath) -> UITableViewCell {
		
		let cell = expandableTableView.dequeueReusableCellWithIdentifier("ReviewsHeaderTableViewCell", forIndexPath: expandableIndexPath) as!ReviewsHeaderTableViewCell
		
		let review = reviewList.reviews[expandableIndexPath.row]
		
		PetbookingAPI.sharedInstance.getUserInfo(userId: review.userId) { (user, message) in
			
			guard let user = user else {
				return
			}
			cell.nameLabel.text = user.name
			
			if let url = URL(string: user.avatarUrlThumb) {
				cell.profileImageView.pin_setImage(from: url)
			}
		}
		
		cell.rateView.rating = Float(review.businessRating)
		
		return cell
	}
	
	func expandableTableView(_ expandableTableView: ExpandableTableView, heightForRowAtExpandableIndexPath expandableIndexPath: ExpandableIndexPath) -> CGFloat {
		return 60
	}
    
	func expandableTableView(_ expandableTableView: ExpandableTableView, estimatedHeightForRowAtExpandableIndexPath expandableIndexPath: ExpandableIndexPath) -> CGFloat {
		return 50
	}
    
	func expandableTableView(_ expandableTableView: ExpandableTableView, didSelectRowAtExpandableIndexPath expandableIndexPath: ExpandableIndexPath) { }
	
	// Subrows
	func expandableTableView(_ expandableTableView: ExpandableTableView, numberOfSubRowsInRowAtExpandableIndexPath expandableIndexPath: ExpandableIndexPath) -> Int {
		return 1
	}
    
	func expandableTableView(_ expandableTableView: ExpandableTableView, subCellForRowAtExpandableIndexPath expandableIndexPath: ExpandableIndexPath) -> UITableViewCell {

		let cell = expandableTableView.dequeueReusableCellWithIdentifier("ReviewCommentSubRowTableViewCell", forIndexPath: expandableIndexPath) as!ReviewCommentSubRowTableViewCell
		
		let review = reviewList.reviews[expandableIndexPath.row]
		
		cell.commentLabel.text = review.comment
		
		return cell
	}
    
	func expandableTableView(_ expandableTableView: ExpandableTableView, heightForSubRowAtExpandableIndexPath expandableIndexPath: ExpandableIndexPath) -> CGFloat {
		return 60
	}
	
	func expandableTableView(_ expandableTableView: ExpandableTableView, estimatedHeightForSubRowAtExpandableIndexPath expandableIndexPath: ExpandableIndexPath) -> CGFloat {
		return 60
	}
    
	func expandableTableView(_ expandableTableView: ExpandableTableView, didSelectSubRowAtExpandableIndexPath expandableIndexPath: ExpandableIndexPath) { }
	
	func showContent(indexPath: IndexPath) {
		unexpandAllCells()
		
		tableView(expandableTableView, didSelectRowAt: indexPath)
	}
}
