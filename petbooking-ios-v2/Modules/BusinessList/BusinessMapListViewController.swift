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
	
	var businessListType: BusinessListType?
    var service: ServiceCategory?

	var locationManager: CLLocationManager?
	var businessesCallout = [Business]()
	var coordinates:CLLocationCoordinate2D = CLLocationCoordinate2D()
	
	@IBOutlet weak var mapView: MKMapView!
	
    override func viewDidLoad() {
        super.viewDidLoad()
        
        mapView.delegate = self
        locationManager = CLLocationManager()
        
        locationManager?.delegate = self
        
        // Ask for Authorisation from the User.
        self.locationManager?.requestAlwaysAuthorization()
        
        // For use in foreground
        self.locationManager?.requestWhenInUseAuthorization()
    }
	
	override func viewWillAppear(_ animated: Bool) {
		super.viewWillAppear(animated)
        
        locationManager?.startUpdatingLocation()
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
		
		presenter?.getBusinessByCoordinates(coordinates: self.coordinates, service: service, page: 1)
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
		
        if businessAnnotation.business.imported {
            annotationView!.image = UIImage(named: "business_pin_imported")
        } else {
            annotationView!.image = UIImage(named: "business_pin")
        }
		
		return annotationView
	}
	
	func mapView(_ mapView: MKMapView, didSelect view: MKAnnotationView) {
		guard let annotation  = view.annotation as? BussinessAnnotation else { return }
		
		businessesCallout = [annotation.business]
	}
	
	func mapView(_ mapView: MKMapView, didDeselect view: MKAnnotationView) {
		view.layoutIfNeeded()
	}
}
