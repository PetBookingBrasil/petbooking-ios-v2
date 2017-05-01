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

	dynamic var userId:String = ""
	dynamic var acceptsEmail:Bool = false
	dynamic var acceptsPush:Bool = false
	dynamic var acceptsSms:Bool = false
	dynamic var authToken:String = ""
	dynamic var avatarUrlLarge:String = ""
	dynamic var avatarUrlMedium:String = ""
	dynamic var avatarUrlThumb:String = ""
	dynamic var avatarUrlTiny:String = ""
	dynamic var birthday:String = ""
	dynamic var city:String = ""
	dynamic var cpf:String = ""
	dynamic var email:String = ""
	dynamic var gender:String = ""
	dynamic var name:String = ""
	dynamic var neighborhood:String = ""
	dynamic var nickname:String = ""
	dynamic var phone:String = ""
	dynamic var state:String = ""
	dynamic var street:String = ""
	dynamic var streetNumber:String = ""
	dynamic var zipcode:String = ""
	dynamic var validForScheduling:Bool = false
	
	
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
			"streetNumber": "data.attributes.street_number",
			"zipcode": "data.attributes.zipcode",
			"validForScheduling": "data.attributes.valid_for_scheduling",
		]
	}
}

class UserRealm: Object {
	
	dynamic var userId:String = ""
	dynamic var acceptsEmail:Bool = false
	dynamic var acceptsPush:Bool = false
	dynamic var acceptsSms:Bool = false
	dynamic var authToken:String = ""
	dynamic var avatarUrlLarge:String = ""
	dynamic var avatarUrlMedium:String = ""
	dynamic var avatarUrlThumb:String = ""
	dynamic var avatarUrlTiny:String = ""
	dynamic var birthday:String = ""
	dynamic var city:String = ""
	dynamic var cpf:String = ""
	dynamic var email:String = ""
	dynamic var gender:String = ""
	dynamic var name:String = ""
	dynamic var neighborhood:String = ""
	dynamic var nickname:String = ""
	dynamic var phone:String = ""
	dynamic var state:String = ""
	dynamic var street:String = ""
	dynamic var streetNumber:String = ""
	dynamic var zipcode:String = ""
	dynamic var validForScheduling:Bool = false
	
	override static func primaryKey() -> String? {
		return "userId"
	}
	
}
