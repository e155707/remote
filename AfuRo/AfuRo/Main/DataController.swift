//
//  DataController.swift
//  AfuRo
//
//  Created by 赤堀　貴一 on 2017/11/27.
//  Copyright © 2017年 Ryukyu. All rights reserved.
//

import Foundation

class DataController{
    let defaults = UserDefaults.standard
    
    func getWalkData() -> Int{
        let steps = defaults.integer(forKey: "steps")
        return steps
        
    }
    
    func setWalkData(_ steps:Int){
        defaults.set(steps, forKey: "steps")
        
    }
    
    
}
