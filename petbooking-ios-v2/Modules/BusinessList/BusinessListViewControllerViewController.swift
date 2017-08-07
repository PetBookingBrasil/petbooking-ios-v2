//
//  BusinessListViewControllerViewController.swift
//  petbooking-ios-v2
//
//  Created Ryniere S Silva on 20/06/17.
//  Copyright © 2017 Pet Booking Serviços e Desenvolvimento de Softwares SA. All rights reserved.
//
//  Template generated by Juanpe Catalán @JuanpeCMiOS
//

import UIKit
import CoreLocation

class BusinessListViewControllerViewController: UIViewController, BusinessListViewControllerViewProtocol {
	
	@IBOutlet weak var tableView: UITableView!
	
	var presenter: BusinessListViewControllerPresenterProtocol?
	var businessListType:BusinessListType?
	var locationManager:CLLocationManager?
	var businessList:BusinessList = BusinessList()
	var businesses = [Business]()
	var coordinates:CLLocationCoordinate2D = CLLocationCoordinate2D()
	
	override func viewDidLoad() {
		super.viewDidLoad()
		
		
		switch businessListType! {
		case .favorites:
			presenter?.getFavoriteBusiness(page:1)
			title = "Favoritos"
			break
		case .list, .map:
			locationManager = CLLocationManager()
			
			locationManager?.delegate = self
			// Ask for Authorisation from the User.
			self.locationManager?.requestAlwaysAuthorization()
			
			// For use in foreground
			self.locationManager?.requestWhenInUseAuthorization()
			break
			
		}
		
		tableView.register(UINib(nibName: "BusinessTableViewCell", bundle: nil), forCellReuseIdentifier: "cell")
		tableView.rowHeight = UITableViewAutomaticDimension
		tableView.estimatedRowHeight = 2000
		
	}
	
	override func viewWillAppear(_ animated: Bool) {
		super.viewWillAppear(animated)
		
		switch businessListType! {
		case .favorites:
			break
		case .list, .map:
			
			if CLLocationManager.locationServicesEnabled() {
				locationManager?.delegate = self
				locationManager?.desiredAccuracy = kCLLocationAccuracyNearestTenMeters
				locationManager?.startUpdatingLocation()
			}
			break
			
		}

	}
	
	override func viewDidAppear(_ animated: Bool) {
		super.viewDidAppear(animated)
		
		
	}
	
	func updateBusinessList(businessList:BusinessList) {
		
		if businessList.businesses.count > 0 {
			
			self.businessList = businessList
			
			if businessList.page == 1 {
				
				
				businesses = businessList.businesses
				
				tableView.reloadData()
			} else {
				let count = self.businesses.count
				self.businesses += businessList.businesses
				
				UIView.setAnimationsEnabled(false)
				self.tableView.beginUpdates()
				let contentOffset = self.tableView.contentOffset
				
				self.tableView.insertSections(IndexSet(count...self.businesses.count - 1), with: .none)
				self.tableView.layoutIfNeeded()
				self.tableView.setContentOffset(contentOffset, animated: false)
				
				
				self.tableView.endUpdates()
				UIView.setAnimationsEnabled(true)
			}
		}
		
	}
	
	func removedFromFavorites(business: Business) {
		
		if businessListType! == .favorites {
			
			guard let index = self.businesses.index(of: business) else {
				return
			}
			self.businesses.remove(at: index)
			self.tableView.reloadData()
			
		}
		
	}
	
}

extension BusinessListViewControllerViewController: CLLocationManagerDelegate {
	
	
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
		
		
		presenter?.getBusinessByCoordinates(coordinates: self.coordinates, page:1)
		
	}
	
}

extension BusinessListViewControllerViewController: UITableViewDelegate, UITableViewDataSource, BusinessTableViewCellDelegate {
	
	func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
		
		return 1
	}
	
	
	
	func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
		
		if indexPath.section < businesses.count - 1 {
			
			switch businessListType! {
			case .favorites:
				presenter?.getFavoriteBusiness(page:businessList.page + 1)
				break
			case .list, .map:
			
				presenter?.getBusinessByCoordinates(coordinates: self.coordinates, page: businessList.page + 1)
				break
				
			}
		}
		
		let cell = tableView.dequeueReusableCell(withIdentifier: "cell") as! BusinessTableViewCell
		
		let business = businesses[indexPath.section]
		cell.delegate = self
		
		cell.business = business
		cell.setFavorite(isFavorite: business.isFavorited())
		cell.nameLabel.text = business.name
		cell.addressLabel.text = "\(business.street), \(business.streetNumber), \(business.neighborhood)"
		//cell.cityLabel.text = ""
		cell.distanceLabel.text = "\(business.distance)km"
		cell.distanceLabel.sizeToFit()
		cell.distanceView.round()
		cell.distanceView.setBorder(width: 1, color: .red)
		cell.ratingLabel.text = "\(business.rating)"
		cell.reviewQuantityLabel.text = "\(business.ratingCount) Avaliações"
		
		cell.businessImageView.image = nil
		if let url = URL(string: business.photoUrl) {
			cell.businessImageView.pin_setImage(from: url)
		}
		
		return cell
	}
	
	func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
		tableView.deselectRow(at: indexPath, animated: true)
		let business = businesses[indexPath.section]
		
		presenter?.showBusinessPage(business: business)
		
		
	}
	
	public func numberOfSections(in tableView: UITableView) -> Int {
		return businesses.count
	}
	
	// Set the spacing between sections
	func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
		
		if section == 0 {
			return 0
		}
		
		return 10
	}
	
	// Make the background color show through
	func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
		let headerView = UIView()
		headerView.backgroundColor = UIColor.clear
		return headerView
	}
	
	func addToFavorites(business: Business) {
		
		presenter?.addToFavorites(business: business)
		
	}
	
}
