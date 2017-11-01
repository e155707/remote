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
    
    var score:Double = Double()
    var timesEffect:Double = Double()
    var totalScore:Double = Double()
    
    var distance:Double = Double()
    var totalDistance:Double = Double()
    
    //初期化
    func scoreInitialization(){
        score = defaults.double(forKey: "score")
        timesEffect = defaults.double(forKey: "times")
        distance = defaults.double(forKey: "distance")
        
        score = 0
        timesEffect = 1
        distance = 0
        
        defaults.set(score, forKey: "score")
        defaults.set(timesEffect, forKey: "times")
        defaults.set(distance, forKey: "distance")
    }
 
    
    func setScore(_ scorePoint:Double){
        score = defaults.double(forKey: "score")
        timesEffect = defaults.double(forKey: "times")
        distance = defaults.double(forKey: "distance")
        
        score = score + (scorePoint*timesEffect)
        print("score = \(score), scorePoint = \(scorePoint)")
        print("timesEffect = \(timesEffect)")
        distance = distance + scorePoint
        print("distance = \(distance)")
        
        defaults.set(score, forKey: "score")
        defaults.set(distance , forKey: "distance")
    }
    
    
    func getTimesEffect(_ times:Double){
        timesEffect = timesEffect * times
        
        defaults.set(timesEffect, forKey: "times")
    }
    
    
    func getScore() -> String {
        score = defaults.double(forKey: "score")

        return String(Int(score)) + "G"
    }
    
    
    func getDistance() -> String {
        distance = defaults.double(forKey: "distance")
        
        return String(Int(distance)) + "m"
    }
    
    
    //通算スコアの計算関数
    func setTotalScore(){
        totalScore = defaults.double(forKey: "totalScore")
        totalDistance = defaults.double(forKey: "totalDistance")
        score = defaults.double(forKey: "score")
        distance = defaults.double(forKey: "distance")
        
        totalScore = totalScore + score
        totalDistance = totalDistance + distance
        
        defaults.set(totalScore, forKey: "totalScore")
        defaults.set(totalDistance, forKey: "totalDistance")
    }
    
    
    //通算スコアを獲得する
    func getTotalScore() -> String{
        totalScore = defaults.double(forKey: "totalScore")
        
        return String(Int(totalScore)) + "G"
    }
    
    
    //通算距離を獲得する
    func getTotalDistance() -> String{
        totalDistance = defaults.double(forKey: "totalDistance")
        
        return String(Int(totalDistance)) + "m"
    }
    
}
