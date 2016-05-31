//
//  OwnerPostsTableViewController.swift
//  HomeHunt
//
//  Created by Yadav,Shalu on 3/13/16.
//  Copyright © 2016 Pullagurla,Mounika. All rights reserved.
//

import UIKit

class OwnerPostsTableViewController: UITableViewController, OperationProtocol {
    var posts:[OwnerPosts] = []
    var userid:String!
    var kinveyOperations:KinveyOperations!
    //var count:Int!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        posts = []
        self.title = "Owner Posts"
        let logout: UIBarButtonItem = UIBarButtonItem(title: "Logout", style: UIBarButtonItemStyle.Plain, target: self, action:Selector("logoutOwner:"))
        logout.tintColor = UIColor.blueColor()
        let editProfile: UIBarButtonItem = UIBarButtonItem(title: "EditProfile", style: UIBarButtonItemStyle.Plain, target: self, action:Selector("edit:"))
        editProfile.tintColor = UIColor.blueColor()
        self.navigationItem.setLeftBarButtonItems([logout,editProfile], animated: true)
        
        let addPostButton = UIBarButtonItem(title: "+", style: UIBarButtonItemStyle.Plain, target: self, action: "transitionToNewPost:")
        addPostButton.tintColor = UIColor.blueColor()
        //self.navigationItem.rightBarButtonItem?.tintColor = UIColor.blueColor()
        navigationItem.rightBarButtonItem  = addPostButton
        
        let app:AppDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
        userid = app.UserId
        kinveyOperations = KinveyOperations(operationProtocol: self)

