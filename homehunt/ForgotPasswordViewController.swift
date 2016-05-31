//
//  ForgotPasswordViewController.swift
//  HomeHunt
//
//  Created by Pullagurla,Mounika on 3/8/16.
//  Copyright © 2016 Pullagurla,Mounika. All rights reserved.
//

import UIKit
import MessageUI

class ForgotPasswordViewController: UIViewController , MFMailComposeViewControllerDelegate{
    var kinveyOperations:KinveyOperations!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        var imageView:UIImageView
        imageView = UIImageView(frame:CGRectMake(0, 0, 1000, 1000))
        imageView.image = UIImage(named:"backgroundImage.jpg")
        self.view.addSubview(imageView)
        
        // Do any additional setup after loading the view.
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    override func viewWillAppear(animated: Bool) {
        self.navigationItem.title = "Forgot Password"
    }
    
    
    @IBOutlet weak var emailIDTF: UITextField!
    
    //@IBOutlet weak var lastNameTF: UITextField!
    
    @IBAction func submitButtonTapped(sender: AnyObject) {
        let emailID = emailIDTF.text!
        if isValidEmail(emailID){
            var message:String
            message = "Reset email sent to your inbox : \n \(emailID)"
            
            let title:String = "Forgot Password"
            print(emailID)
            
            KCSUser.sendPasswordResetForUser(emailID, withCompletionBlock: { (succeeded: Bool, error: NSError?) -> Void in
                if error == nil {
                    if succeeded { // SUCCESSFULLY SENT TO EMAIL
                        print("Reset email sent to your inbox");
                        self.displayAlertControllerWithTitle(title, message: message)
                    }
                    else { // SOME PROBLEM OCCURED
                    }
                }
                else { //ERROR OCCURED, DISPLAY ERROR MESSAGE
                    print(error!.description)
                    self.displayAlertControllerWithFailure("Error!", message: error!.description)
                }
                
            })
 
        }else{
            displayAlertControllerWithFailure("OOPS!", message: "enter valid email")
        }
        
//        kinveyOperations.passwordReset(emailID)
    }
    func isValidEmail(username:String) -> Bool {
        let emailRegex = "^[a-zA-Z0-9.!#$%&'*+/=?^_`{|}~-]+@[a-zA-Z0-9](?:[a-zA-Z0-9-]{0,61}[a-zA-Z0-9])?(?:\\.[a-zA-Z0-9](?:[a-zA-Z0-9-]{0,61}[a-zA-Z0-9])?)*$"
        
        let emailTest = NSPredicate(format:"SELF MATCHES %@", emailRegex)
        return emailTest.evaluateWithObject(username)
        
    }
    
    func displayAlertControllerWithTitle(title:String, message:String) {
        let uiAlertController:UIAlertController = UIAlertController(title: title,
            message: message, preferredStyle: UIAlertControllerStyle.Alert)
        uiAlertController.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.Cancel,
            handler:{action in
                let login =  self.navigationController?.storyboard?.instantiateViewControllerWithIdentifier("login") as! LoginViewController
                self.navigationController?.pushViewController(login, animated: true)}))
        self.presentViewController(uiAlertController, animated: true, completion: nil)
        
    }
    func displayAlertControllerWithFailure(title:String, message:String) {
        let uiAlertController:UIAlertController = UIAlertController(title: title,
            message: message, preferredStyle: UIAlertControllerStyle.Alert)
        uiAlertController.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.Cancel,
            handler:nil))
        self.presentViewController(uiAlertController, animated: true, completion: nil)
       
        
    }
    
}



//
// MARK: - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
//func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
// Get the new view controller using segue.destinationViewController.
// Pass the selected object to the new view controller.
//}


