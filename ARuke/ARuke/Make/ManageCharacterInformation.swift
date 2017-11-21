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
    var level:Int = Int()
    var experiencePoint:Int = Int()
    var maxExperiencePoint:Int = Int()
    var HP:Int = Int()
    
    func initCharacterInformation(){
        gender = "♂"
        color = "red"
        name = "S"
        obejectName = "treasureboxRED"
        level = 1
        experiencePoint = 0
        maxExperiencePoint = 100
        HP = 1000
        
        defaults.set(gender, forKey: "gender")
        defaults.set(color, forKey:"color")
        defaults.set(name, forKey:"name")
        defaults.set(obejectName, forKey:"ObjectName")
        defaults.set(level,forKey:"level")
        defaults.set(experiencePoint,forKey:"experiencePoint")
        defaults.set(HP,forKey:"HP")
        defaults.set(maxExperiencePoint,forKey:"maxExperiencePoint")
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
