//
//  ViaCepAPI.swift
//  petbooking-ios-v2
//
//  Created by Ryniere S Silva on 03/05/17.
//  Copyright © 2017 Pet Booking Serviços e Desenvolvimento de Softwares SA. All rights reserved.
//

import UIKit
import Alamofire
import Mantle

class ViaCepAPI: NSObject {

	
	static let API_BASE_URL = "https://viacep.com.br/ws"
	
	static let sharedInstance = ViaCepAPI()
	
	func getAddressByZipcode(zipcode:String ,completion: @escaping (_ address: ViaCepAddress?, _ message: String) -> Void) {
		
		
		Alamofire.request("\(ViaCepAPI.API_BASE_URL)/\(zipcode)/json/").responseJSON { (response) in
			
			switch response.result{
			case .success(let jsonObject):
				print(jsonObject)
				
				
				do {
					
					if let dic = jsonObject as? [String: Any] {
						let address = try MTLJSONAdapter.model(of: ViaCepAddress.self, fromJSONDictionary: dic) as! ViaCepAddress
						completion(address, "")
					}
					
					
				} catch {
					completion(nil, error.localizedDescription)
				}
				
				break
			case .failure(let error):
				print(error)
				break
			}
			
		}
	}

}
