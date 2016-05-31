//
//  KinveyOperations.swift
//  HomeHunt
//
//  Created by Pullagurla,Mounika on 3/9/16.
//  Copyright © 2016 Pullagurla,Mounika. All rights reserved.
//

import Foundation
import UIKit
@objc protocol OperationProtocol {
    func onSuccess(Sender:AnyObject)
    func onError(message:String)
    func noActiveUser()
    func loginFailed()
    func fetch(ownerPost:OwnerPosts)
    func fetchUser(user:UserRegister)
    optional func onDeleteSuccess()
    
}

class KinveyOperations {
    
    let store:KCSAppdataStore!
    let ownerPost:KCSAppdataStore!
    let operaionDelegate:OperationProtocol!
    let login:LoginViewController!
    
    
    init(operationProtocol:OperationProtocol){
        self.operaionDelegate = operationProtocol
        login = LoginViewController()
        store = KCSAppdataStore.storeWithOptions([
            KCSStoreKeyCollectionName : "RegisterUsers",
            KCSStoreKeyCollectionTemplateClass : UserRegister.self
            ])
        ownerPost = KCSAppdataStore.storeWithOptions([
            KCSStoreKeyCollectionName : "OwnerPosts",
            KCSStoreKeyCollectionTemplateClass : OwnerPosts.self
            ])
        
    }
    
    
    func saveData() {
        if let _ = KCSUser.activeUser() {
            
        }else{
            operaionDelegate.noActiveUser()
        }
    }
    
    // Mark: Save the owner Post
    
    func savePost(ownPost:OwnerPosts){
        ownerPost.saveObject(
            ownPost,
            withCompletionBlock: { (objectsOrNil: [AnyObject]!, errorOrNil: NSError!) -> Void in
                if errorOrNil != nil {
                    //save failed
                    print("Save failed, with error: %@", errorOrNil.localizedFailureReason)
                } else {
                    //save was successful
                    print("Successfully saved event (id='%@').")
                    self.operaionDelegate.onSuccess(objectsOrNil)
                }
            },
            withProgressBlock: nil
        )
    }
    
    // Mark: fetch owner posts
    func fetchOwnerPosts(userid:String){
        print("retrieving post")
        let query = KCSQuery(onField: "userId", withExactMatchForValue: userid)
        print(query.description)
        ownerPost.queryWithQuery(
            query,
            withCompletionBlock: { (objectsOrNil: [AnyObject]!, errorOrNil: NSError!) -> Void in
                
                if errorOrNil == nil {
                    print("fetching")
                    //print(objectsOrNil[0])
                    let objects = objectsOrNil as [AnyObject]
                    for object in objects{
                        let ownerPost = object as! OwnerPosts
                      //  print(ownerPost.imageUrl)
                        print(ownerPost.userId)
                        print(ownerPost.rent)
                        self.operaionDelegate.fetch(ownerPost)
                    }
                    
                }
                else{
                    print(errorOrNil.description)
                }
                
            },
            withProgressBlock: nil
        )
        
    }
    
    
    func registerUser(user:UserRegister){
        
        let userRows  = [
            UserRole:user.role,
            KCSUserAttributeGivenname : user.firstName,
            KCSUserAttributeSurname : user.lastName,
            KCSUserAttributeEmail : user.emailID
        ]
        
        
        
        KCSUser.userWithUsername(
            user.emailID,
            password:user.password,
            fieldsAndValues: userRows,
            withCompletionBlock: { (user: KCSUser!, errorOrNil: NSError!, result: KCSUserActionResult) -> Void in
                if errorOrNil == nil {
                    print("successfully saved in Users")
                    //self.operaionDelegate.onSuccess(user)
                    self.store.saveObject(
                        user,
                        withCompletionBlock: { (objectsOrNil: [AnyObject]!, errorOrNil: NSError!) -> Void in
                            if errorOrNil != nil {
                                //save failed
                                print("Save failed, with error: %@", errorOrNil.localizedFailureReason)
                                self.operaionDelegate.onError(errorOrNil.localizedFailureReason!)
                            } else {
                                //save was successful
                                print("Successfully saved event (id='%@').", (objectsOrNil[0] as! NSObject).kinveyObjectId())
                                self.emailConfirmation(user.email)
                                self.operaionDelegate.onSuccess(user)
                                
                                
                            }
                        },
                        withProgressBlock: nil
                    )
                    
                } else {
                    self.operaionDelegate.onError(errorOrNil.localizedDescription)
                }
            }
        )
        
        saveData()
        
        
    }
    
    
    
    
    //fetching login details and authenticating the user through kinvey
    
    func loginUser(userLogin:UserLogin){
        
        KCSUser.loginWithUsername(
            userLogin.email,
            password: userLogin.password,
            withCompletionBlock: { (user: KCSUser!, errorOrNil: NSError!, result: KCSUserActionResult) -> Void in
                if errorOrNil == nil {
                    print("login success")
                    self.operaionDelegate.onSuccess(user)
                    
                    
                } else {
                    //there was an error with the update save
                    print("error login")
                    let message = errorOrNil.localizedDescription
                    self.operaionDelegate.onError(message)
                }
            }
        )
        
    }
    
