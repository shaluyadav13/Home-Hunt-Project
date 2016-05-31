//
//  newPostCreatedViewController.swift
//  HomeHunt
//
//  Created by Yadav,Shalu on 3/13/16.
//  Copyright © 2016 Pullagurla,Mounika. All rights reserved.
//

import UIKit

class NewPostCreatedViewController: UIViewController, UITextFieldDelegate, UINavigationControllerDelegate, UIImagePickerControllerDelegate, OperationProtocol {
    
    var kinveyOperations:KinveyOperations!
    // var ownerPosts:OwnerPosts!
    var toggleState:Bool = false
    
    @IBOutlet weak var rentTF: UITextField!
    
    @IBOutlet weak var addressTF: UITextField!
    // @IBOutlet weak var dateTF: UITextField!
    @IBOutlet weak var dateAvailableTF: UITextField!
    
    @IBOutlet weak var capacityTF: UITextField!
    
    //@IBOutlet weak var leaseFromDP: UIDatePicker!
    
    @IBOutlet weak var uploadImageIV: UIImageView!
    //@IBOutlet weak var uploadPicTF: UITextField!
    @IBOutlet weak var selectImageBTN: UIButton!
    
    
    @IBOutlet weak var takeImageBTN: UIButton!
    
    @IBOutlet weak var amenitiesTV: UITextView!
    @IBOutlet weak var petsTB: UISwitch!
    @IBOutlet weak var distanceTF: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
       
        uploadImageIV.layer.borderWidth=1.0
        uploadImageIV.layer.masksToBounds = false
        uploadImageIV.layer.borderColor = UIColor.whiteColor().CGColor
        uploadImageIV.layer.cornerRadius = 13
        uploadImageIV.layer.cornerRadius = uploadImageIV.frame.size.height/2
        uploadImageIV.clipsToBounds = true
        
        dateAvailableTF.delegate = self
        rentTF.delegate = self
        addressTF.delegate = self
        capacityTF.delegate = self
        distanceTF.delegate = self
        
        kinveyOperations = KinveyOperations(operationProtocol: self)
        
        self.title = "New"
        
        // For creating the Post as right button on Navigation controller
        let postButton = UIBarButtonItem(title: "Post", style: UIBarButtonItemStyle.Plain, target: self, action: "savePost:")
        self.navigationItem.rightBarButtonItem?.tintColor = UIColor.blueColor()
        navigationItem.rightBarButtonItem  = postButton
        
