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

  private var selectedBusiness: Business?
  private var constraintBottomConstant: CGFloat = 0.0
  
  @IBOutlet weak var mapView: MKMapView!
  @IBOutlet weak var businessView: UIView!
  @IBOutlet weak var constraintBusinessViewBottom: NSLayoutConstraint!

  // Business View
  @IBOutlet weak var businessImageView: UIImageView!
  @IBOutlet weak var ratingLabel: UILabel!
  @IBOutlet weak var reviewQuantityLabel: UILabel!
  @IBOutlet weak var nameLabel: UILabel!
  @IBOutlet weak var addressLabel: UILabel!
  @IBOutlet weak var distanceLabel: UILabel!
  @IBOutlet weak var favoriteButton: UIButton!
  @IBOutlet weak var starImageView: UIImageView!

  override func viewDidLoad() {
    super.viewDidLoad()
    
    mapView.delegate = self
    locationManager = CLLocationManager()
    
    locationManager?.delegate = self
    
    // Ask for Authorisation from the User.
    self.locationManager?.requestAlwaysAuthorization()
    
    // For use in foreground
    self.locationManager?.requestWhenInUseAuthorization()

    let tapGestureMapView = UITapGestureRecognizer(target: self, action: #selector(tapMapView))
    tapGestureMapView.numberOfTapsRequired = 1
    mapView.addGestureRecognizer(tapGestureMapView)

    let panGestureMapView = UIPanGestureRecognizer(target: self, action: #selector(dragBusinessView))
    businessView.addGestureRecognizer(panGestureMapView)

    let tapGestureBusinessView = UITapGestureRecognizer(target: self, action: #selector(tapBusinessView))
    tapGestureBusinessView.numberOfTapsRequired = 1
    businessView.addGestureRecognizer(tapGestureBusinessView)
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

  fileprivate func showBusinessView(forBusiness business: Business?) {
    guard let business = business else { return }
    selectedBusiness = business

    setFavorite(isFavorite: business.isFavorited())
    nameLabel.text = business.name
    addressLabel.text = "\(business.street), \(business.streetNumber), \(business.neighborhood)"
    distanceLabel.text = "\(business.distance)km"
    distanceLabel.sizeToFit()
    distanceLabel.round()
    distanceLabel.setBorder(width: 1, color: UIColor(red: 0.89, green: 0, blue: 0.17, alpha: 0.2))

    if self.businessListType == .favorites {
      distanceLabel.isHidden = true
    } else {
      distanceLabel.isHidden = false
    }

    if business.ratingCount > 0 {
      ratingLabel.isHidden = false
      reviewQuantityLabel.isHidden = false
      starImageView.isHidden = false
      ratingLabel.text = String(format: "%.2f", business.rating)
      reviewQuantityLabel.text = "\(business.ratingCount) Avaliações"
    } else {
      ratingLabel.isHidden = true
      reviewQuantityLabel.isHidden = true
      starImageView.isHidden = true
    }

    businessImageView.image = UIImage(named: "business-placeholder-image")

    if let url = URL(string: business.photoThumbUrl) {
      businessImageView.pin_setImage(from: url)
    }

    guard constraintBusinessViewBottom.constant != 0.0 else { return }
    constraintBusinessViewBottom.constant = 0.0
    UIView.animate(withDuration: 0.3) {
      self.view.layoutIfNeeded()
    }
  }

  @objc fileprivate func hideBusinessView() {
    selectedBusiness = nil
    constraintBusinessViewBottom.constant = -300
    UIView.animate(withDuration: 0.3) {
      self.view.layoutIfNeeded()
    }
  }

  fileprivate func showHomeBusiness(forBusiness business: Business) {
    let homeBusiness = HomeBusinessRouter.createModule(with: business, from: service)
    self.navigationController?.pushViewController(homeBusiness, animated: true)
  }

  @IBAction func didTapAddFavorite(_ sender: Any) {
    guard let business = self.selectedBusiness else { return }

    setFavorite(isFavorite: !business.isFavorited())
    presenter?.addToFavorites(business: business)
  }

  private func setFavorite(isFavorite:Bool) {
    let imageName = isFavorite ? "heartFilledIcon" : "heartIcon"
    favoriteButton.setBackgroundImage(UIImage(named:imageName), for: .normal)
  }

  // MARK: Gestures
  @objc private func dragBusinessView(gesture: UIPanGestureRecognizer) {
    view.layoutIfNeeded()
    let translation = gesture.translation(in: self.view)
    switch gesture.state {
    case .began:
      constraintBottomConstant = constraintBusinessViewBottom.constant
    case .changed:
      var newConstant = max(constraintBottomConstant + (-translation.y), -300)
      newConstant = min(newConstant, 0.0)
      constraintBusinessViewBottom.constant = newConstant
      self.view.layoutIfNeeded()
    case .ended, .cancelled:
      if constraintBusinessViewBottom.constant > -300.0 / 2 {
        constraintBusinessViewBottom.constant = 0
      } else if constraintBusinessViewBottom.constant < -300.0 / 2 {
        constraintBusinessViewBottom.constant = -300.0
      }
      UIView.animate(withDuration: 0.3) {
        self.view.layoutIfNeeded()
      }
    default: break
    }
  }

  @objc private func tapMapView(gesture: UITapGestureRecognizer) {
    hideBusinessView()
  }

  @objc private func tapBusinessView(gesture: UITapGestureRecognizer) {
    guard let business = selectedBusiness else { return }
    hideBusinessView()
    showHomeBusiness(forBusiness: business)
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

    var point = mapView.convert(annotation.coordinate, toPointTo: self.mapView)
    point.y += 100
    let coordinate = mapView.convert(point, toCoordinateFrom: self.mapView)

    mapView.setCenter(coordinate, animated: true)

    showBusinessView(forBusiness: annotation.business)
  }
  
  func mapView(_ mapView: MKMapView, didDeselect view: MKAnnotationView) {
    view.layoutIfNeeded()
  }
}