    //sending email confirmation after registering the user
    
    func emailConfirmation(email:String){
        print(email)
        
        let activeUser = KCSUser.activeUser()
        KCSUser.sendEmailConfirmationForUser(
            activeUser.email,
            withCompletionBlock: { (emailSent: Bool, errorOrNil: NSError!) -> Void in
                if errorOrNil != nil {
                    self.operaionDelegate.onError("Please give valid emailID")
                } // not much to do on success, for most apps
            }
        )
    }
    
    
    //fetching all owner posts from ownerPosts collection in kinvey
    func retrieveData() {
        print("inretrieve data")
        let query = KCSQuery()
        print(query.description)
        ownerPost.queryWithQuery(
            query,
            withCompletionBlock: { (objectsOrNil: [AnyObject]!, errorOrNil: NSError!) -> Void in
                
                if errorOrNil == nil{
                    print("fetching")
                    print(objectsOrNil[0])
                    
                    let objects = objectsOrNil as [AnyObject]
                    for object in objects{
                        let ownerPost = object as! OwnerPosts
                        self.operaionDelegate.fetch(ownerPost)
                    }
                    
                }
                else{
                    print(errorOrNil.description)
                }
                
            },
            withProgressBlock: nil
        )
        
    }
    
    
    //fetching register user details
    func fetchUser(email:String){
        print("retrieving user:\(email)")
        let query = KCSQuery(onField: "email", withExactMatchForValue: email)
        print(query.description)
        store.queryWithQuery(
            query,
            withCompletionBlock: { (objectsOrNil: [AnyObject]!, errorOrNil: NSError!) -> Void in
                print("error in fetch user: \(errorOrNil)")
                if errorOrNil == nil {
                    print("fetching")
                    let objects = objectsOrNil as [AnyObject]
                    for object in objects{
                        let user = object as! UserRegister
                        print(user.lastName)
                        print(user.firstName)
                        self.operaionDelegate.fetchUser(user)
                        
                    }
                }
                else{
                    self.operaionDelegate.onError(errorOrNil.description)
                }
                
            },
            withProgressBlock: nil
        )
    }
    func deletePost(owner:OwnerPosts){
        print(owner.address)
        let query = KCSQuery(onField: "address", withExactMatchForValue: owner.address)
        ownerPost.removeObject(
            query,
            withDeletionBlock: { (deletionDictOrNil: [NSObject : AnyObject]!, errorOrNil: NSError!) -> Void in
                
                if errorOrNil != nil {
                    //error occurred - add back into the list
                    print("remove:\(errorOrNil.localizedFailureReason)")
                    self.operaionDelegate.onError(errorOrNil.localizedDescription)
                } else {
                    //delete successful - UI already updated
                    
                    self.operaionDelegate.onDeleteSuccess!()
                    print("Successfully deleted")
                    self.savePost(owner)
                }
            },
            withProgressBlock: nil
        )
    }
    
    func removeAndUpdateUSer(userEdited:UserRegister){
        print(KCSUser.activeUser())
        print(userEdited.emailID)
        print(userEdited.role)
        let query = KCSQuery(onField: "email", withExactMatchForValue: userEdited.emailID)
        self.store.removeObject(
            query,
            withDeletionBlock: { (deletionDictOrNil: [NSObject : AnyObject]!, errorOrNil: NSError!) -> Void in
                
                if errorOrNil != nil {
                    //error occurred - add back into the list
                    print("remove:\(errorOrNil.localizedFailureReason)")
                    self.operaionDelegate.onError(errorOrNil.localizedDescription)
                } else {
                    //delete successful - UI already updated
                    print("Successfully deleted")
                    
                    self.store.saveObject(
                        userEdited,
                        withCompletionBlock: { (objectsOrNil: [AnyObject]!, errorOrNil: NSError!) -> Void in
                            if errorOrNil != nil {
                                //save failed
                                print("Save failed, with error: %@", errorOrNil.localizedFailureReason)
                                self.operaionDelegate.onError(errorOrNil.localizedFailureReason!)
                            } else {
                                
                                print("Successfully saved event (id='%@').", (objectsOrNil[0] as! NSObject).kinveyObjectId())
                                self.operaionDelegate.onSuccess(userEdited)
                            }
                        },
                        withProgressBlock: nil
                    )//saving in store
                }
            },
            withProgressBlock: nil
        )//removing object from store
        //        KCSUser.activeUser().removeWithCompletionBlock { (objectsOrNil: [AnyObject]!, errorOrNil: NSError!) -> Void in
        //            if errorOrNil != nil {
        //                print("something gone wrong!")
        //                //NSLog("error %@ when deleting active user", errorOrNil)
        //            } else {
        //                print("active user deleted")
        //
        //
        //            }
        //        }
        
    }
}