        // For initializing the Date Picker
        var imageView:UIImageView
                imageView = UIImageView(frame:CGRectMake(0, 0, 1000, 1000))
                imageView.image = UIImage(named:"backgroundImage.jpg")
                self.view.addSubview(imageView)
        
    }
    
    override func viewWillAppear(animated: Bool) {
        let tDate:NSDate = NSDate()
        //let ownerPosts:OwnerPosts = OwnerPosts(userId:userId,address: address, rent: rent, capacityInBHK: capacityInBHK, distanceFromUniversity: distanceFromUniversity, leaseAvailableFrom: leaseAvailableFrom, Amenities: Amenities, petsAllowed: petsAllowed, imageUrl: imageUrl)
        let dFormatter:NSDateFormatter = NSDateFormatter()		        //self.navigationController!.dismissViewControllerAnimated(true, completion: nil)
        dFormatter.dateFormat = "MM-dd-yyyy"
        let DateInFormat:String = dFormatter.stringFromDate(tDate)
        dateAvailableTF.text = DateInFormat
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
        image.allowsEditing = true
        image.cameraCaptureMode = .Photo
        self.presentViewController(image, animated: true, completion: nil)
        
    }
    
    // Mark: imagepickerDelegate method
    func imagePickerController(picker: UIImagePickerController, didFinishPickingImage image: UIImage, editingInfo: [String : AnyObject]?) {
        print("image selected")
        self.dismissViewControllerAnimated(true, completion: nil)
        uploadImageIV.image = image
        
    }
    
    
    /*************** Function to Upload image to kinvey FileStore *****************/
    func uploadImage(image:UIImage) {
        //self.productAds.productImage = ""
        
        /******** here product is stored using decription which is entered in an input text box(descriptionTV) ************/
        var address:String = "Not Specified"
        if let _ = addressTF.text
        {
            address = addressTF.text!
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
        dateAvailableTF.text = formatter.stringFromDate(sender.date)
    }
    
    func savePost(sender:UIButton!){
        let app:AppDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
        let userId:String = app.UserId
        var address:String = ""
        var rent:Double = 0.0
        var capacityInBHK:Int = 0
        var distanceFromUniversity:Double = 0.0
        if let add = addressTF.text
        {
            
            address = add + ",Maryville,MO-64468"
            if(address != "")
            {
                if rentTF.text != ""
                {
                    rent = Double(rentTF.text!)!
                }
                
                
                if capacityTF.text != ""
                {
                    capacityInBHK = Int(capacityTF.text!)!
                }
                
                let petsAllowed = toggleState
                if distanceTF.text != ""
                {
                    distanceFromUniversity = Double(distanceTF.text!)!
                }
                
                let Amenities:String = amenitiesTV.text!
                let leaseAvailableFrom:String = dateAvailableTF.text!
                
                if let _ = uploadImageIV.image
                {
                uploadImage(uploadImageIV.image!)
                }
                
//                var imageUrl:String = ""
//                if let _ = uploadImageIV.image?.description{
//                    imageUrl = (uploadImageIV.image?.description)!
//                }
                let todaysDate:NSDate = NSDate()
                //let ownerPosts:OwnerPosts = OwnerPosts(userId:userId,address: address, rent: rent, capacityInBHK: capacityInBHK, distanceFromUniversity: distanceFromUniversity, leaseAvailableFrom: leaseAvailableFrom, Amenities: Amenities, petsAllowed: petsAllowed, imageUrl: imageUrl)
                let dateFormatter:NSDateFormatter = NSDateFormatter()		        //self.navigationController!.dismissViewControllerAnimated(true, completion: nil)
                dateFormatter.dateFormat = "MM-dd-yyyy"
                let DateInFormat:String = dateFormatter.stringFromDate(todaysDate)
                
                
                let ownerPosts:OwnerPosts = OwnerPosts(userId:userId,address: address, rent: rent, capacityInBHK: capacityInBHK, distanceFromUniversity: distanceFromUniversity, leaseAvailableFrom: leaseAvailableFrom, Amenities: Amenities, petsAllowed: petsAllowed,postOn: DateInFormat,rating: 1)
                kinveyOperations.savePost(ownerPosts)
               
            }
            else
            {
//                let alert = UIAlertView(
//                    title: NSLocalizedString("Enter Address", comment: "Cannot post without specifying address"),
//                    message: "",
//                    delegate: nil,
//                    cancelButtonTitle: NSLocalizedString("OK", comment: "OK")
//                )
//                alert.show()
                displayAlertControllerWithFailure("Enter Address", message: "cannot post without specifying address")
            }
        }
       
        
    }
    
//    override func viewWillDisappear(animated: Bool) {
//        print(self.navigationController!.storyboard?.instantiateViewControllerWithIdentifier("ownerPost"))
//        let ownerVCObject:OwnerPostsTableViewController = self.navigationController!.storyboard?.instantiateViewControllerWithIdentifier("ownerPost") as! OwnerPostsTableViewController
//        ownerVCObject.tableView.reloadData()
//    }
   
    
    // TextField Delegates
    
    // to assign a different view to the textfield
    func textFieldDidBeginEditing(textField: UITextField) {
        if textField == dateAvailableTF
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
    
    func onSuccess(x:AnyObject) {
      
        self.navigationController?.popViewControllerAnimated(true)
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
}
