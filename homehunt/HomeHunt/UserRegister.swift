//
//  Register.swift
//  HomeHunt
//
//  Created by Pullagurla,Mounika on 3/9/16.
//  Copyright © 2016 Pullagurla,Mounika. All rights reserved.
//

import Foundation


//enum Role:String{
//    case TENANT="Tenant"
//    case LANDLORD="LandLord"
//}

class UserRegister :NSObject {
    var firstName:String!
    var lastName:String!
    var emailID:String!
    var password:String!
    var confirmPassword:String!
    var role:String!
    var entityId: String? // Kinvey entity _id -- had to add this
    
    
    init(firstName:String, lastName:String, emailID:String, password:String, confirmPassword:String,role:String){
        self.firstName = firstName
        self.lastName = lastName
        self.emailID = emailID
        self.password = password
        self.confirmPassword = confirmPassword
        self.role = role
        
    }
    override init() {
        super.init()
    }
    //    init(firstName:String){
    //        self.firstName = firstName
    //    }
    //    init(lastName:String){
    //        self.lastName = lastName
    //    }
    //    init(emailID:String){
    //        self.emailID = emailID
    //    }
    //    init(password:String){
    //        self.password = password
    //    }
    //    init(confirmPassword:String){
    //        self.confirmPassword = confirmPassword
    //    }
    //    init(role:Role){
    //        self.role = role
    //    }
    
    override func hostToKinveyPropertyMapping() -> [NSObject : AnyObject]! {
        return [
            "entityId" : KCSEntityKeyId, //the required _id field
            "firstName" : "first_name",
            "lastName" : "last_name",
            "emailID" : "email",
            "password" : "password",
            "role" : "role"
        ]
    }
    
    //    func isValidEmail(username:String) -> Bool {
    //        // println("validate calendar: \(testStr)")
    //        let emailRegEx = "^[a-zA-Z0-9.!#$%&'*+/=?^_`{|}~-]+@[a-zA-Z0-9](?:[a-zA-Z0-9-]{0,61}[a-zA-Z0-9])?(?:\\.[a-zA-Z0-9](?:[a-zA-Z0-9-]{0,61}[a-zA-Z0-9])?)*$"
    //
    //        let emailTest = NSPredicate(format:"SELF MATCHES %@", emailRegEx)
    //        return emailTest.evaluateWithObject(username)
    //
    //    }
}