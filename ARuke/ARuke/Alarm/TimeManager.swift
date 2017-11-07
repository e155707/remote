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
    
    var checkDayOfTheWeek:[Bool] = [Bool()]
    
    let dayOfTheWeek:[String] = [
        "日",
        "月",
        "火",
        "水",
        "木",
        "金",
        "土"
    ]
    
    func timeInit(){
        checkDayOfTheWeek = [
            false,
            false,
            false,
            false,
            false,
            false,
            false
        ]
        
        defaults.set(checkDayOfTheWeek, forKey: "dayOfTheWeek")
    }
    
    func setDayOfTheWeek(_ check:Int){
        checkDayOfTheWeek = defaults.array(forKey: "dayOfTheWeek") as! [Bool]
        checkDayOfTheWeek[check] = true
        defaults.set(checkDayOfTheWeek, forKey: "dayOfTheWeek")
    }
    
    func resetDayOfTheWeek(_ check:Int){
        checkDayOfTheWeek = defaults.array(forKey: "dayOfTheWeek") as! [Bool]
        checkDayOfTheWeek[check] = false
        defaults.set(checkDayOfTheWeek, forKey: "dayOfTheWeek")
    }
    
    func getTrueDayOfTheWeek() -> String{
        checkDayOfTheWeek = defaults.array(forKey: "dayOfTheWeek") as! [Bool]
        var giveDayOfTheWeek:String = String()
        
        for i in 0...6{
            if(checkDayOfTheWeek[i]){
                giveDayOfTheWeek = giveDayOfTheWeek + dayOfTheWeek[i] + ","
            }
        }
        
        if(giveDayOfTheWeek.isEmpty == true){
            giveDayOfTheWeek = "なし"
        }else{
            giveDayOfTheWeek = String(giveDayOfTheWeek.prefix(giveDayOfTheWeek.characters.count - 1))
        }
        
        return giveDayOfTheWeek
    }
    
    func getCheckDayOfTheWeek(_ week:Int) -> Bool{
        checkDayOfTheWeek = defaults.array(forKey: "dayOfTheWeek") as! [Bool]
        return checkDayOfTheWeek[week]
    }
}
