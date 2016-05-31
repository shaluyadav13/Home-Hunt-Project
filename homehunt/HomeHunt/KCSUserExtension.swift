//
//  KCSUserExtension.swift
//  HomeHunt
//
//  Created by Pullagurla,Mounika on 3/10/16.
//  Copyright © 2016 Pullagurla,Mounika. All rights reserved.
//

import Foundation



let UserRole = "role"

extension KCSUser{
    
    var role:String {
        return self.getValueForAttribute(UserRole) as! String!
    }
    
    
}