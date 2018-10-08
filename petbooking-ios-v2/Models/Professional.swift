//
//  Professional.swift
//  petbooking-ios-v2
//
//  Created by Ryniere S Silva on 31/07/17.
//  Copyright © 2017 Pet Booking Serviços e Desenvolvimento de Softwares SA. All rights reserved.
//

import UIKit
import Mantle

class Professional: MTLModel, MTLJSONSerializing {
    
    @objc dynamic var id = ""
    @objc dynamic var name = ""
    @objc dynamic var serviceCount = 0
    @objc dynamic var slug = ""
    @objc dynamic var birthday = ""
    @objc dynamic var cpf = ""
    @objc dynamic var email = ""
    @objc dynamic var gender = ""
    @objc dynamic var nickname = ""
    @objc dynamic var phone = ""
    @objc dynamic var schedule = [String: [String]]()
    @objc dynamic var photoUrl = ""
    @objc dynamic var photoMediumUrl = ""
    @objc dynamic var photoThumbUrl = ""
    
    static func jsonKeyPathsByPropertyKey() -> [AnyHashable : Any]! {
        return ["id": "id",
                "name": "attributes.name",
                "serviceCount": "attributes.service_count",
                "slug": "attributes.slug",
                "birthday": "data.attributes.birthday",
                "cpf": "attributes.cpf",
                "email": "attributes.email",
                "gender": "attributes.gender",
                "nickname": "attributes.nickname",
                "phone": "attributes.phone",
                "schedule":"attributes.available_slots",
                "photoUrl": "attributes.avatar.avatar.url",
                "photoMediumUrl": "attributes.avatar.avatar.medium.url",
                "photoThumbUrl": "attributes.avatar.avatar.thumb.url"]
    }
    
    @objc static func scheduleJSONTransformer() -> ValueTransformer {
        
        let _forwardBlock: MTLValueTransformerBlock? = { (value, success, error) in
            
            var schedule:[String: [String]] = [:]
            
            if let array = value as? [Dictionary<String, Any>]{
                
                for dic in array {
                    do {
                        let times = try MTLJSONAdapter.model(of: Times.self, fromJSONDictionary: dic) as! Times
                        schedule.updateValue(times.times, forKey: times.date)
                        
                    } catch { }
                }
            }
            
            return schedule
        }
        
        return MTLValueTransformer(usingForwardBlock: _forwardBlock)
    }
}

class ProfessionalList: MTLModel, MTLJSONSerializing {
    
    @objc dynamic var professionals = [Professional]()
    
    static func jsonKeyPathsByPropertyKey() -> [AnyHashable : Any]! {
        return ["professionals": "data"]
    }
    
    @objc static func professionalsJSONTransformer() -> ValueTransformer {
        return MTLJSONAdapter.arrayTransformer(withModelClass: Professional.self)
    }
}

class Times: MTLModel, MTLJSONSerializing {
    
    @objc dynamic var date = ""
    @objc dynamic var times = [String]()
    
    static func jsonKeyPathsByPropertyKey() -> [AnyHashable : Any]! {
        return ["date": "date",
                "times": "times"]
    }
}
