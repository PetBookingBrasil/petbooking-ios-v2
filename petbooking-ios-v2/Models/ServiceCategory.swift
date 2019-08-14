//
//  ServiceCategory.swift
//  petbooking-ios-v2
//
//  Created by Ryniere S Silva on 26/07/17.
//  Copyright © 2017 Pet Booking Serviços e Desenvolvimento de Softwares SA. All rights reserved.
//

import UIKit
import Mantle

class ServiceCategory: MTLModel, MTLJSONSerializing {

    @objc var id = ""
    @objc var name = ""
    @objc var mobileThumb = ""
    @objc var templateIcon = ""
    @objc var slug = ""

	static func jsonKeyPathsByPropertyKey() -> [AnyHashable : Any]! {
        return ["id": "id",
                "name": "attributes.name",
                "slug": "attributes.slug",
                "mobileThumb": "attributes.cover_image.mobile_thumb.url",
                "templateIcon": "attributes.category_template_icon.icon.mobile_thumb.url"]
	}
}

class ServiceCategoryList: MTLModel, MTLJSONSerializing {
	
    @objc var categories = [ServiceCategory]()
    
    static func jsonKeyPathsByPropertyKey() -> [AnyHashable : Any]! {
        return ["categories": "data"]
    }
    
    @objc static func categoriesJSONTransformer() -> ValueTransformer {
        return MTLJSONAdapter.arrayTransformer(withModelClass: ServiceCategory.self)
    }
}
