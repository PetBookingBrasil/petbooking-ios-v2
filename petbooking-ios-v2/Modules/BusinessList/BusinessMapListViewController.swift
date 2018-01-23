//
//  BusinessMapListViewController.swift
//  petbooking-ios-v2
//
//  Created by Ryniere S Silva on 09/07/17.
//  Copyright © 2017 Pet Booking Serviços e Desenvolvimento de Softwares SA. All rights reserved.
//

import UIKit
import MapKit
import CoreLocation
import ALLoadingView

class BusinessMapListViewController: UIViewController, BusinessListViewControllerViewProtocol {

	var presenter: BusinessListViewControllerPresenterProtocol?
	
	var businessListType: BusinessListType?

	var locationManager: CLLocationManager?
	var businessList: BusinessList = BusinessList()
	var businesses = [Business]()
	var serviceCategoryList: ServiceCategoryList = ServiceCategoryList()
	var selectedServiceCategory: ServiceCategory = ServiceCategory()
	var businessesCallout = [Business]()
	var coordinates:CLLocationCoordinate2D = CLLocationCoordinate2D()
	
	@IBOutlet weak var mapView: MKMapView!
	@IBOutlet weak var tableView: UITableView!
	@IBOutlet weak var tableViewHeightConstraint: NSLayoutConstraint!
	
	@IBOutlet weak var filterMenuView: UIView!
	@IBOutlet weak var filterMenuHeightConstraint: NSLayoutConstraint!
	@IBOutlet weak var filterPanelView: UIView!
	@IBOutlet weak var filterCollectionView: UICollectionView!
	@IBOutlet weak var filterLabel: UILabel!
	@IBOutlet weak var filterButton: UIButton!
	
