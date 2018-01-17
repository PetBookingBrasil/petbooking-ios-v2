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

	@objc dynamic var id = ""
	@objc dynamic var link = ""
	@objc dynamic var itens = [CartItem]()
	@objc dynamic var totalPrice = ""

	
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
	
	@objc dynamic var id = ""
	@objc dynamic var startDate = ""
	@objc dynamic var startTime = ""
	@objc dynamic var businessId = ""
	@objc dynamic var serviceId:String = ""
	@objc dynamic var petId:String = ""
	@objc dynamic var professionalId:String = ""
	@objc dynamic var notes:String = ""
	@objc dynamic var withTransportion = false
	
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
