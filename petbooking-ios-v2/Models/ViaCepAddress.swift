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

	dynamic var zipcode:String = ""
	dynamic var street:String = ""
	dynamic var neighborhood:String = ""
	dynamic var city:String = ""
	dynamic var state:String = ""
	
	static func jsonKeyPathsByPropertyKey() -> [AnyHashable : Any]! {
		return [
			"zipcode": "cep",
			"street": "logradouro",
			"neighborhood": "bairro",
			"city": "localidade",
			"state": "uf"
		]
	}
	
}
