//
//  RadioGroup.swift
//  HomeHunt
//
//  Created by Pullagurla,Mounika on 3/14/16.
//  Copyright © 2016 Pullagurla,Mounika. All rights reserved.
//

import Foundation


class RadioGroup{
    
    static var radioButtons:[RadioButton] = []
    
    static var label:String!
    
    
    
    
    static func addRadioButton(radioButton:RadioButton){
        
        var exists = false
        for radio in radioButtons
        {
            exists = (radio.tag == radioButton.tag)
            if(exists){
                return
            }
        }
        if(!exists){
            radioButtons.append(radioButton)
        }
        
    }
    
    
    static func radioOnClick(sender:RadioButton)->Void{
        
        for radio_ in radioButtons {
            radio_.isChecked = false
        }
        sender.isChecked=true
        
        switch sender.tag {
        case 1:
            buttonLabel = Constants.TENANT
        case 2:
            buttonLabel = Constants.LANDLORD
        default:
            buttonLabel = nil
            
        }
        
    }
    
    
    static var buttonLabel:String!{
        get{
        return label
        }
        set {
            
            label = newValue
            
        }
    }
    
    
    
    
    
}