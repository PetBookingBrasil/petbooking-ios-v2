//
//  ReturnRest.swift
//  petbooking-ios-v2
//
//  Created by David Batista on 27/07/2018.
//  Copyright © 2018 Pet Booking Serviços e Desenvolvimento de Softwares SA. All rights reserved.
//

import Mantle

class ReturnRest: MTLModel, MTLJSONSerializing {
    
    @objc var message = ""
    @objc var errors = [Any]()
    
    static func jsonKeyPathsByPropertyKey() -> [AnyHashable : Any]! {
        return ["message": "message",
                "errors": "errors"]
    }
}
