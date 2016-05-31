//
//  homeDescriptionViewController.swift
//  HomeHunt
//
//  Created by Chanati,Gowrishankar Rao on 3/16/16.
//  Copyright © 2016 Pullagurla,Mounika. All rights reserved.
//

import UIKit
import MessageUI
import MapKit

class HomeDescriptionViewController: UIViewController,MFMailComposeViewControllerDelegate,OperationProtocol {
    //let defaults = NSUserDefaults.standardUserDefvarts()
    var kinveyOperations:KinveyOperations!
    var ownerPostsDetailsObject:OwnerPosts!
    var userID:String!
    @IBOutlet weak var ownerNameLBL: UILabel!
    @IBOutlet weak var addressLBL: UILabel!
    @IBOutlet weak var rentLBL: UILabel!
    @IBOutlet weak var capacityLBL: UILabel!
    @IBOutlet weak var availableDtaeLBL: UILabel!
    @IBOutlet weak var distanceLBL: UILabel!
    @IBOutlet weak var petsAllowedLBL: UILabel!
    @IBOutlet weak var amenitiesLBL: UILabel!
    let appDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
    
    @IBOutlet weak var homeImageIV: UIImageView!
    @IBAction func goToMap(sender: AnyObject) {
        appDelegate.address = addressLBL.text
        let mapVCObj:MapViewController = self.navigationController!.storyboard?.instantiateViewControllerWithIdentifier("mapController") as! MapViewController
        
        self.navigationController?.pushViewController(mapVCObj, animated: true)

        
    }
    override func viewDidLoad() {
        print("in homeDescription view did load")
        super.viewDidLoad()
        var imageView:UIImageView
        imageView = UIImageView(frame:CGRectMake(0, 0, 1000, 1000))
        imageView.image = UIImage(named:"backgroundImage.jpg")
        self.view.addSubview(imageView)
        self.navigationItem.title = "Home Post Details "
        
        kinveyOperations = KinveyOperations(operationProtocol: self)
        let ownerDetails:AppDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
        //let userDetails:AppDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
        self.ownerPostsDetailsObject = ownerDetails.ownerDetails
        //let user = userDetails.user
        print("in home description view will appear")
        
        
        let emailBTN: UIButton = UIButton(type: UIButtonType.Custom)
        //set image for button
        emailBTN.setImage(UIImage(named: "email.png"), forState: UIControlState.Normal)
        //add function for button
        emailBTN.addTarget(self, action: Selector("contactOwner:"), forControlEvents: UIControlEvents.TouchUpInside)
        //set frame
        emailBTN.frame = CGRectMake(0, 0, 50, 50)
        emailBTN.tintColor = UIColor.blueColor()
        let emailButton = UIBarButtonItem(customView: emailBTN)
        
        let callBTN: UIButton = UIButton(type: UIButtonType.Custom)
        //set image for button
        callBTN.setImage(UIImage(named: "call.png"), forState: UIControlState.Normal)
        //add function for button
        callBTN.addTarget(self, action: Selector("callOwner:"), forControlEvents: UIControlEvents.TouchUpInside)
        //set frame
        callBTN.frame = CGRectMake(0, 0, 30, 30)
        callBTN.tintColor = UIColor.blueColor()

        let callButton = UIBarButtonItem(customView: callBTN)
   
        self.navigationItem.setRightBarButtonItems([emailButton,callButton], animated: true)
        userID = ownerPostsDetailsObject.userId as String
        print(userID)
        kinveyOperations.fetchUser(userID)
        //let ownerName = userID.componentsSeparatedByString("@")
        ownerNameLBL.text = userID
        addressLBL.text = ownerPostsDetailsObject.address as String
        rentLBL.text =  "$ " + ownerPostsDetailsObject.rent.description
        capacityLBL.text = ownerPostsDetailsObject.capacityInBHK.description
        availableDtaeLBL.text = ownerPostsDetailsObject.leaseAvailableFrom as String
        distanceLBL.text = ownerPostsDetailsObject.distanceFromUniversity.description+" miles"
        if ownerPostsDetailsObject.petsAllowed == 0{
            petsAllowedLBL.text = "no"
        }else{
            petsAllowedLBL.text = "yes"
        }
        if ownerPostsDetailsObject.Amenities == ""{
            amenitiesLBL.text = "Amenities are not specified"
        }else{
            amenitiesLBL.text = ownerPostsDetailsObject.Amenities as String
        }
        
        //----------------------------------------
        /****** Download the image from kinvey ********/
        let addressOfHome:String = ownerPostsDetailsObject.address as String
        homeImageIV.layer.borderWidth = 1.0
        homeImageIV.layer.masksToBounds = true
        homeImageIV.layer.borderColor = UIColor.whiteColor().CGColor
        homeImageIV.layer.cornerRadius = 10.0
        homeImageIV.clipsToBounds = true
        
        /***** images are stored in files Collection, so use either name/ID/URL to retrive it ****/
        print("------ ",addressOfHome)
        KCSFileStore.downloadFile(
            addressOfHome,
            options: nil,
            completionBlock: { (downloadedResources: [AnyObject]!, error: NSError!) -> Void in
                if error == nil {
                    let file = downloadedResources[0] as! KCSFile
                    let fileURL = file.localURL
                    
                    let image = UIImage(contentsOfFile: fileURL.path!) //note this blocks for awhile
                    /****** assign it to imageview to display the image ********/
                    self.homeImageIV.image = image
                    //               self.productImages.append(candidateIV.image!)
                } else {
                    NSLog("Got an error: %@", error)
                }
            },
            progressBlock: nil
        )
        
        //-----------------------------------------------
        

        
    }
    
