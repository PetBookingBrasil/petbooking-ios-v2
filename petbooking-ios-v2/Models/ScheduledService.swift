//
//  ScheduledService.swift
//  petbooking-ios-v2
//
//  Created by Ryniere S Silva on 08/08/17.
//  Copyright © 2017 Pet Booking Serviços e Desenvolvimento de Softwares SA. All rights reserved.
//

import UIKit
import Mantle

class ScheduledService: MTLModel, MTLJSONSerializing {
    
    @objc dynamic var id = 0
    @objc dynamic var state = ""
    @objc dynamic var message = ""
    @objc dynamic var startTime = ""
    @objc dynamic var endTime = ""
    @objc dynamic var duration = 0
    @objc dynamic var businessId = 0
    @objc dynamic var businessName = ""
    @objc dynamic var serviceId = 0
    @objc dynamic var serviceName = ""
    @objc dynamic var serviceDescription = ""
    @objc dynamic var subServices = [SubService]()
    @objc dynamic var petId = 0
    @objc dynamic var professionalName = ""
    @objc dynamic var professionalId = 0
    @objc dynamic var professionalPicture = ""
    @objc dynamic var notes:String = ""
    @objc dynamic var withTransportion = false
    @objc dynamic var paid = false
    @objc dynamic var price = 0.0
    
    static func jsonKeyPathsByPropertyKey() -> [AnyHashable : Any]! {
        return ["id": "id",
                "state": "aasm_state",
                "message": "message",
                "startTime": "starts_at",
                "endTime": "ends_at",
                "duration": "duration",
                "professionalName": "employment_name",
                "professionalId": "employment_id",
                "professionalPicture": "employment_avatar.thumb.url",
                "paid": "paid",
                "businessId": "business_id",
                "businessName": "business_name",
                "serviceId": "service.id",
                "price": "service.price",
                "serviceName": "service.name",
                "serviceDescription": "service.description",
                "subServices": "service.additional_services",
                "petId": "pet_id",
                "notes": "notes",
                "withTransportion": "with_transportation"]
    }
    
    @objc static func subServicesJSONTransformer() -> ValueTransformer {
        return MTLJSONAdapter.arrayTransformer(withModelClass: SubService.self)
    }
}

class ScheduledPet: MTLModel, MTLJSONSerializing {
    
    @objc dynamic var id = 0
    @objc dynamic var name = ""
    @objc dynamic var type = ""
    @objc dynamic var photoThumbUrl = ""
    @objc dynamic var services = [ScheduledService]()
    
    static func jsonKeyPathsByPropertyKey() -> [AnyHashable : Any]! {
        return ["id": "id",
                "name": "name",
                "type":"kind",
                "photoThumbUrl": "photo.thumb.url",
                "services": "events"]
    }
    
    @objc static func servicesJSONTransformer() -> ValueTransformer {
        return MTLJSONAdapter.arrayTransformer(withModelClass: ScheduledService.self)
    }
}

class ScheduledDate: MTLModel, MTLJSONSerializing {
    
    @objc var date = Date()
    @objc var dateKey = ""
    @objc var scheduledPets = [ScheduledPet]()
    
    static func jsonKeyPathsByPropertyKey() -> [AnyHashable : Any]! {
        return ["date": "date",
                "dateKey": "date",
                "scheduledPets": "pets"]
    }
    
    @objc static func dateJSONTransformer() -> ValueTransformer {
        
        let _forwardBlock: MTLValueTransformerBlock? = { (value, success, error) in
            if let dateString = value as? String{
                let dateFormatter = DateFormatter()
                dateFormatter.dateFormat = "yyyy-MM-dd"
                
                guard let date = dateFormatter.date(from: dateString) else { return Date() }
                
                return date
                
            }
            
            return Date()
        }
        
        return MTLValueTransformer(usingForwardBlock: _forwardBlock)
    }
    
    @objc static func scheduledPetsJSONTransformer() -> ValueTransformer {
        return MTLJSONAdapter.arrayTransformer(withModelClass: ScheduledPet.self)
    }
}

class ScheduledServiceList: MTLModel, MTLJSONSerializing {
    
    @objc var scheduledDates = [ScheduledDate]()
    @objc var page = 0
    
    static func jsonKeyPathsByPropertyKey() -> [AnyHashable : Any]! {
        return ["scheduledDates": "data"]
    }
    
    @objc static func scheduledDatesJSONTransformer() -> ValueTransformer {
        return MTLJSONAdapter.arrayTransformer(withModelClass: ScheduledDate.self)
    }
}
