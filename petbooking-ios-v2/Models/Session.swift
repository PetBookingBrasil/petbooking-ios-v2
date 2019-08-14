//
//  Session.swift
//  petbooking-ios-v2
//
//  Created by Ryniere S Silva on 01/05/17.
//  Copyright © 2017 Pet Booking Serviços e Desenvolvimento de Softwares SA. All rights reserved.
//

import UIKit
import Mantle
import Realm
import RealmSwift

class Session: MTLModel, MTLJSONSerializing {
    
    @objc dynamic var userId = 0
    @objc dynamic var authToken = ""
    @objc dynamic var tokenExpiresAt: Double = 0
    @objc dynamic var validForScheduling = false
    @objc dynamic var errors = [ErrorRest]()
    
    static func jsonKeyPathsByPropertyKey() -> [AnyHashable : Any]! {
        return ["userId": "data.attributes.user_id",
                "authToken": "data.attributes.token",
                "tokenExpiresAt": "data.attributes.expires_at",
                "validForScheduling": "data.attributes.user_valid_for_scheduling",
                "errors": "errors"]
    }
    
    @objc static func errorsJSONTransformer() -> ValueTransformer {
        return MTLJSONAdapter.arrayTransformer(withModelClass: ErrorRest.self)
    }
    
    func isValid() -> Bool {
        
        let now = Date()
        if tokenExpiresAt < now.timeIntervalSince1970 {
            return false
        }
        
        return true
    }
    
}

class SessionRealm: Object {
    
    @objc dynamic var userId:Int = 0
    @objc dynamic var authToken:String = ""
    @objc dynamic var tokenExpiresAt:Double = 0
    @objc dynamic var validForScheduling:Bool = false
    
    override static func primaryKey() -> String? {
        return "userId"
    }
}
