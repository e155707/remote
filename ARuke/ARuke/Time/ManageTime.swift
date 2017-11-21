//
//  ManageTime.swift
//  ARuke
//
//  Created by e155707 on 2017/11/21.
//  Copyright © 2017年 Ryukyu. All rights reserved.
//

import Foundation

class ManageTime{
    
    var startTime: NSDate = NSDate()
    var format = DateFormatter()
    var startTimeHour:String = String()
    var startTimeMinute:String = String()
    var startTimeSecond:String = String()
    
    var TimeMinute:Int = Int()
    
    func startTimer(){
        startTime = NSDate()
        format = DateFormatter()
        format.dateFormat = "mm"
        startTimeMinute = format.string(from: startTime as Date)
    }
    
    func TimeMeasurement(){
        let endTIme = NSDate()
        let endFomat = DateFormatter()
        endFomat.dateFormat = "mm"
        let endTimeMinute = format.string(from: endTIme as Date)
        
        
    }
}
