//
//  RegisterViewController.swift
//  HomeHunt
//
//  Created by Pullagurla,Mounika on 3/8/16.
//  Copyright © 2016 Pullagurla,Mounika. All rights reserved.
//

import UIKit

class RegisterViewController: UIViewController,OperationProtocol {
    
    
    @IBOutlet weak var termsAndConditionsCheckBox: CheckboxForTermsAndConditions!
    var kinveyOperations:KinveyOperations!
    
    @IBOutlet weak var firstNameTF: UITextField!
    
    @IBOutlet weak var lastNameTF: UITextField!
    
    @IBOutlet weak var emailIDTF: UITextField!
    
    @IBOutlet weak var passwordTF: UITextField!
    
    @IBOutlet weak var confirmPasswordLBL: UITextField!
    
    var radioGroup:RadioGroup!
    
    
    func cancelBTN(sender: AnyObject) {
        self.navigationController?.popToRootViewControllerAnimated(true)
    }
    
    @IBOutlet weak var tenantRadio: RadioButton!
    
    @IBOutlet weak var landlordRadio: RadioButton!
    @IBAction func registerBTN(sender: AnyObject) {
        var str:String = ""
        if firstNameTF.text!.isEmpty {
            
            str += "Please enter firstName"+"\n"
        }
        if lastNameTF.text!.isEmpty{
            str += "Please enter lastName"+"\n"
            
        }
        if emailIDTF.text!.isEmpty{
            str += "Please enter userName"+"\n"
            
        }
        
        let validEmailID:Bool = isValidEmail(emailIDTF.text!)
        if validEmailID == false {
            
            str += "please enter a valid email\n"
        }
        if passwordTF.text!.isEmpty {
            str += "Please enter password"+"\n"
            
        }
        let validPassword:Bool = isValidPassword(passwordTF.text!)
        print(validPassword)
        if validPassword == false {
            str += "Please enter a 1U,1L,(0-9)min:6 "+"\n"
            
        }
        
        if confirmPasswordLBL.text!.isEmpty{
            str += "Please enter confirm password"+"\n"
        }else{
            if passwordTF.text != confirmPasswordLBL.text {
                str = str+"confirm password is not matching with password\n"
                UIColor.redColor().CGColor
            }
        }
        var userSelectedRole:String = Constants.TENANT
        
        if let userRole = RadioGroup.buttonLabel {
            userSelectedRole  = userRole
        }
        else{
            str += "Please check the role"+"\n"
        }
        
        if !termsAndConditionsCheckBox.isChecked {
            str += " Please check terms and conditions"+"\n"
            
        }
        
        
        if str != ""
        {
            displayAlertControllerWithFailure("OOPS!", message: str)
        }
        else {
            
            let user:UserRegister = UserRegister(firstName: firstNameTF.text!, lastName: lastNameTF.text!, emailID: emailIDTF.text!, password: passwordTF.text!, confirmPassword: confirmPasswordLBL.text!,role: userSelectedRole)
            
            kinveyOperations.registerUser(user)
            
        }
        
    }
    
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationItem.setHidesBackButton(true, animated: true)
        kinveyOperations = KinveyOperations(operationProtocol: self)
        RadioGroup.addRadioButton(tenantRadio)
        RadioGroup.addRadioButton(landlordRadio)
        
        var imageView:UIImageView
        imageView = UIImageView(frame:CGRectMake(0, 0, 1000, 1000))
        imageView.image = UIImage(named:"backgroundImage.jpg")
        self.view.addSubview(imageView)
        let cancelBTN = UIBarButtonItem(title: "Cancel", style: UIBarButtonItemStyle.Plain, target: self, action: "cancelBTN:")
        cancelBTN.tintColor = UIColor.blueColor()
        navigationItem.leftBarButtonItem  = cancelBTN
        
    }
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        
    }
    
    override func viewWillAppear(animated: Bool) {
        self.title = "Registration"
    }
    
    func onSuccess(Sender: AnyObject) {
        print("successfully saved the user register details")
        
        displayAlertControllerWithTitle("Success", message: "Registration successful")
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
        
    }
    func fetchUser(user: UserRegister) {
        
    }
    
    func isValidEmail(username:String) -> Bool {
        // println("validate calendar: \(testStr)")
        let emailRegex = "^[a-zA-Z0-9.!#$%&'*+/=?^_`{|}~-]+@[a-zA-Z0-9](?:[a-zA-Z0-9-]{0,61}[a-zA-Z0-9])?(?:\\.[a-zA-Z0-9](?:[a-zA-Z0-9-]{0,61}[a-zA-Z0-9])?)*$"
        
        let emailTest = NSPredicate(format:"SELF MATCHES %@", emailRegex)
        return emailTest.evaluateWithObject(username)
        
    }
    func isValidPassword(password:String) -> Bool {
        // println("validate calendar: \(testStr)")
        let passwordRegEx = "^(?=.*[a-z])(?=.*[A-Z])(?=.*\\d).{6,15}$"
        
        let passwordTest = NSPredicate(format:"SELF MATCHES %@", passwordRegEx)
        return passwordTest.evaluateWithObject(password)
        
    }
    
    func displayAlertControllerWithFailure(title:String, message:String) {
        let uiAlertController:UIAlertController = UIAlertController(title: title,
            message: message, preferredStyle: UIAlertControllerStyle.Alert)
        uiAlertController.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.Cancel,
            handler:{(action:UIAlertAction)->Void in }))
        self.presentViewController(uiAlertController, animated: true, completion: nil)
    }
    func displayAlertControllerWithTitle(title:String, message:String) {
        //let login: LoginViewController = LoginViewController()
        let uiAlertController:UIAlertController = UIAlertController(title: title,
            message: message, preferredStyle: UIAlertControllerStyle.Alert)
        uiAlertController.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.Cancel,
            handler:{action in
                let login =  self.navigationController?.storyboard?.instantiateViewControllerWithIdentifier("login") as! LoginViewController
                self.navigationController?.pushViewController(login, animated: true)}))
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
