//
//  Score.swift
//  ARuke
//
//  Created by e155707 on 2017/10/25.
//  Copyright © 2017年 Ryukyu. All rights reserved.
//

class ScoreManager{
    var score:Int = 100000
    
    func getScore() -> String {
        return String(score) + "G"
    }
}

class DistanceManager{
    var distance:Int = 100
    
    func getDistance() -> String {
        return String(distance) + "km"
    }
}
