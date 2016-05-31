//
//  Posts.swift
//  HomeHunt
//
//  Created by Yadav,Shalu on 3/13/16.
//  Copyright © 2016 Pullagurla,Mounika. All rights reserved.
//

import Foundation
import UIKit

class OwnerPosts:NSObject {
    var userId:NSString!
    var address:NSString!
    var rent:NSNumber!
    var capacityInBHK:NSNumber!
    var distanceFromUniversity:NSNumber!
    var leaseAvailableFrom:NSString!
    var Amenities:NSString!
    var petsAllowed:NSNumber!
   // var imageUrl:NSString!
    var postOn:NSString!
    var ID:NSString!
    var rating:NSNumber!
    
    init(userId:NSString,address:NSString,rent:NSNumber,capacityInBHK:NSNumber,distanceFromUniversity:NSNumber,leaseAvailableFrom:NSString,Amenities:NSString,petsAllowed:NSNumber,postOn:NSString,rating:Int){
        self.userId = userId
        self.address = address
        self.rent = rent
        self.capacityInBHK = capacityInBHK
        self.distanceFromUniversity = distanceFromUniversity
        self.leaseAvailableFrom = leaseAvailableFrom
        self.Amenities = Amenities
        self.petsAllowed = petsAllowed
       // self.imageUrl = imageUrl
        self.postOn = postOn
        self.rating = rating
    }
    
    convenience init(ID:NSString) {
        self.init()
        self.ID = ID
    }
    
    override init() {
        self.userId = ""
        self.address = ""
        self.rent = 0
        self.capacityInBHK = 0
        self.distanceFromUniversity = 0
        self.leaseAvailableFrom = ""
        self.Amenities = ""
        self.petsAllowed = 0
       // self.imageUrl = ""
        self.rating = 0
        
    }
    
    override func hostToKinveyPropertyMapping() -> [NSObject : AnyObject]! {
        return [
           "ID" : KCSEntityKeyId, //the required _id field
            "userId" : "userId",
            "address" : "address",
            "rent" : "rent",
            "capacityInBHK" : "capacityInBHK",
            "distanceFromUniversity" : "distanceFromUniversity",
            "leaseAvailableFrom" : "leaseAvailableFrom",
            "Amenities" : "Amenities",
            "petsAllowed" : "petsAllowed",
           // "imageUrl" : "imageUrl",
            "postOn" : "postOn",
            "rating" : "rating"
            
        ]
    }
}