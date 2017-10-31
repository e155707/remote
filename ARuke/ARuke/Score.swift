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
    var timesEffect:Double = 1
    
 
    func setScore(_ scorePoint:Double){
   
        score = defaults.double(forKey: "score")
        timesEffect = defaults.double(forKey: "times")
        
        // 絆創膏
        if timesEffect < 1 {
            timesEffect = 1
        }
        
        
        score = score + (scorePoint*timesEffect)
        print("score = \(score), scorePoint = \(scorePoint)")
        print("timesEffect = \(timesEffect)")
        
        
        defaults.set(score, forKey: "score")
    }
    
    func getTimesEffect(_ times:Double){

        timesEffect = timesEffect * times
        
        defaults.set(timesEffect, forKey: "times")
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
        distance = distance + distancePoint
        
        defaults.set(distance, forKey: "distance")
    }
    
    func getDistance() -> String {
        
        distance = defaults.double(forKey: "distance")
        
        return String(Int(distance)) + "km"
    }
}