        self.tableView.reloadData()
        let nibName = UINib(nibName: "ownerCell", bundle:nil)
        self.tableView.registerNib(nibName, forCellReuseIdentifier: "ownCell")
        
    }
    func edit(sender:UIButton!){
        print("in edit method")
        let editController:EditProfileViewController = self.navigationController!.storyboard?.instantiateViewControllerWithIdentifier("editProfile") as! EditProfileViewController
        self.navigationController?.pushViewController(editController, animated: true)
    }
    
    func logoutOwner(Any:AnyObject){
        if KCSUser.activeUser() != nil {
            KCSUser.activeUser().logout()
            //displayAlertControllerWithTitle("Success", message:"logged out!")
            let login =  self.navigationController?.storyboard?.instantiateViewControllerWithIdentifier("login") as! LoginViewController
            self.navigationController?.pushViewController(login, animated: true)
        }
    }
    
    func displayAlertControllerWithTitle(title:String, message:String) {
        let uiAlertController:UIAlertController = UIAlertController(title: title,
            message: message, preferredStyle: UIAlertControllerStyle.Alert)
        uiAlertController.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.Cancel,
            handler:nil))
        self.navigationController?.popToRootViewControllerAnimated(true)
        
    }
    
    func transitionToNewPost(sender:UIButton!){
        let newPostCreatedViewController:NewPostCreatedViewController = self.navigationController?.storyboard?.instantiateViewControllerWithIdentifier("newpost") as! NewPostCreatedViewController
        self.navigationController?.pushViewController(newPostCreatedViewController, animated: true)
    }
    
    override func viewWillAppear(animated: Bool) {
        self.navigationItem.backBarButtonItem?.title = "logout"
        
        self.navigationItem.rightBarButtonItem?.tintColor = UIColor.redColor()
        posts = []
        kinveyOperations.fetchOwnerPosts(userid)
        
        self.tableView.reloadData()
        // self.fetchOwnerPosts(userid)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK: - Table view data source
    
    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return self.posts.count
    }
    
    
    override func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return CGFloat(100)
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        let cell:UITableViewCell
        cell = self.tableView.dequeueReusableCellWithIdentifier("ownCell",forIndexPath:indexPath) as UITableViewCell
        
        let houseImage = cell.viewWithTag(1) as! UIImageView
        houseImage.layer.borderWidth = 1.0
        houseImage.layer.masksToBounds = true
        houseImage.layer.borderColor = UIColor.whiteColor().CGColor
        houseImage.layer.cornerRadius = 10.0
        houseImage.clipsToBounds = true
        
        let address:UILabel = cell.viewWithTag(2) as! UILabel
        let postedOn:UILabel = cell.viewWithTag(3) as! UILabel
        
        
        let addressOfHome = posts[indexPath.row].address as String
        
        address.text = addressOfHome
        if let _ = posts[indexPath.row].postOn
        {
            postedOn.text = posts[indexPath.row].postOn.description
        }
        else
        {
            postedOn.text = "Post on details are not there"
        }
        
        cell.accessoryType = UITableViewCellAccessoryType.DisclosureIndicator
        
        //----------------------------------------
        /****** Download the image from kinvey ********/
        
        
        /***** images are stored in files Collection, so use either name/ID/URL to retrive it ****/
        print("-----adddress---- ",addressOfHome)
        KCSFileStore.downloadFile(
            addressOfHome,
            options: nil,
            completionBlock: { (downloadedResources: [AnyObject]!, error: NSError!) -> Void in
                if error == nil {
                    let file = downloadedResources[0] as! KCSFile
                    let fileURL = file.localURL
                    
                    let image = UIImage(contentsOfFile: fileURL.path!) //note this blocks for awhile
                    /****** assign it to imageview to display the image ********/
                    houseImage.image = image
                    //               self.productImages.append(candidateIV.image!)
                } else {
                    NSLog("Got an error: %@", error)
                }
            },
            progressBlock: nil
        )
        
        //-----------------------------------------------
        
        
        
        return cell
    }
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        let post:OwnerPosts = posts[indexPath.row]
        //print(post.description)
        let postDetails:AppDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
        postDetails.ownerDetails = post
        
        
        //        print(self.navigationController!.storyboard)
        //        print(self.navigationController!.storyboard?.instantiateViewControllerWithIdentifier("homeDescriptionViewController"))
        let editVCObject:EditPostCreatedViewController = self.navigationController!.storyboard?.instantiateViewControllerWithIdentifier("editPostCreatedViewController") as! EditPostCreatedViewController
        
        self.navigationController?.pushViewController(editVCObject, animated: true)
        
        //        self.defaults.setValue(ownerPostsDetails, forKey: "ownerPostsDetails")
        //        self.defaults.synchronize()
        
        
        tableView.reloadData()
    }
    
    var deletePostIndexPath: NSIndexPath? = nil
    var postToDelete:OwnerPosts!
    
    override func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        
        if editingStyle == .Delete {
            
            deletePostIndexPath = indexPath
            
            postToDelete = posts[indexPath.row]
            
            confirmDelete(postToDelete)
            
        }
        
        
    }
    
    func confirmDelete(oPost: OwnerPosts) {
        
        let alert = UIAlertController(title: "Delete Post", message: "Are you sure you want to delete?", preferredStyle: .Alert)
        
        print(oPost)
        
        let DeleteAction = UIAlertAction(title: "Delete", style: .Destructive, handler: handleDeleteAd)
        
        let CancelAction = UIAlertAction(title: "Cancel", style: .Cancel, handler: cancelDeleteAd)
        
        
        alert.addAction(DeleteAction)
        
        alert.addAction(CancelAction)
        
        
        alert.popoverPresentationController?.sourceView = self.view
        
        alert.popoverPresentationController?.sourceRect = CGRectMake(self.view.bounds.size.width / 2.0, self.view.bounds.size.height / 2.0, 1.0, 1.0)
        
        
        self.presentViewController(alert, animated: true, completion: nil)
        
        
        
    }
    func cancelDeleteAd(alertAction: UIAlertAction!) {
        
        deletePostIndexPath = nil
        
    }
    
    func handleDeleteAd(alertAction: UIAlertAction!) -> Void {
        
        if let indexPath = deletePostIndexPath {
            
            
            
            //            we need to write delete from kinvey here
            
            
            
            tableView.beginUpdates()
            
            
            
            posts.removeAtIndex(indexPath.row)
            
            
            
            // Note that indexPath is wrapped in an array:  [indexPath]
            
            tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: .Automatic)
            
            
            
            deletePostIndexPath = nil
            
            
            
            tableView.endUpdates()
            
            
            kinveyOperations.ownerPost.removeObject(postToDelete, withDeletionBlock: { (deletionAdOrNil: [NSObject : AnyObject]!, errorOrNil: NSError!) -> Void in
                
                if errorOrNil != nil {
                    
                    print("error in deleting from Kinvey \(errorOrNil)")
                    
                } },
                
                withProgressBlock: nil)
            
            
            
            //productAdCollection.removeObject
            
        }
        
    }
    
    // Mark: operation Protocol methods
    
    func onSuccess(x:AnyObject) {
        self.tableView.reloadData()
    }
    func onError(message: String) {
        print(message)
        displayAlertControllerWithFailure("Error!", message: message)
    }
    
    func noActiveUser() {
        print("noActiveUser")
    }
    
    func loginFailed() {
        print("login failed")
    }
    func fetch(ownerPost: OwnerPosts) {
        posts.append(ownerPost)
        print(posts)
        self.tableView.reloadData()
    }
    func fetchUser(user: UserRegister) {
        
    }
    func displayAlertControllerWithFailure(title:String, message:String) {
        let uiAlertController:UIAlertController = UIAlertController(title: title,
            message: message, preferredStyle: UIAlertControllerStyle.Alert)
        uiAlertController.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.Cancel,
            handler:{(action:UIAlertAction)->Void in }))
        self.presentViewController(uiAlertController, animated: true, completion: nil)
    }
    
    
    
    
}
