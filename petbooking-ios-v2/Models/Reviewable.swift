//
//  Reviewable.swift
//  petbooking-ios-v2
//
//  Created by David Batista on 21/04/2018.
//  Copyright © 2018 Pet Booking Serviços e Desenvolvimento de Softwares SA. All rights reserved.
//

import Mantle

class Reviewable: MTLModel, MTLJSONSerializing {
    
    @objc dynamic var id = ""
    @objc dynamic var type = ""
    @objc dynamic var date = ""
    @objc dynamic var serviceName = ""
    @objc dynamic var professionalName = ""
    @objc dynamic var employmentName = ""
    @objc dynamic var petId = ""
    @objc dynamic var businessId = ""
    @objc dynamic var employmentId = ""
    @objc dynamic var serviceId = ""
    
    static func jsonKeyPathsByPropertyKey() -> [AnyHashable : Any]! {
        return ["id": "id",
                "type": "type",
                "date": "attributes.date",
                "serviceName": "attributes.service_name",
                "professionalName": "attributes.professional_name",
                "employmentName": "attributes.employment_name",
                "petId": "attributes.pet_id",
                "businessId": "relationships.business.data.id",
                "employmentId": "relationships.employment.data.id",
                "serviceId": "relationships.service.data.id"]
    }
}

class ReviewableList: MTLModel, MTLJSONSerializing {
    
    @objc dynamic var reviewable = [Reviewable]()
    
    static func jsonKeyPathsByPropertyKey() -> [AnyHashable : Any]! {
        return ["reviewable": "data"]
    }
    
    @objc static func petsJSONTransformer() -> ValueTransformer {
        return MTLJSONAdapter.arrayTransformer(withModelClass: Pet.self)
    }
}