    override func viewDidLoad() {
        super.viewDidLoad()
        
        filterMenuHeightConstraint.constant = 0
        filterButton.round()
        filterCollectionView.delegate = self
        filterCollectionView.dataSource = self
        filterCollectionView.register(UINib(nibName: "CategoryCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: "CategoryCollectionViewCell")
        
        mapView.delegate = self
        locationManager = CLLocationManager()
        
        locationManager?.delegate = self
        
        // Ask for Authorisation from the User.
        self.locationManager?.requestAlwaysAuthorization()
        
        // For use in foreground
        self.locationManager?.requestWhenInUseAuthorization()
        
        tableView.register(UINib(nibName: "BusinessTableViewCell", bundle: nil), forCellReuseIdentifier: "BusinessTableViewCell")
        tableView.register(UINib(nibName: "BusinessImportedTableViewCell", bundle: nil), forCellReuseIdentifier: "BusinessImportedTableViewCell")
        tableView.rowHeight = UITableViewAutomaticDimension
        tableView.estimatedRowHeight = 2000
        
        PetbookingAPI.sharedInstance.getCategoryList { (serviceCategoryList, message) in
            guard let serviceCategoryList = serviceCategoryList else {
                return
            }
            
            self.serviceCategoryList = serviceCategoryList
            self.filterCollectionView.reloadData()
        }
    }
	
	override func viewWillAppear(_ animated: Bool) {
		super.viewWillAppear(animated)
        
		if selectedServiceCategory.id.isBlank {
			locationManager?.startUpdatingLocation()
		}
	}

	func updateBusinessList(businessList: BusinessList) {
        businessList.businesses.forEach { (business) in
            let annotation = BussinessAnnotation()
            annotation.business = business
            annotation.title = business.name
            
            annotation.coordinate = CLLocationCoordinate2D(latitude: business.location.latitude, longitude: business.location.longitude)
            mapView.addAnnotation(annotation)
        }
	}
	
	func removedFromFavorites(business: Business) { }
	
	@IBAction func openFilter(_ sender: Any) {
		filterPanelView.isHidden = false
	}
	
	@IBAction func closeFilter(_ sender: Any) {
		filterPanelView.isHidden = true
	}
	
	@IBAction func resetFilter(_ sender: Any) {
		filterMenuHeightConstraint.constant = 0
		filterMenuView.isHidden = true
		selectedServiceCategory = ServiceCategory()
		
		if CLLocationManager.locationServicesEnabled() {
			locationManager?.delegate = self
			locationManager?.desiredAccuracy = kCLLocationAccuracyNearestTenMeters
			locationManager?.startUpdatingLocation()
		}
		
	}
	
	@IBAction func filter(_ sender: Any) {
		
		ALLoadingView.manager.showLoadingView(ofType: .basic, windowMode: .fullscreen)
		
        guard !selectedServiceCategory.id.isBlank else { return }
		
		filterMenuView.isHidden = false
		filterMenuHeightConstraint.constant = 50
		var filterLabelText = ""
		
		if !selectedServiceCategory.id.isBlank {
			if !filterLabelText.isEmpty {
				filterLabelText.append(", ")
			}
			
			filterLabelText.append("\(selectedServiceCategory.name)")
		}
		
		filterLabel.text = filterLabelText
		
		PetbookingAPI.sharedInstance.getBusinessListFiltered(query: "", categoryId: selectedServiceCategory.id, page: 0) { (businessList, message) in
			
			ALLoadingView.manager.hideLoadingView()
			
			guard let businessList = businessList else { return }
			
			self.businessList = businessList
			self.mapView.removeAnnotations(self.mapView.annotations)
            
            businessList.businesses.forEach { (business) in
                let annotation = BussinessAnnotation()
                annotation.business = business
                annotation.title = business.name
                
                annotation.coordinate = CLLocationCoordinate2D(latitude: business.location.latitude, longitude: business.location.longitude)
                self.mapView.addAnnotation(annotation)
            }
			
			self.filterPanelView.isHidden = true
		}
	}
}

extension BusinessMapListViewController: CLLocationManagerDelegate {
	
	
	func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
		locationManager?.stopUpdatingLocation()
 	}
	
	func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
		locationManager?.stopUpdatingLocation()
		
		let locationArray = locations as NSArray
		let locationObj = locationArray.lastObject as! CLLocation
		self.coordinates = locationObj.coordinate
		
		let coordinateRegion = MKCoordinateRegionMakeWithDistance(locationObj.coordinate, 1000, 1000)
		mapView.setRegion(coordinateRegion, animated: true)
		
		
		presenter?.getBusinessByCoordinates(coordinates: self.coordinates, page:1)
	}
}

extension BusinessMapListViewController: MKMapViewDelegate {
	
	func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
		
		guard let businessAnnotation = annotation as? BussinessAnnotation else { return nil }
 
		var annotationView = mapView.dequeueReusableAnnotationView(withIdentifier: "demo")
		
        if annotationView == nil {
			annotationView = MKAnnotationView(annotation: annotation, reuseIdentifier: "demo")
			annotationView!.canShowCallout = true
		} else {
			annotationView!.annotation = annotation
		}
		
		annotationView!.image = businessAnnotation.business.imported ? UIImage(named: "business_pin_imported") : UIImage(named: "business_pin")
		
		return annotationView
	}
	
	func mapView(_ mapView: MKMapView, didSelect view: MKAnnotationView) {
		guard let annotation  = view.annotation as? BussinessAnnotation else { return }
		
		businessesCallout = [annotation.business]
		
		tableView.reloadData()
	}
	
	func mapView(_ mapView: MKMapView, didDeselect view: MKAnnotationView) {
		tableViewHeightConstraint.constant = 1
		view.layoutIfNeeded()
	}
}

extension BusinessMapListViewController: UITableViewDelegate, UITableViewDataSource, BusinessTableViewCellDelegate {
	