    func onSuccess(Sender: AnyObject) {
        
    }
    func onError(message: String) {
        
    }
    func noActiveUser() {
        
    }
    func fetch(ownerPost: OwnerPosts) {
        
        
    }
    func loginFailed() {
        
    }
    func fetchUser(user: UserRegister) {
        //ownerName = user.firstName + " " + user.lastName
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        
    }
    func displayAlertControllerWithTitle(title:String, message:String) {
        let uiAlertController:UIAlertController = UIAlertController(title: title,
            message: message, preferredStyle: UIAlertControllerStyle.Alert)
        uiAlertController.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.Cancel,
            handler:nil))
        self.navigationController?.popToRootViewControllerAnimated(true)
        
    }
    
    
    
    func contactOwner(sender: AnyObject) {
        
        
        let mailComposeViewController = configuredMailComposeViewController()
        if MFMailComposeViewController.canSendMail(){
            self.presentViewController(mailComposeViewController, animated: true, completion: nil)
        } else {
            self.showSendMailErrorAlert()
        }
    }
    func callOwner(sender:AnyObject){
        let url:NSURL = NSURL(string: "tel://123456789")!
        UIApplication.sharedApplication().openURL(url)
    }
    
    func configuredMailComposeViewController() -> MFMailComposeViewController {
        let mailComposerVC = MFMailComposeViewController()
        mailComposerVC.mailComposeDelegate = self // Extremely important to set the --mailComposeDelegate-- property, NOT the --delegate-- property
        
        mailComposerVC.setToRecipients([userID])
        mailComposerVC.setSubject("Request For Home  \(ownerPostsDetailsObject.address)")
        // mailComposerVC.setMessageBody(comments.text!, isHTML: false)
        
        return mailComposerVC
    }
    
    func showSendMailErrorAlert() {
        //        let sendMailErrorAlert = UIAlertView(title: "Could Not Send Email", message: "Your device could not send e-mail.  Please check e-mail configuration and try again.", delegate: self, cancelButtonTitle: "OK")
        //        sendMailErrorAlert.show()
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








/*
// MARK: - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
// Get the new view controller using segue.destinationViewController.
// Pass the selected object to the new view controller.
}
*/


