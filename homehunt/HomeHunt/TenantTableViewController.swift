//
//  tenantTableViewController.swift
//  HomeHunt
//
//  Created by Abbu, Srilatha Reddy on 3/14/16.
//  Copyright © 2016 Pullagurla,Mounika. All rights reserved.
//

import UIKit

class TenantTableViewController: UITableViewController,OperationProtocol {
    var kinveyOperations:KinveyOperations! // creating a stored variable kinveyOperations of type KinveyOperations
    var ownerPostsArray:[OwnerPosts] = []  // creating an array ownerPostsArray of type OwnerPosts initializing to null
    override func viewDidLoad() {
        super.viewDidLoad()
        kinveyOperations = KinveyOperations(operationProtocol: self) //initializing kinvey operations.
        self.navigationItem.title = "Home Posts" //assigning the title of the view table as "Home Posts"
        let logout: UIBarButtonItem = UIBarButtonItem(title: "Logout    ", style: UIBarButtonItemStyle.Plain, target: self, action:Selector("logout:")) // assigning the logout function to a logout barbuttonitem.
        logout.tintColor = UIColor.blueColor() //assigning the logout button color as blue color
        let editProfile: UIBarButtonItem = UIBarButtonItem(title: "EditProfile", style: UIBarButtonItemStyle.Plain, target: self, action:Selector("editProfile:")) //assigning edit profile function to a editProfile button
        editProfile.tintColor = UIColor.blueColor() //assigning the color of editProfile button as blue
        self.navigationItem.setLeftBarButtonItems([logout,editProfile], animated: true) //assigning both logout and editProfile barbutton items to left barbutton items.
        let SortBYRent: UIBarButtonItem = UIBarButtonItem(title: "Sort By Rent ", style: UIBarButtonItemStyle.Plain, target: self, action:Selector("sortByRent:")) //assigning sortbyrent function to a sort By Rent Button
        SortBYRent.tintColor = UIColor.blueColor() // assigning blue color for Sort By Rent button
        let SortBYDistance: UIBarButtonItem = UIBarButtonItem(title: "Sort By Distance   ", style: UIBarButtonItemStyle.Plain, target: self, action:Selector("sortByDistance:")) // assigning sor
        SortBYDistance.tintColor = UIColor.blueColor()
        self.navigationItem.setRightBarButtonItems([SortBYRent,SortBYDistance], animated: true)
        
        
        let nibName = UINib(nibName: "owner", bundle:nil)
        self.tableView.registerNib(nibName, forCellReuseIdentifier: "owner")
        
    }
    func editProfile(sender:UIButton!){
        print("in edit method")
        let editController:EditProfileViewController = self.navigationController!.storyboard?.instantiateViewControllerWithIdentifier("editProfile") as! EditProfileViewController
        self.navigationController?.pushViewController(editController, animated: true)
    }
    
    func logout(Any:AnyObject){
        if KCSUser.activeUser() != nil {
            KCSUser.activeUser().logout()
            //displayAlertControllerWithTitle("Success", message:"logged out!")
            let login =  self.navigationController?.storyboard?.instantiateViewControllerWithIdentifier("login") as! LoginViewController
            self.navigationController?.pushViewController(login, animated: true)
        }
    }
    
    func sortByRent(sender: UIButton) {
        print("in sort by function")
        ownerPostsArray.sortInPlace({Int($0.rent) < Int($1.rent)})
        self.tableView.reloadData()
    }
    func sortByDistance(sender: UIButton) {
        print("in sort by function")
        ownerPostsArray.sortInPlace({Int($0.distanceFromUniversity) < Int($1.distanceFromUniversity)})
        self.tableView.reloadData()
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
        if ownerPostsArray.isEmpty {
            return 0
        } else {
            return ownerPostsArray.count
            
        }
    }
    
    override func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return CGFloat(100)
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        let cell:UITableViewCell
        cell = self.tableView.dequeueReusableCellWithIdentifier("owner",forIndexPath:indexPath) as UITableViewCell
        
        let houseImage = cell.viewWithTag(1) as! UIImageView
        
        houseImage.layer.borderWidth = 1.0
        houseImage.layer.masksToBounds = true
        houseImage.layer.borderColor = UIColor.whiteColor().CGColor
        houseImage.layer.cornerRadius = 10.0
        houseImage.clipsToBounds = true
        //let ownerName:UILabel = cell.viewWithTag(2) as! UILabel
        let address:UILabel = cell.viewWithTag(2) as! UILabel
        let rent:UILabel = cell.viewWithTag(3) as! UILabel
        let distance:UILabel = cell.viewWithTag(4) as! UILabel
        let rating:UILabel = cell.viewWithTag(5) as! UILabel
        //houseImage.image = UIImage(named: "home.jpeg")
        let addressOfHome = ownerPostsArray[indexPath.row].address as String
        address.text = addressOfHome
        //ownerPostsArray.sortInPlace({String($0.leaseAvailableFrom) < String($1.leaseAvailableFrom)})
        //ownerName.text = ownerPostsArray[indexPath.row].userId as String
        rent.text = "$ " + ownerPostsArray[indexPath.row].rent.description
        distance.text = ownerPostsArray[indexPath.row].distanceFromUniversity.description+" miles"
        //address.text = ownerPostsArray[indexPath.row].address as String
        rating.text = ownerPostsArray[indexPath.row].rating.description + " views"
        cell.accessoryType = UITableViewCellAccessoryType.DisclosureIndicator
        
