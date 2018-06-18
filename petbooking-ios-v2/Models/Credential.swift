//
//  Credential.swift
//  petbooking-ios-v2
//
//  Created by David Batista on 15/05/2018.
//  Copyright © 2018 Pet Booking Serviços e Desenvolvimento de Softwares SA. All rights reserved.
//

import SwiftKeychainWrapper

struct Credential {
    let email: String
    let password: String
  
    func save() {
        KeychainWrapper.standard.set(email, forKey: "mail")
        KeychainWrapper.standard.set(password, forKey: "pass")
    }
    
    static func retrieve() -> Credential? {
        let keychain = KeychainWrapper.standard
        
        guard let email = keychain.string(forKey: "mail"),
            let password = keychain.string(forKey: "pass") else { return nil }

        return Credential(email: email, password: password)
    }
}
