//
//  ViewController.swift
//  HomeHunt
//
//  Created by Pullagurla,Mounika on 3/5/16.
//  Copyright © 2016 Pullagurla,Mounika. All rights reserved.
//

import UIKit
import MessageUI

class LoginViewController: UIViewController,MFMailComposeViewControllerDelegate,OperationProtocol {
    
    @IBOutlet weak var passwordTF: UITextField!
    @IBOutlet weak var emailIDTF: UITextField!
    var store:KCSAppdataStore!
    var kinveyOperations:KinveyOperations!
    var owner:OwnerPosts!
    let app:AppDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
//    let tenanttableViewController:UITableViewController = TenantTableViewController()
//    let ownerPostsTableViewController:UITableViewController  = OwnerPostsTableViewController()
    let tenantTable:UITableViewController = TenantTableViewController()
    let ownerPostsTableViewController:UITableViewController  = OwnerPostsTableViewController()
    
    @IBAction func contactUsBTN(sender: AnyObject) {
        
        let mailComposeViewController = configuredMailComposeViewController()
        if MFMailComposeViewController.canSendMail(){
            self.presentViewController(mailComposeViewController, animated: true, completion: nil)
        } else {
            self.showSendMailErrorAlert()
        }

    }
    
    @IBAction func loginBTN(sender: AnyObject) {
        let userLogin:UserLogin = UserLogin(email: emailIDTF.text!, password: passwordTF.text!)
        kinveyOperations.loginUser(userLogin)
        
    }
    override func viewDidLoad() {
        
        super.viewDidLoad()
        self.navigationItem.setHidesBackButton(true, animated: true)
        kinveyOperations = KinveyOperations(operationProtocol: self)
        self.navigationItem.setHidesBackButton(true, animated: false)
        //self.view.backgroundColor = UIColor(patternImage: UIImage(named: "backGroundImage")!)
        var imageView:UIImageView
        imageView = UIImageView(frame:CGRectMake(0, 0, 1000, 1000))
        imageView.image = UIImage(named:"backgroundImage.jpg")
        self.view.addSubview(imageView)
        emailIDTF.text = "ioscodecreators@gmail.com"
       passwordTF.text = "Iosgroup8"
//                emailIDTF.text = "pullagurlamounika@gmail.com"
//                passwordTF.text = "Mounika8"

        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func onSuccess(sender:AnyObject) {
        app.UserId = emailIDTF.text!
        let userObject = sender as! KCSUser
        
        print("name:\(userObject.givenName) \(userObject.surname)\(userObject.password)\(userObject.role)\(userObject.email)")
        if userObject.role == Constants.TENANT {
            app.user = UserRegister(firstName: userObject.givenName, lastName: userObject.surname, emailID: userObject.email, password: passwordTF.text!, confirmPassword: passwordTF.text!, role: Constants.TENANT)
            //displayAlertControllerWithTenant("Success", message: "Login Successful")
            self.navigationController?.pushViewController(tenantTable, animated: true)
        } else {
            app.user = UserRegister(firstName: userObject.givenName, lastName: userObject.surname, emailID: userObject.email, password: passwordTF.text!, confirmPassword: passwordTF.text!, role: Constants.LANDLORD)
            //displayAlertControllerWithTenant("Success", message: "Login Successful")
            self.navigationController?.pushViewController(ownerPostsTableViewController, animated: true)
        }
        
    }
    
    
    func onError(message: String) {
        print("error\(message)")
        displayAlertControllerWithTitle("Error!", message: message)
        
    }
    
    func noActiveUser() {
        print("noActiveUser")
    }
    
    func loginFailed() {
        print("login failed")
    }
    func fetch(ownerPost: OwnerPosts) {
        
    }
    func fetchUser(user: UserRegister) {
        
    }
    func displayAlertControllerWithTitle(title:String, message:String) {
        let uiAlertController:UIAlertController = UIAlertController(title: title,
            message: message, preferredStyle: UIAlertControllerStyle.Alert)
        uiAlertController.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.Cancel,
            handler:nil))
        self.presentViewController(uiAlertController, animated: true, completion: nil)
        
    }
    
 
    
    func configuredMailComposeViewController() -> MFMailComposeViewController {
        let mailComposerVC = MFMailComposeViewController()
        mailComposerVC.mailComposeDelegate = self // Extremely important to set the --mailComposeDelegate-- property, NOT the --delegate-- property
        
        mailComposerVC.setToRecipients(["ioscodecreators@gmail.com"])
        //mailComposerVC.setSubject("Request For Home  \(ownerPostsDetailsObject.address)")
        return mailComposerVC
    }
    
    func showSendMailErrorAlert() {
       
        displayAlertControllerWithFailure("Could Not Send Email", message: "Your device could not send e-mail.  Please check e-mail configuration and try again.")
    }
    
    
    
    func mailComposeController(controller: MFMailComposeViewController, didFinishWithResult result: MFMailComposeResult, error: NSError?) {
        controller.dismissViewControllerAnimated(true, completion: nil)
        
    }
    func displayAlertControllerWithFailure(title:String, message:String) {
        let uiAlertController:UIAlertController = UIAlertController(title: title,
            message: message, preferredStyle: UIAlertControllerStyle.Alert)
        uiAlertController.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.Cancel,
            handler:{(action:UIAlertAction)->Void in }))
        self.presentViewController(uiAlertController, animated: true, completion: nil)
    }
    
    
}

