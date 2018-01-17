//
//  User.swift
//  petbooking-ios-v2
//
//  Created by Ryniere S Silva on 30/04/17.
//  Copyright © 2017 Pet Booking Serviços e Desenvolvimento de Softwares SA. All rights reserved.
//

import UIKit
import Mantle
import Realm
import RealmSwift

class User: MTLModel, MTLJSONSerializing {

	@objc dynamic var userId:String = ""
	@objc dynamic var acceptsEmail:Bool = false
	@objc dynamic var acceptsPush:Bool = false
	@objc dynamic var acceptsSms:Bool = false
	@objc dynamic var authToken:String = ""
	@objc dynamic var avatarUrlLarge:String = ""
	@objc dynamic var avatarUrlMedium:String = ""
	@objc dynamic var avatarUrlThumb:String = ""
	@objc dynamic var avatarUrlTiny:String = ""
	@objc dynamic var birthday:String = ""
	@objc dynamic var city:String = ""
	@objc dynamic var cpf:String = ""
	@objc dynamic var email:String = ""
	@objc dynamic var gender:String = ""
	@objc dynamic var name:String = ""
	@objc dynamic var neighborhood:String = ""
	@objc dynamic var nickname:String = ""
	@objc dynamic var phone:String = ""
	@objc dynamic var state:String = ""
	@objc dynamic var street:String = ""
	@objc dynamic var streetNumber:String = ""
	@objc dynamic var complement:String = ""
	@objc dynamic var zipcode:String = ""
	@objc dynamic var validForScheduling:Bool = false
	@objc dynamic var errors = [ErrorRest]()
	
	
	static func jsonKeyPathsByPropertyKey() -> [AnyHashable : Any]! {
		return [
			"userId": "data.id",
			"acceptsEmail": "data.attributes.accepts_email",
			"acceptsPush": "data.attributes.accepts_push",
			"acceptsSms": "data.attributes.accepts_sms",
			"authToken": "data.attributes.auth_token",
			"avatarUrlLarge": "data.attributes.avatar.large.url",
			"avatarUrlMedium": "data.attributes.avatar.medium.url",
			"avatarUrlThumb": "data.attributes.avatar.thumb.url",
			"avatarUrlTiny": "data.attributes.avatar.tiny.url",
			"birthday": "data.attributes.birthday",
			"city": "data.attributes.city",
			"cpf": "data.attributes.cpf",
			"email": "data.attributes.email",
			"gender": "data.attributes.gender",
			"name": "data.attributes.name",
			"neighborhood": "data.attributes.neighborhood",
			"nickname": "data.attributes.nickname",
			"phone": "data.attributes.phone",
			"state": "data.attributes.state",
			"street": "data.attributes.street",
			"complement":"data.attributes.complement",
			"streetNumber": "data.attributes.street_number",
			"zipcode": "data.attributes.zipcode",
			"validForScheduling": "data.attributes.valid_for_scheduling",
			"errors": "errors"
		]
	}
}

class UserRealm: Object {
	
	@objc dynamic var userId:String = ""
	@objc dynamic var acceptsEmail:Bool = false
	@objc dynamic var acceptsPush:Bool = false
	@objc dynamic var acceptsSms:Bool = false
	@objc dynamic var authToken:String = ""
	@objc dynamic var avatarUrlLarge:String = ""
	@objc dynamic var avatarUrlMedium:String = ""
	@objc dynamic var avatarUrlThumb:String = ""
	@objc dynamic var avatarUrlTiny:String = ""
	@objc dynamic var birthday:String = ""
	@objc dynamic var city:String = ""
	@objc dynamic var cpf:String = ""
	@objc dynamic var email:String = ""
	@objc dynamic var gender:String = ""
	@objc dynamic var name:String = ""
	@objc dynamic var neighborhood:String = ""
	@objc dynamic var nickname:String = ""
	@objc dynamic var phone:String = ""
	@objc dynamic var state:String = ""
	@objc dynamic var street:String = ""
	@objc dynamic var streetNumber:String = ""
	@objc dynamic var complement:String = ""
	@objc dynamic var zipcode:String = ""
	@objc dynamic var validForScheduling:Bool = false
	
	override static func primaryKey() -> String? {
		return "userId"
	}
	
}
