//
//  RadioButton.swift
//  HomeHunt
//
//  Created by Pullagurla,Mounika on 3/10/16.
//  Copyright © 2016 Pullagurla,Mounika. All rights reserved.
//

import Foundation
class RadioButton: UIButton {
    var user:UserRegister!
    
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        addToGroup()
        
    }
    init(){
        super.init(frame: CGRectZero)
        addToGroup()
    }
    override init(frame: CGRect) {
        super.init(frame: frame)
        addToGroup()
    }
    func addToGroup(){
        
        
        RadioGroup.addRadioButton(self)
        
        
    }
    
    let checked = UIImage(named: "radioChecked.png")! as UIImage
    let unchecked = UIImage(named: "radioUnchecked.png")! as UIImage
    // bool property
    var isChecked:Bool = false{
        didSet{
            if isChecked == true {
                self.setImage(checked, forState: .Normal)
                
            }else{
                self.setImage(unchecked, forState: .Normal)
            }
        }
    }
    override func awakeFromNib() {
        self.addTarget(self, action: Selector("buttonClicked:"), forControlEvents: UIControlEvents.TouchUpInside)
        self.isChecked = false
    }
    func buttonClicked(sender:RadioButton){
        
        RadioGroup.radioOnClick(sender)
        
        
        
    }
    
    
}

