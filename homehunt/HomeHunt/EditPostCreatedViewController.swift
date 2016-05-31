//
//  EditPostCreatedViewController.swift
//  HomeHunt
//
//  Created by Yadav,Shalu on 4/14/16.
//  Copyright © 2016 Pullagurla,Mounika. All rights reserved.
//

import UIKit

class EditPostCreatedViewController: UIViewController, UITextFieldDelegate, UINavigationControllerDelegate, UIImagePickerControllerDelegate, OperationProtocol{
    
    var kinveyOperations:KinveyOperations!
    var ownerPostsViewController:OwnerPostsTableViewController!
    
    var toggleState:Bool = false
    
    @IBOutlet weak var imageIV: UIImageView!
    
    @IBOutlet weak var editRent: UITextField!
    
    @IBOutlet weak var editAddressTF: UITextField!
    
    @IBOutlet weak var editAmenitiesTV: UITextView!
    @IBOutlet weak var editDateTF: UITextField!
    @IBOutlet weak var editDistance: UITextField!
    @IBOutlet weak var editPet: UISwitch!
    @IBOutlet weak var editCapacityTF: UITextField!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        imageIV.layer.borderWidth=1.0
        imageIV.layer.masksToBounds = false
        imageIV.layer.borderColor = UIColor.whiteColor().CGColor
        imageIV.layer.cornerRadius = 13
        imageIV.layer.cornerRadius = imageIV.frame.size.height/2
        imageIV.clipsToBounds = true
        self.title = "Edit Selected Owner Posts"
        var imageView:UIImageView
        imageView = UIImageView(frame:CGRectMake(0, 0, 1000, 1000))
        imageView.image = UIImage(named:"backgroundImage.jpg")
        self.view.addSubview(imageView)
        let doneButton = UIBarButtonItem(title: "Done", style: UIBarButtonItemStyle.Plain, target: self, action: "editingCompleted:")
        doneButton.tintColor = UIColor.blueColor()
        navigationItem.rightBarButtonItem  = doneButton
        
        editDateTF.delegate = self
        editRent.delegate = self
        editAddressTF.delegate = self
        editCapacityTF.delegate = self
        editDistance.delegate = self
        
        kinveyOperations = KinveyOperations(operationProtocol: self)
        ownerPostsViewController = OwnerPostsTableViewController()
        let app:AppDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
        let post:OwnerPosts = app.ownerDetails
        editRent.text = post.rent.description
        editAddressTF.text = post.address.description
        editAmenitiesTV.text = post.Amenities.description
        editDateTF.text = post.leaseAvailableFrom.description
        editDistance.text = post.distanceFromUniversity.description
        // if post.petsAllowed
        if post.petsAllowed == true
        {
            toggleState = true
            editPet.setOn(true, animated: true)
        } else
        {
            toggleState = false
            editPet.setOn(false, animated: true)
        }
        editCapacityTF.text = post.capacityInBHK.description
        
        /***** images are stored in files Collection, so use either name/ID/URL to retrive it ****/
        
