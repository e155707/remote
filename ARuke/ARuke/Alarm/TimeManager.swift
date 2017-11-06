//
//  TimeManager.swift
//  ARuke
//
//  Created by e155707 on 2017/11/07.
//  Copyright © 2017年 Ryukyu. All rights reserved.
//
import Foundation

class TimeManager{
    
    let defaults = UserDefaults.standard
    
    var dayOfTheWeek:[Bool] = [
        false,
        false,
        false,
        false,
        false,
        false,
        false
    ]
    
    func setDayOfTheWeek(_ check:Int){
        dayOfTheWeek = [defaults.bool(forKey: "dayOfTheWeek")]
        dayOfTheWeek[check] = true
        defaults.set(dayOfTheWeek, forKey: "dayOfTheWeek")
    }
    
    func resetDayOfTheWeek(_ check:Int){
        dayOfTheWeek = [defaults.bool(forKey: "dayOfTheWeek")]
        dayOfTheWeek[check] = false
        defaults.set(dayOfTheWeek, forKey: "dayOfTheWeek")
    }
    
    func getDayOfTheWeek() -> [Bool]{
        dayOfTheWeek = [defaults.bool(forKey: "dayOfTheWeek")]
        return dayOfTheWeek
    }
    
    
}
