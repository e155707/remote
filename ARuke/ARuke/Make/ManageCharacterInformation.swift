//
//  ManagerCharacterInformation.swift
//  ARuke
//
//  Created by e155707 on 2017/11/14.
//  Copyright © 2017年 Ryukyu. All rights reserved.
//

import UIKit
import SceneKit
import ARKit

class ManageCharacterInformation{
    let defaults = UserDefaults.standard
    
    var gender:String = String()
    var color:String = String()
    var name:String = String()
    var obejectName:String = String()
    
    func initCharacterInformation(){
        gender = "male"
        color = "red"
        name = "S"
        obejectName = "treasureboxRED"
        
        defaults.set(gender, forKey: "gender")
        defaults.set(color, forKey:"color")
        defaults.set(name, forKey:"name")
        defaults.set(obejectName, forKey:"ObjectName")
    }
    
    func setObejectName(_ name:String){
        obejectName = defaults.string(forKey: "ObjectName")!
        obejectName = name
        defaults.set(obejectName, forKey:"ObjectName")
    }
    
    func getObjectName() -> String{
        obejectName = defaults.string(forKey: "ObjectName")!
        
        return obejectName
    }
    
    func setName(_ name2:String){
        name = defaults.string(forKey: "name")!
        name = name2
        defaults.set(name, forKey:"name")
    }
    
    func getName() -> String{
        name = defaults.string(forKey: "name")!
        
        return name
    }
    
}
