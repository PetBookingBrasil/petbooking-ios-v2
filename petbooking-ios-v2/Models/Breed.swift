//
//  Breed.swift
//  petbooking-ios-v2
//
//  Created by Ryniere S Silva on 31/05/17.
//  Copyright © 2017 Pet Booking Serviços e Desenvolvimento de Softwares SA. All rights reserved.
//

import Foundation
import UIKit
import Mantle

class Breed: MTLModel, MTLJSONSerializing {
	
	dynamic var id = "0"
	dynamic var kind = ""
	dynamic var name = ""
	dynamic var size = ""
	
	static func jsonKeyPathsByPropertyKey() -> [AnyHashable : Any]! {
		return [
			"id": "id",
			"kind": "attributes.kind",
			"name": "attributes.name",
			"size": "attributes.size",
		]
	}
}

class BreedList: MTLModel, MTLJSONSerializing {
	
	dynamic var breeds = [Breed]()
	
	static func jsonKeyPathsByPropertyKey() -> [AnyHashable : Any]! {
		return [
			"breeds": "data"
		]
	}
	
	static func breedsJSONTransformer() -> ValueTransformer {
		
		return MTLJSONAdapter.arrayTransformer(withModelClass: Breed.self)
		
	}
}
