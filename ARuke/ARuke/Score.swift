//
//  Score.swift
//  ARuke
//
//  Created by e155707 on 2017/10/25.
//  Copyright © 2017年 Ryukyu. All rights reserved.
//
import Foundation


class ScoreManager{
    let defaults = UserDefaults.standard
    var score:Double = 0
    
    func setScore(_ scorePoint:Double){
   
        score = defaults.double(forKey: "score")
        score = score + 1
        print(score, scorePoint)
        
        defaults.set(score, forKey: "score")
    }
    
    func getScore() -> String {
        
        score = defaults.double(forKey: "score")

        return String(Int(score)) + "G"
    }
    
}

class DistanceManager{
    let defaults = UserDefaults.standard
    var distance:Double = 0
    
    func setdistance(_ distancePoint:Double){
        
        distance = defaults.double(forKey: "distance")
        distance = distance + 1
        
        defaults.set(distance, forKey: "distance")
    }
    
    func getDistance() -> String {
        
        distance = defaults.double(forKey: "distance")
        
        return String(Int(distance)) + "km"
    }
}
