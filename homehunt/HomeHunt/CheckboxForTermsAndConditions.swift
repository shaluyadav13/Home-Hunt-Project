//
//  CheckboxForTermsAndConditions.swift
//  HomeHunt
//
//  Created by Pullagurla,Mounika on 3/8/16.
//  Copyright © 2016 Pullagurla,Mounika. All rights reserved.
//

import UIKit

class CheckboxForTermsAndConditions: UIButton {
    var checkBoxStatus:String = "Please check terms and conditions"
    let checked = UIImage(named: "checkedCheckbox")! as UIImage
    let unchecked = UIImage(named: "uncheckedCheckbox")! as UIImage
    // bool property
    var isChecked:Bool = false{
        didSet{
            if isChecked == true {
                self.setImage(checked, forState: .Normal)
                checkBoxStatus = " "
            }else{
                self.setImage(unchecked, forState: .Normal)
                checkBoxStatus = "Please check terms and conditions"
            }
        }
    }
    override func awakeFromNib() {
        self.addTarget(self, action: Selector("buttonClicked:"), forControlEvents: UIControlEvents.TouchUpInside)
        self.isChecked = false
        checkBoxStatus = "Please check terms and conditions"
            }
    func buttonClicked(sender:UIButton){
        if sender == self{
            
            isChecked =  isChecked ? false:true

        }
        
    }
    
}
