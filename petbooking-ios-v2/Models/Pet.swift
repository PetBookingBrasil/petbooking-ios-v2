//
//  Pet.swift
//  petbooking-ios-v2
//
//  Created by Ryniere S Silva on 20/05/17.
//  Copyright © 2017 Pet Booking Serviços e Desenvolvimento de Softwares SA. All rights reserved.
//

import UIKit
import Mantle

class Pet: MTLModel, MTLJSONSerializing {
	
	dynamic var id = ""
	dynamic var type = ""
	dynamic var name = ""
	dynamic var breedName = ""
	dynamic var gender = ""
	dynamic var photoUrl = ""
	dynamic var photoMediumUrl = ""
	dynamic var photoThumbUrl = ""
	

	static func jsonKeyPathsByPropertyKey() -> [AnyHashable : Any]! {
		return [
			"id": "id",
			"type": "type",
			"name": "attributes.name",
			"breedName": "attributes.breed_name",
			"gender": "attributes.gender",
			"photoUrl": "attributes.photo.url",
			"photoMediumUrl": "attributes.photo.medium.url",
			"photoThumbUrl": "attributes.photo.thumb.url"
		]
	}
	
	
}

class PetList: MTLModel, MTLJSONSerializing {
	
	dynamic var pets = [Pet]()
	
	static func jsonKeyPathsByPropertyKey() -> [AnyHashable : Any]! {
		return [
			"pets": "data"
		]
	}

	static func petsJSONTransformer() -> ValueTransformer {
		
		return MTLJSONAdapter.arrayTransformer(withModelClass: Pet.self)
		
	}
}
