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

	@objc var id = ""
	@objc var type = ""
	@objc var name = ""
	@objc var photoUrl = ""
	@objc var photoThumbUrl = ""
	@objc var neighborhood:String = ""
	@objc var distance:Double = 0.0
	@objc var street:String = ""
	@objc var streetNumber:String = ""
	@objc var rating:Double  = 0.0
	@objc var ratingCount:Int  = 0
	@objc var location:CLLocationCoordinate2D = CLLocationCoordinate2D()
	@objc var favoriteId = 0
	@objc var phone = ""
	@objc var city = ""
	@objc var businessDescription = ""
	@objc var state = ""
	@objc var website = ""
	@objc var facebook = ""
	@objc var twitter = ""
	@objc var googleplus = ""
	@objc var instagram = ""
	@objc var snapchat = ""
	@objc var imported = false
	
	static func jsonKeyPathsByPropertyKey() -> [AnyHashable : Any]! {
        return ["id": "id",
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
                "favoriteId": "attributes.user_favorite.id",
                "phone": "attributes.phone",
                "city": "attributes.city",
                "businessDescription": "attributes.description",
                "state": "attributes.state",
                "website": "attributes.website",
                "facebook": "attributes.facebook_fanpage",
                "twitter": "attributes.twitter_profile",
                "googleplus": "attributes.googleplus_profile",
                "instagram": "attributes.instagram",
                "snapchat": "attributes.snapchat",
                "imported": "attributes.imported"]
	}
		
	@objc static func distanceJSONTransformer() -> ValueTransformer {
		let _forwardBlock: MTLValueTransformerBlock? = { (value, _, _) in
			guard let distance = value else { return 0.0 }
			
			return distance
		}
		
		return MTLValueTransformer(usingForwardBlock: _forwardBlock)
	}
	
	@objc static func locationJSONTransformer() -> ValueTransformer {
		
		let _forwardBlock: MTLValueTransformerBlock? = { (value, _, _) in
			guard let location = value as? [String] else { return CLLocationCoordinate2D() }
			guard let latitudeStr = location.first else { return CLLocationCoordinate2D() }
			guard let longitudeStr = location.last else { return CLLocationCoordinate2D() }
			
			if let latitude = Double(latitudeStr), let longitude = Double(longitudeStr) {
				return CLLocationCoordinate2D(latitude: latitude, longitude: longitude)
			}
			
			return CLLocationCoordinate2D()
		}
		
		return MTLValueTransformer(usingForwardBlock: _forwardBlock)
	}
	
	@objc static func favoriteIdJSONTransformer() -> ValueTransformer {
		let _forwardBlock: MTLValueTransformerBlock? = { (value, _, _) in
			guard let id = value as? NSNumber else { return 0 }
			
			return id.intValue
		}
		
		return MTLValueTransformer(usingForwardBlock: _forwardBlock)
	}
	
	func isFavorited() -> Bool {
		return self.favoriteId > 0
	}
}

class BusinessList: MTLModel, MTLJSONSerializing {
	@objc var businesses = [Business]()
	@objc var page = 0
	
	static func jsonKeyPathsByPropertyKey() -> [AnyHashable : Any]! {
		return ["businesses": "data"]
	}
	
	@objc static func businessesJSONTransformer() -> ValueTransformer {
		return MTLJSONAdapter.arrayTransformer(withModelClass: Business.self)
	}
}
