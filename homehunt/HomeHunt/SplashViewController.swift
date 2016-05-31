//
//  splashViewController.swift
//  HomeHunt
//
//  Created by Nallamothu,Vamshinath on 4/14/16.
//  Copyright © 2016 Pullagurla,Mounika. All rights reserved.
//

import UIKit

//A Controller for launching screen
class SplashViewController: UIViewController {
    
    
    
    
    @IBOutlet weak var web: UIWebView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let resourceBundle = NSBundle.mainBundle().URLForResource("loading", withExtension: ".gif")
        let htmlContent = "<html><head></head><style>h1{margin-left:300px;}</style><body><img src = \"loading.gif\" width=\"700\" height=\"600\"><h1>Loading...</h1></body></html>"
        web.loadHTMLString(htmlContent, baseURL: resourceBundle)
        
        performSelector("shownavigation", withObject: nil, afterDelay: 5)
        // Do any additional setup after loading the view.
    }
    
    func shownavigation(){
        performSegueWithIdentifier("showscreen", sender: self)
    }
    //    class func animatedImageWithImages(images: [UIImage], duration: NSTimeInterval) -> UIImage?{
    //        return images
    //    }
    
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