        KCSFileStore.downloadFile(
            post.address,
            options: nil,
            completionBlock: { (downloadedResources: [AnyObject]!, error: NSError!) -> Void in
                if error == nil {
                    let file = downloadedResources[0] as! KCSFile
                    let fileURL = file.localURL
                    
                    let image = UIImage(contentsOfFile: fileURL.path!) //note this blocks for awhile
                    /****** assign it to imageview to display the image ********/
                    self.imageIV.image = image
                    //               self.productImages.append(candidateIV.image!)
                } else {
                    NSLog("Got an error: %@", error)
                }
            },
            progressBlock: nil
        )
        
        
    }
    
    func editingCompleted(sender:UIButton){
        if let _ = imageIV.image
        {
            uploadImage(imageIV.image!)
        }
    }
    
    func save(){
        let app:AppDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
       // let userId:String = app.UserId
        let post:OwnerPosts = app.ownerDetails
     //   var address:String = ""
        var rent:Double = 0.0
        var capacityInBHK:Int = 0
        var distanceFromUniversity:Double = 0.0
        if let add = editAddressTF.text
        {
            
            post.address = add + ",Maryville,MO-64468"

            if(add != "")
            {
                if editRent.text != ""
                {
                    rent = Double(editRent.text!)!
                    post.rent = rent
                }
                
                
                if editCapacityTF.text != ""
                {
                    capacityInBHK = Int(editCapacityTF.text!)!
                    post.capacityInBHK = capacityInBHK
                }
                
            //    let petsAllowed = toggleState
                if editDistance.text != ""
                {
                    distanceFromUniversity = Double(editDistance.text!)!
                    post.distanceFromUniversity = distanceFromUniversity
                }
                
                let Amenities:String = editAmenitiesTV.text!
                post.Amenities = Amenities
                let leaseAvailableFrom:String = editDateTF.text!
                post.leaseAvailableFrom = leaseAvailableFrom
                
                
                
                //                let imageUrl:String = "home.jpg"
                //                post.imageUrl = ""
                //                if let _ = imageIV.image?.description{
                //                    //imageUrl = (imageIV.image?.description)!
                //                    post.imageUrl = imageUrl
                //                }
                let todaysDate:NSDate = NSDate()
                //let ownerPosts:OwnerPosts = OwnerPosts(userId:userId,address: address, rent: rent, capacityInBHK: capacityInBHK, distanceFromUniversity: distanceFromUniversity, leaseAvailableFrom: leaseAvailableFrom, Amenities: Amenities, petsAllowed: petsAllowed, imageUrl: imageUrl)
                let dateFormatter:NSDateFormatter = NSDateFormatter()		        //self.navigationController!.dismissViewControllerAnimated(true, completion: nil)
                dateFormatter.dateFormat = "MM-dd-yyyy"
                let DateInFormat:String = dateFormatter.stringFromDate(todaysDate)
                post.postOn = DateInFormat
                print(post)
                
                kinveyOperations.savePost(post)
                
            }
            else
            {
                displayAlertControllerWithFailure("Enter Address", message: "Cannot post without specifying address")
            }
        }
    }
    
    @IBAction func selectImageBTN(sender: AnyObject) {
        let image = UIImagePickerController()
        image.delegate = self
        image.sourceType = UIImagePickerControllerSourceType.PhotoLibrary
        image.allowsEditing = false
        self.presentViewController(image, animated: true, completion: nil)
    }
    
    
    @IBAction func takeImageBTN(sender: AnyObject) {
        let image = UIImagePickerController()
        image.delegate = self
        image.sourceType = UIImagePickerControllerSourceType.Camera
        image.allowsEditing = false
        self.presentViewController(image, animated: true, completion: nil)
        
    }
    // Mark: imagepickerDelegate method
    func imagePickerController(picker: UIImagePickerController, didFinishPickingImage image: UIImage, editingInfo: [String : AnyObject]?) {
        print("image selected")
        self.dismissViewControllerAnimated(true, completion: nil)
        imageIV.image = image
        //  uploadImage(image)
    }
    
    
    /*************** Function to Upload image to kinvey FileStore *****************/
    func uploadImage(image:UIImage) {
        //self.productAds.productImage = ""
        
        /******** here product is stored using decription which is entered in an input text box(descriptionTV) ************/
        var address:String = "Not Specified"
        if let _ = editAddressTF.text
        {
            address = editAddressTF.text!
        }
        let metadata = KCSMetadata()
        metadata.setGloballyReadable(true)
        metadata.setGloballyWritable(true)
        
        let data = UIImageJPEGRepresentation(image, 0.2) //convert to a 90% quality jpeg
        KCSFileStore.uploadData(
            data,
            options: [KCSFileFileName : "\(address)",
                KCSFileMimeType : "image/jpeg",
                KCSFileId : "\(address)",
                KCSFileACL : metadata
            ],
            completionBlock: { (uploadInfo: KCSFile!, error: NSError!) -> Void in
//                NSLog("Upload finished. File id='%@', error='%@'.", uploadInfo.fileId, error)
//                print("File Uploaded with ID \(uploadInfo.fileId)")
//                print("File Uploaded with name \(uploadInfo.filename)")
//                print("File Uploaded with URL \(uploadInfo.downloadURL)")
                self.save()
            },
            progressBlock: nil
        )
    }
    
    @IBAction func petsAllowedToggleBTN(sender: AnyObject) {
        if toggleState == false {
            toggleState = true
        } else {
            toggleState = false
        }
    }
    
    func datePickerChanged(sender:UIDatePicker) {
        let formatter = NSDateFormatter()
        formatter.dateStyle = .FullStyle
        editDateTF.text = formatter.stringFromDate(sender.date)
    }
    
    // TextField Delegates
    
    // to assign a different view to the textfield
    func textFieldDidBeginEditing(textField: UITextField) {
        if textField == editDateTF
        {
            let datePicker = UIDatePicker()
            textField.inputView = datePicker
            datePicker.addTarget(self, action: Selector("datePickerChanged:"), forControlEvents: UIControlEvents.ValueChanged)
        }
    }
    
    // to remove the keypad on press of return key
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    // Mark : remove keypad on touch
    
    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
        self.view.endEditing(true)
    }
    
    func onSuccess(sender:AnyObject) {
        
        self.navigationController?.popViewControllerAnimated(true)
        //ownerPostsViewController.onSuccess(sender)
    }
    func onError(message: String) {
        print(message)
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
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    func displayAlertControllerWithFailure(title:String, message:String) {
        let uiAlertController:UIAlertController = UIAlertController(title: title,
            message: message, preferredStyle: UIAlertControllerStyle.Alert)
        uiAlertController.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.Cancel,
            handler:{(action:UIAlertAction)->Void in }))
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
