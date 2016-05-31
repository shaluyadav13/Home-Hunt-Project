//
//  UserLogin.swift
//  HomeHunt
//
//  Created by Pullagurla,Mounika on 3/10/16.
//  Copyright © 2016 Pullagurla,Mounika. All rights reserved.
//

import Foundation
class UserLogin:NSObject{
    var email:String
    var password:String
    
    init(email:String, password:String) {
        self.email = email
       self.password = password
    }

}