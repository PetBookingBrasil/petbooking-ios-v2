//
//  Banner.swift
//  petbooking-ios-v2
//
//  Created by David Batista on 27/05/19.
//  Copyright © 2019 Pet Booking Serviços e Desenvolvimento de Softwares SA. All rights reserved.
//

import Mantle
import CoreLocation

class Banner: MTLModel, MTLJSONSerializing {
    
    @objc var id = ""
    @objc var type = ""
    @objc var title = ""
    @objc var discountType = ""
    @objc var discountAmount = 0
    @objc var startDate: String? = ""
    @objc var endDate: String? = ""
    @objc var imageUrl = ""
    
    
    static func jsonKeyPathsByPropertyKey() -> [AnyHashable : Any]! {
        return ["id": "id",
                "type": "type",
                "title": "attributes.title",
                "discountType": "attributes.discount_type",
                "discountAmount": "attributes.discount_amount",
                "startDate": "attributes.start_date",
                "endDate": "attributes.end_date",
                "imageUrl": "attributes.image_url"]
    }
}

class BannerList: MTLModel, MTLJSONSerializing {
    @objc var banners = [Banner]()
    @objc var page = 0
    
    static func jsonKeyPathsByPropertyKey() -> [AnyHashable : Any]! {
        return ["banners": "data"]
    }
    
    @objc static func bannersJSONTransformer() -> ValueTransformer {
        return MTLJSONAdapter.arrayTransformer(withModelClass: Banner.self)
    }
}
