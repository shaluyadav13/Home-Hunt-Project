//
//  TermsAndConditionsViewController.swift
//  HomeHunt
//
//  Created by Pullagurla,Mounika on 3/8/16.
//  Copyright © 2016 Pullagurla,Mounika. All rights reserved.
//

import UIKit

class TermsAndConditionsViewController: UIViewController {

       @IBOutlet weak var termsAndConditionsWV: UIWebView!
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationItem.title = "Terms and Conditions"
      
        var imageView:UIImageView
        imageView = UIImageView(frame:CGRectMake(0, 0, 1000, 1000))
        imageView.image = UIImage(named:"backgroundImage.jpg")
        self.view.addSubview(imageView)
        let url = NSURL(string: "https://www.ago.mo.gov/docs/default-source/publications/landlord-tenantlaw.pdf?sfvrsn=4")
        let requestURL = NSURLRequest(URL: url!)
        termsAndConditionsWV.loadRequest(requestURL)
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
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
