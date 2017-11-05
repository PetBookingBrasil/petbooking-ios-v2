//
//  Cart.swift
//  petbooking-ios-v2
//
//  Created by Ryniere S Silva on 03/08/17.
//  Copyright © 2017 Pet Booking Serviços e Desenvolvimento de Softwares SA. All rights reserved.
//

import UIKit
import Mantle

class Cart: MTLModel, MTLJSONSerializing {

	dynamic var id = ""
	dynamic var link = ""
	dynamic var itens = [CartItem]()
	dynamic var totalPrice = ""

	
	static func jsonKeyPathsByPropertyKey() -> [AnyHashable : Any]! {
		return [
			"id": "data.id",
			"link": "data.links.self",
			"itens":"data.attributes.itens",
			"totalPrice":"data.attributes.total_price"
		]
	}
	
	static func itensJSONTransformer() -> ValueTransformer {
		
		return MTLJSONAdapter.arrayTransformer(withModelClass: CartItem.self)
		
	}
	
}

class CartItem: MTLModel, MTLJSONSerializing {
	
	dynamic var id = ""
	dynamic var startDate = ""
	dynamic var startTime = ""
	dynamic var businessId = ""
	dynamic var serviceId:String = ""
	dynamic var petId:String = ""
	dynamic var professionalId:String = ""
	dynamic var notes:String = ""
	dynamic var withTransportion = false
	
	static func jsonKeyPathsByPropertyKey() -> [AnyHashable : Any]! {
		return [
			"id": "id",
			"startDate": "start_date",
			"startTime": "start_time",
			"businessId": "business_id",
			"serviceId": "service_id",
			"petId": "pet_id",
			"professionalId": "professional_id",
			"notes": "notes",
			"withTransportion": "with_transportation"
		]
	}
	
}
