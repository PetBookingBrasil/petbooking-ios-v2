//
//  User.swift
//  petbooking-ios-v2
//
//  Created by Ryniere S Silva on 30/04/17.
//  Copyright © 2017 Pet Booking Serviços e Desenvolvimento de Softwares SA. All rights reserved.
//

import Mantle
import Realm
import RealmSwift

class User: MTLModel, MTLJSONSerializing {
    
    @objc dynamic var userId = ""
    @objc dynamic var searchRange: Float = 0.0
    @objc dynamic var acceptsEmail = false
    @objc dynamic var acceptsPush = false
    @objc dynamic var acceptsSms = false
    @objc dynamic var authToken = ""
    @objc dynamic var avatarUrlLarge = ""
    @objc dynamic var avatarUrlMedium = ""
    @objc dynamic var avatarUrlThumb = ""
    @objc dynamic var avatarUrlTiny = ""
    @objc dynamic var birthday = ""
    @objc dynamic var city = ""
    @objc dynamic var cpf = ""
    @objc dynamic var email = ""
    @objc dynamic var gender = ""
    @objc dynamic var name = ""
    @objc dynamic var neighborhood = ""
    @objc dynamic var nickname = ""
    @objc dynamic var phone = ""
    @objc dynamic var state = ""
    @objc dynamic var street = ""
    @objc dynamic var streetNumber = ""
    @objc dynamic var complement = ""
    @objc dynamic var zipcode = ""
    @objc dynamic var validForScheduling = false
    @objc dynamic var errors = [ErrorRest]()
    
    static func jsonKeyPathsByPropertyKey() -> [AnyHashable : Any]! {
        return ["userId": "data.id",
                "searchRange": "data.attributes.search_range",
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
                "errors": "errors"]
    }
    
    @objc static func errorsJSONTransformer() -> ValueTransformer {
        return MTLJSONAdapter.arrayTransformer(withModelClass: ErrorRest.self)
    }
}

class UserRealm: Object {
    
    @objc dynamic var userId = ""
    @objc dynamic var searchRange: Float = 0.0
    @objc dynamic var acceptsEmail = false
    @objc dynamic var acceptsPush = false
    @objc dynamic var acceptsSms = false
    @objc dynamic var authToken = ""
    @objc dynamic var avatarUrlLarge = ""
    @objc dynamic var avatarUrlMedium = ""
    @objc dynamic var avatarUrlThumb = ""
    @objc dynamic var avatarUrlTiny = ""
    @objc dynamic var birthday = ""
    @objc dynamic var city = ""
    @objc dynamic var cpf = ""
    @objc dynamic var email = ""
    @objc dynamic var gender = ""
    @objc dynamic var name = ""
    @objc dynamic var neighborhood = ""
    @objc dynamic var nickname = ""
    @objc dynamic var phone = ""
    @objc dynamic var state = ""
    @objc dynamic var street = ""
    @objc dynamic var streetNumber = ""
    @objc dynamic var complement = ""
    @objc dynamic var zipcode = ""
    @objc dynamic var validForScheduling = false
    
    override static func primaryKey() -> String? {
        return "userId"
    }
}
