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
    @objc dynamic var employmentName = ""
    @objc dynamic var petId = 0
    @objc dynamic var businessId = ""
    @objc dynamic var employmentId = ""
    @objc dynamic var serviceId = ""
    
    static func jsonKeyPathsByPropertyKey() -> [AnyHashable : Any]! {
        return ["id": "id",
                "type": "type",
                "date": "attributes.date",
                "serviceName": "attributes.service_name",
                "employmentName": "attributes.employment_name",
                "petId": "attributes.pet_id",
                "businessId": "relationships.business.data.id",
                "employmentId": "relationships.employment.data.id",
                "serviceId": "relationships.service.data.id"]
    }
}

class Included: MTLModel, MTLJSONSerializing {
    
    @objc dynamic var id = ""
    @objc dynamic var type = ""
    @objc dynamic var name = ""
    @objc dynamic var avatar = ""
    @objc dynamic var slug = ""
    @objc dynamic var kind = ""
    @objc dynamic var photo = ""
    @objc dynamic var categoryId = ""
    
    static func jsonKeyPathsByPropertyKey() -> [AnyHashable : Any]! {
        return ["id": "id",
                "type": "type",
                "name": "attributes.name",
                "avatar": "attributes.avatar.avatar.tiny.url",
                "slug": "attributes.slug",
                "kind": "attributes.kind",
                "photo": "attributes.photo.thumb.url",
                "categoryId": "relationships.service_category.data.id"]
    }
}


class ReviewableList: MTLModel, MTLJSONSerializing {
    
    @objc dynamic var reviewables = [Reviewable]()
    @objc dynamic var included = [Included]()
    
    static func jsonKeyPathsByPropertyKey() -> [AnyHashable : Any]! {
        return ["reviewables": "data",
                "included": "included"]
    }
    
    @objc static func reviewablesJSONTransformer() -> ValueTransformer {
        return MTLJSONAdapter.arrayTransformer(withModelClass: Reviewable.self)
    }
    
    @objc static func includedJSONTransformer() -> ValueTransformer {
        return MTLJSONAdapter.arrayTransformer(withModelClass: Included.self)
    }

}
