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

class BusinessMapListViewController: UIViewController, BusinessListViewControllerViewProtocol {

	var presenter: BusinessListViewControllerPresenterProtocol?
	
	var businessListType:BusinessListType?

	var locationManager:CLLocationManager?
	var businessList:BusinessList = BusinessList()
	var businesses = [Business]()
	var businessesCallout = [Business]()
	var coordinates:CLLocationCoordinate2D = CLLocationCoordinate2D()
	
	@IBOutlet weak var mapView: MKMapView!
	@IBOutlet weak var tableView: UITableView!
	@IBOutlet weak var tableViewHeightConstraint: NSLayoutConstraint!
	
    override func viewDidLoad() {
        super.viewDidLoad()

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
    }
	
	override func viewWillAppear(_ animated: Bool) {
		super.viewWillAppear(animated)
		
		locationManager?.startUpdatingLocation()
	}

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

	func updateBusinessList(businessList:BusinessList) {
		
		for business in businessList.businesses {
			
			let annotation = BussinessAnnotation()
			annotation.business = business
			annotation.title = business.name
			
			annotation.coordinate = CLLocationCoordinate2D(latitude: business.location.latitude, longitude: business.location.longitude)
			mapView.addAnnotation(annotation)
			
		}
	}
	
	func removedFromFavorites(business: Business) {
		
		
	}

}

extension BusinessMapListViewController: CLLocationManagerDelegate {
	
	
	func locationManager(_ manager: CLLocationManager, didFailWithError error: Error)
	{
		locationManager?.stopUpdatingLocation()
		
		print(error)
	}
	
	func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation])
	{
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
		
		if !(annotation is MKPointAnnotation) {
			return nil
		}
		
		var annotationView = mapView.dequeueReusableAnnotationView(withIdentifier: "demo")
		if annotationView == nil {
			annotationView = MKAnnotationView(annotation: annotation, reuseIdentifier: "demo")
			annotationView!.canShowCallout = true
		}
		else {
			annotationView!.annotation = annotation
		}
		
		annotationView!.image = UIImage(named: "business_pin")
		
		return annotationView
		
		
	}
	
	func mapView(_ mapView: MKMapView, didSelect view: MKAnnotationView) {
		
		guard let annotation  = view.annotation as? BussinessAnnotation else {
			return
		}
		
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
		
		cell.businessImageView.image = nil
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
