//
//  TimeManager.swift
//  ARuke
//
//  Created by 赤堀　貴一 on 2017/11/19.
//  Copyright © 2017年 Ryukyu. All rights reserved.
//

import Foundation

class ARukeTimeController{
    var timer = Timer()
    
    func startAttackTimer(_ intervalMinute:Int){

        self.stopAttackTimer()
        let _intervalMinute = intervalMinute * 60
        // intervalMinute毎にTemporalEventを呼び出す
        timer = Timer.scheduledTimer(timeInterval: TimeInterval(_intervalMinute),
                                     target: self,
                                     selector:#selector(self.attack),
                                     userInfo: nil,repeats: true)
        
    }
    
    //一定タイミングで繰り返し呼び出される関数
    @objc func attack(){
        // ここに, hpが減るメソッドとかを書く.
        
    }
    
    func stopAttackTimer(){
        //timerが動いてるなら.
        if timer.isValid == true {
            //timerを破棄する.
            timer.invalidate()
        }

    }
    
}
