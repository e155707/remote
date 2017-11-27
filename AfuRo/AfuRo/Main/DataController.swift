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
    
    
    
    func getTotalStepsData() -> Int{
        let steps = defaults.integer(forKey: "totalSteps")
        return steps
        
    }
    
    func setTotalStepsData(_ steps:Int){
        defaults.set(steps, forKey: "totalSteps")
        
    }
    
    func getLastDateData() -> Date{
        let lastDate = defaults.object(forKey: "yourKey") as! Date
        return lastDate
    }
    
    
    func setLastDateData(_ lastDate:Date){
        defaults.set(lastDate, forKey: "lastDate")

    }
        
}