        //----------------------------------------
        /****** Download the image from kinvey ********/
        
        
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
        var owner = ownerPostsArray[indexPath.row]
        let ratingCount = Int(ownerPostsArray[indexPath.row].rating) + 1
        owner = OwnerPosts(userId: owner.userId, address: owner.address, rent: owner.rent, capacityInBHK: owner.capacityInBHK, distanceFromUniversity: owner.distanceFromUniversity, leaseAvailableFrom: owner.leaseAvailableFrom, Amenities: owner.Amenities, petsAllowed: owner.petsAllowed, postOn: owner.postOn, rating: ratingCount)
        kinveyOperations.deletePost(owner)
        
        
    }
    
    override func tableView(tableView: UITableView, accessoryButtonTappedForRowWithIndexPath indexPath: NSIndexPath) {
        print("tableview acc")
        tableView.targetForAction("navigate:", withSender: indexPath.row)
    }
    
    //    func navigate() {
    //        print("navigation")
    //        let navigation = self.navigationController?.storyboard?.instantiateViewControllerWithIdentifier("tenantTab") as! tenantTabBarController
    //        self.navigationController?.pushViewController(navigation, animated: true)
    //    }
    
    func displayAlertControllerWithTitle(title:String, message:String) {
        let uiAlertController:UIAlertController = UIAlertController(title: title,
            message: message, preferredStyle: UIAlertControllerStyle.Alert)
        uiAlertController.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.Cancel,
            handler:{action in self.performSegueWithIdentifier("returnFromTenantToLogin", sender:self) }))
        self.presentViewController(uiAlertController, animated: true, completion: nil)
        
    }
    func onSuccess(Sender: AnyObject) {
        print("successfully populated")
    }
    func onError(message: String) {
        print("*****\(message)")
        displayAlertControllerWithFailure("Error!", message: message)
    }
    func noActiveUser() {
        print("noActiveUser")
        
    }
    func loginFailed() {
        print("login failed")
    }
    func fetch(ownerPost: OwnerPosts) {
        ownerPostsArray.append(ownerPost)
        self.tableView.reloadData()
    }
    func fetchUser(user: UserRegister) {
        
    }
    func onDeleteSuccess() {
        let ownerPostsDetails:OwnerPosts = ownerPostsArray[(self.tableView.indexPathForSelectedRow?.row)!]
        print(ownerPostsDetails.description)
        let ownerDetails:AppDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
        ownerDetails.ownerDetails = ownerPostsDetails
        print(self.navigationController!.storyboard)
        print(self.navigationController!.storyboard?.instantiateViewControllerWithIdentifier("homeDescriptionViewController"))
        let homeControllerObject:HomeDescriptionViewController = self.navigationController!.storyboard?.instantiateViewControllerWithIdentifier("homeDescriptionViewController") as! HomeDescriptionViewController
        self.navigationController?.pushViewController(homeControllerObject, animated: true)
        self.tableView.reloadData()
    }
    override func viewWillAppear(animated: Bool) {
        ownerPostsArray = []
        kinveyOperations.retrieveData()
        self.tableView.reloadData()
    }
    func displayAlertControllerWithFailure(title:String, message:String) {
        let uiAlertController:UIAlertController = UIAlertController(title: title,
            message: message, preferredStyle: UIAlertControllerStyle.Alert)
        uiAlertController.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.Cancel,
            handler:{(action:UIAlertAction)->Void in }))
        self.presentViewController(uiAlertController, animated: true, completion: nil)
    }
    
    
    /*
    // Override to support conditional editing of the table view.
    override func tableView(tableView: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool {
    // Return false if you do not want the specified item to be editable.
    return true
    }
    */
    
    /*
    // Override to support editing the table view.
    override func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
    if editingStyle == .Delete {
    // Delete the row from the data source
    tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: .Fade)
    } else if editingStyle == .Insert {
    // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }
    }
    */
    
    /*
    // Override to support rearranging the table view.
    override func tableView(tableView: UITableView, moveRowAtIndexPath fromIndexPath: NSIndexPath, toIndexPath: NSIndexPath) {
    
    }
    */
    
    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(tableView: UITableView, canMoveRowAtIndexPath indexPath: NSIndexPath) -> Bool {
    // Return false if you do not want the item to be re-orderable.
    return true
    }
    */
    
    /*
    // MARK: - Navigation
    
    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
    // Get the new view controller using segue.destinationViewController.
    // Pass the selected object to the new view controller.
    let destination = segue.destinationViewController as! tenantTabBarController
    let row = tableView.indexPathForSelectedRow?.row
    destination.tenantDetails = OwnerPosts.description()
    }
    */
    
    
}
