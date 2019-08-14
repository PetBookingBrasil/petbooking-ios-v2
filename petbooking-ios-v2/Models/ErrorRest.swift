//
//  ErrorRest.swift
//  petbooking-ios-v2
//
//  Created by Ryniere S Silva on 01/05/17.
//  Copyright © 2017 Pet Booking Serviços e Desenvolvimento de Softwares SA. All rights reserved.
//

import UIKit
import Mantle

class ErrorRest: MTLModel, MTLJSONSerializing {
    
    @objc var errorCode = 0
    @objc var errorStatus = ""
    @objc var errorTitle = ""
    @objc var errorName = [String]()
    @objc var errorEmail = [String]()
    @objc var errorPhone = [String]()
    
    static func jsonKeyPathsByPropertyKey() -> [AnyHashable : Any]! {
        return ["errorCode": "code",
                "errorStatus": "status",
                "errorTitle": "title",
                "errorName": "detail.user.name",
                "errorEmail": "detail.user.email",
                "errorPhone": "detail.user.phone"]
    }
}
