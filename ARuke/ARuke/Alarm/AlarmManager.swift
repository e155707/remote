//
//  AlarmManager.swift
//  ARuke
//
//  Created by e155707 on 2017/11/07.
//  Copyright © 2017年 Ryukyu. All rights reserved.
//

import Foundation
import UIKit
import SceneKit
import ARKit
import UserNotifications

extension AlarmController{
    
    @objc func update(tm: Timer) {
        // 現在時刻を取得
        let str = timeController.getNowTime()
        let week = timeController.getNowDayOfTheWeek()
        //print(week)
        // アラーム鳴らすか判断
        myAlarm(str , week)
    }
    
    func myAlarm(_ str:String, _ week:Int) {
        var checkDayOfTheWeek:Bool = false
        checkDayOfTheWeek = timeManage.getCheckDayOfTheWeek(week)
        if (timerFlag == 1 && checkDayOfTheWeek){
            // 現在時刻が設定時刻と一緒なら
            if str == self.setTime{
                self.alert()
                self.timerFlag = 0
            }
        }
    }
    
    func alert() {
        let myAlert = UIAlertController(title: "alert", message: "ring ding", preferredStyle: .alert)
        let myAction = UIAlertAction(title: "dong", style: .default) {
            action in print("foo!!")
        }
        self.notification()
        myAlert.addAction(myAction)
        present(myAlert, animated: true, completion: nil)
    }
    
    
    func notification() {
        
        print("scheduled notification")
        content.title = "ARukeより通知"
        content.body = "イベントが発生!!"
        content.sound = UNNotificationSound.default()
        
        // 1秒後に発火
        let trigger = UNTimeIntervalNotificationTrigger(timeInterval: 0.1, repeats: false)
        let request = UNNotificationRequest(identifier: "oneSecond",
                                            content: content,
                                            trigger: trigger)
        
        // ローカル通知予約
        UNUserNotificationCenter.current().add(request, withCompletionHandler:nil)
    }
}
