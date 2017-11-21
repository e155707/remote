//
//  ManageUserInformation.swift
//  ARuke
//
//  Created by e155707 on 2017/11/20.
//  Copyright © 2017年 Ryukyu. All rights reserved.
//

import UIKit
import SceneKit
import ARKit

class ManageUserInformation{
    let defaults = UserDefaults.standard
    
    var gold:Int = Int()
    var fat:Int = Int()
    
    func initUserInformation(){
        gold = 0;
        fat = 0;
        
        defaults.set(gold, forKey:"gold")
        defaults.set(fat, forKey:"fat")
    }
    
    func getUserGold() -> Int{
        gold = defaults.integer(forKey: "gold")
        return gold
    }
    
    func setUserGold(_ setGold:Int){
        gold = defaults.integer(forKey: "gold")
        gold = setGold
        defaults.set(gold, forKey:"gold")
    }
    
    
    func getUserFat() -> Int{
        fat = defaults.integer(forKey: "fat")
        return fat
    }
    
    func setUserFat(_ setFat:Int){
        fat = defaults.integer(forKey: "fat")
        fat = setFat
        defaults.set(fat, forKey:"fat")
    }
}
