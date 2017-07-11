//
//  Business.swift
//  petbooking-ios-v2
//
//  Created by Ryniere S Silva on 24/06/17.
//  Copyright © 2017 Pet Booking Serviços e Desenvolvimento de Softwares SA. All rights reserved.
//

import UIKit
import Mantle
import CoreLocation

class Business: MTLModel, MTLJSONSerializing {

	dynamic var id = ""
	dynamic var type = ""
	dynamic var name = ""
	dynamic var photoUrl = ""
	dynamic var photoThumbUrl = ""
	dynamic var neighborhood:String = ""
	dynamic var distance:Double = 0.0
	dynamic var street:String = ""
	dynamic var streetNumber:String = ""
	dynamic var rating:Double  = 0.0
	dynamic var ratingCount:Int  = 0
	dynamic var location:CLLocationCoordinate2D = CLLocationCoordinate2D()
	dynamic var favoriteId = 0
	
	static func jsonKeyPathsByPropertyKey() -> [AnyHashable : Any]! {
		return [
			"id": "id",
			"type": "type",
			"name": "attributes.name",
			"neighborhood": "attributes.neighborhood",
			"street": "attributes.street",
			"streetNumber": "attributes.street_number",
			"distance": "attributes.distance",
			"rating": "attributes.rating_average",
			"ratingCount": "attributes.rating_count",
			"photoUrl": "attributes.cover_image.url",
			"photoThumbUrl": "attributes.cover_image.thumb.url",
			"location": "attributes.location",
			"favoriteId": "attributes.user_favorite.id"
		]
	}
	
	class func distanceJSONTransformer() -> ValueTransformer {
		let _forwardBlock: MTLValueTransformerBlock? = { (value, success, error) in
			
			guard let distance = value else {
				return 0.0
			}
			
			return distance
		}
		
		return MTLValueTransformer(usingForwardBlock: _forwardBlock)
	}
	
	class func locationJSONTransformer() -> ValueTransformer {
		
		let _forwardBlock: MTLValueTransformerBlock? = { (value, success, error) in
			
			guard let location = value as? [String] else {
				return CLLocationCoordinate2D()
			}
			
			guard let latitudeStr = location.first else {
				return CLLocationCoordinate2D()
			}
			
			guard let longitudeStr = location.last else {
				return CLLocationCoordinate2D()
			}
			
			if let latitude = Double(latitudeStr), let longitude = Double(longitudeStr) {
				
				return CLLocationCoordinate2D(latitude: latitude, longitude: longitude)
				
			}
			
			
			return CLLocationCoordinate2D()
		}
		
		return MTLValueTransformer(usingForwardBlock: _forwardBlock)
	}
	
	class func favoriteIdJSONTransformer() -> ValueTransformer {
		
		let _forwardBlock: MTLValueTransformerBlock? = { (value, success, error) in
			
			guard let id = value as? NSNumber else {
				return 0
			}
			
			return id.intValue
		}
		
		return MTLValueTransformer(usingForwardBlock: _forwardBlock)
	}
	
	func isFavorited() -> Bool {
		
		return self.favoriteId > 0
	}
	
}

class BusinessList: MTLModel, MTLJSONSerializing {
	
	dynamic var businesses = [Business]()
	dynamic var page = 0
	
	static func jsonKeyPathsByPropertyKey() -> [AnyHashable : Any]! {
		return [
			"businesses": "data"
		]
	}
	
	static func businessesJSONTransformer() -> ValueTransformer {
		
		return MTLJSONAdapter.arrayTransformer(withModelClass: Business.self)
		
	}
}
