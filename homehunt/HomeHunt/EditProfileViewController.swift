
//  EditProfileViewController.swift
//  HomeHunt
//
//  Created by Pullagurla,Mounika on 4/13/16.
//  Copyright © 2016 Pullagurla,Mounika. All rights reserved.
//

import UIKit

class EditProfileViewController: UIViewController,OperationProtocol {
    var kinveyOperations:KinveyOperations!
    var userDetails:UserRegister!
    var owner:UserRegister!
    var ownerDetails:OwnerPosts!
    var userID:String!
    
    @IBOutlet weak var firstNameTF: UITextField!
    
    
    @IBOutlet weak var lastNameTF: UITextField!
    
    @IBOutlet weak var emailIDTF: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationItem.title = "EditProfile"
        //self.navigationItem.setHidesBackButton(true, animated: true)
        var imageView:UIImageView
        imageView = UIImageView(frame:CGRectMake(0, 0, 1000, 1000))
        imageView.image = UIImage(named:"backgroundImage.jpg")
        self.view.addSubview(imageView)
        kinveyOperations = KinveyOperations(operationProtocol: self)
        let app:AppDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
        userID = app.UserId
        userDetails = app.user
        kinveyOperations.fetchUser(userID)
        //print("in edit view did load: \(userDetails.emailID)")
        //kinveyOperations.fetchUser(ownerDetails.userId as String)
        let done = UIBarButtonItem(title: "Done", style: UIBarButtonItemStyle.Plain, target: self, action: Selector("doneEditing:"))
        done.tintColor = UIColor.blueColor()
        navigationItem.rightBarButtonItem  = done
        
    }

    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func onSuccess(Sender: AnyObject) {
        if userDetails.role == Constants.TENANT{
            let backToTenant =  self.navigationController!.storyboard?.instantiateViewControllerWithIdentifier("ownerPosts") as! TenantTableViewController
            self.navigationController?.pushViewController(backToTenant, animated: true)
        }else{
            let backToOwner =  self.navigationController!.storyboard?.instantiateViewControllerWithIdentifier("ownerPost") as! OwnerPostsTableViewController
            self.navigationController?.pushViewController(backToOwner, animated: true)
        }
    }
    func onError(message: String) {
        print(message)
        let mapVCObj:LoginViewController = self.navigationController!.storyboard?.instantiateViewControllerWithIdentifier("login") as! LoginViewController
        
        self.navigationController?.pushViewController(mapVCObj, animated: true)
        //displayAlertControllerWithError("Error!", message: message)
    }
    func noActiveUser() {
        
    }
    func fetch(ownerPost: OwnerPosts) {
        
    }
    func loginFailed() {
        
    }
    func fetchUser(user: UserRegister) {
        print("user in editprofile: \(user.firstName) \(user.emailID)")
       
        
        firstNameTF.text = user.firstName
        lastNameTF.text = user.lastName
    }
    func doneEditing(sender:AnyObject){
        print("in done:\(firstNameTF.text!)    \(lastNameTF.text!) \(userDetails.emailID)  \(userDetails.password)")
        let userEdited = UserRegister(firstName: firstNameTF.text!, lastName: lastNameTF.text!, emailID: userDetails.emailID, password: userDetails.password, confirmPassword: userDetails.password, role: userDetails.role)
        print(userEdited)
        kinveyOperations.removeAndUpdateUSer(userEdited)
        
        
    }
    
    func displayAlertControllerWithError(title:String, message:String) {
        let uiAlertController:UIAlertController = UIAlertController(title: title,
            message: message, preferredStyle: UIAlertControllerStyle.Alert)
        uiAlertController.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.Cancel,
            handler:nil))
        self.presentViewController(uiAlertController, animated: true, completion: nil)
        
    }
    /*
    // MARK: - Navigation
    
    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
    // Get the new view controller using segue.destinationViewController.
    // Pass the selected object to the new view controller.
    }
    */
    
}