	func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
		return businessesCallout.count
	}
	
	public func numberOfSections(in tableView: UITableView) -> Int {
		return 1
	}
	
	func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
		let business = businessesCallout[indexPath.row]
		
		if business.imported {
			return 105
		}
        
		return UITableViewAutomaticDimension
	}

	func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
		let business = businessesCallout[indexPath.row]
        
		if business.imported {
			return getImportedBusinessCell(indexPath: indexPath)
		} else {
			return getBusinessCell(indexPath: indexPath)
		}
	}
	
	func getBusinessCell(indexPath: IndexPath) -> BusinessTableViewCell {
		
		let cell = tableView.dequeueReusableCell(withIdentifier: "BusinessTableViewCell") as! BusinessTableViewCell
		
		let business = businessesCallout[indexPath.row]
		cell.delegate = self
		
		cell.business = business
		cell.setFavorite(isFavorite: business.isFavorited())
		cell.nameLabel.text = business.name
		cell.addressLabel.text = "\(business.street), \(business.streetNumber), \(business.neighborhood)"
		cell.distanceLabel.text = "\(business.distance)km"
		cell.distanceLabel.sizeToFit()
		cell.distanceView.round()
		cell.distanceView.setBorder(width: 1, color: .red)
		cell.ratingLabel.text = "\(business.rating)"
		cell.reviewQuantityLabel.text = "\(business.ratingCount) Avaliações"
		
		cell.businessImageView.image = UIImage(named: "business-placeholder-image")
		if let url = URL(string: business.photoThumbUrl) {
			cell.businessImageView.pin_setImage(from: url)
		}
		
		tableViewHeightConstraint.constant = cell.frame.size.height
		view.layoutIfNeeded()
		
		return cell
	}
	
	func getImportedBusinessCell(indexPath: IndexPath) -> BusinessImportedTableViewCell {
		let cell = tableView.dequeueReusableCell(withIdentifier: "BusinessImportedTableViewCell") as! BusinessImportedTableViewCell
		
		let business = businessesCallout[indexPath.row]
		cell.delegate = self
		
		if business.phone.isBlank {
			cell.callButton.isHidden = true
		} else {
			cell.callButton.isHidden = false
		}
		
		cell.business = business
		cell.setFavorite(isFavorite: business.isFavorited())
		cell.nameLabel.text = business.name
		cell.addressLabel.text = "\(business.street), \(business.streetNumber), \(business.neighborhood)"
		cell.distanceLabel.text = "\(business.distance)km"
		cell.distanceLabel.sizeToFit()
		cell.distanceView.round()
		cell.distanceView.setBorder(width: 1, color: .red)
		
		tableViewHeightConstraint.constant = cell.frame.size.height
		view.layoutIfNeeded()
		
		return cell
	}
	
	func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
		tableView.deselectRow(at: indexPath, animated: true)
		
		let business = businessesCallout[indexPath.row]
		
		if business.imported {
			return
		}
		
		presenter?.showBusinessPage(business: business)
	}

	func addToFavorites(business: Business) {
		presenter?.addToFavorites(business: business)
	}
}

extension BusinessMapListViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
	
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
		let totalSpace = flowLayout.sectionInset.left
			+ flowLayout.sectionInset.right
			+ (flowLayout.minimumInteritemSpacing * CGFloat(numberOfItemsPerRow - 1))
		let size = Int((collectionView.bounds.width - totalSpace) / CGFloat(numberOfItemsPerRow))
		
		return CGSize(width: size, height: 60)
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
		
		let service = serviceCategoryList.categories[indexPath.row]
		
		cell.isSelected = service == selectedServiceCategory
		if service == selectedServiceCategory {
			collectionView.selectItem(at: indexPath, animated: false, scrollPosition: .left)
		}
		
		cell.nameLabel.text = service.name
		cell.pictureImageView.image = UIImage(named: service.slug)
		
		return cell
	}
	
	func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
		let service = serviceCategoryList.categories[indexPath.item]
		
		selectedServiceCategory = service
	}
}
