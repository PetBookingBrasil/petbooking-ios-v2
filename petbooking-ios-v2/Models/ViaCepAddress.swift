//
//  ViaCepAddress.swift
//  petbooking-ios-v2
//
//  Created by Ryniere S Silva on 03/05/17.
//  Copyright © 2017 Pet Booking Serviços e Desenvolvimento de Softwares SA. All rights reserved.
//

import UIKit
import Mantle

class ViaCepAddress: MTLModel, MTLJSONSerializing {
    
    @objc dynamic var zipcode:String = ""
    @objc dynamic var street:String = ""
    @objc dynamic var neighborhood:String = ""
    @objc dynamic var city:String = ""
    @objc dynamic var state:String = ""
    
    static func jsonKeyPathsByPropertyKey() -> [AnyHashable : Any]! {
        return ["zipcode": "cep",
                "street": "logradouro",
                "neighborhood": "bairro",
                "city": "localidade",
                "state": "uf"]
    }
    
}
