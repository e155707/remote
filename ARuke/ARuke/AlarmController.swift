//
//  AlarmController.swift
//  ARuke
//
//  Created by e155707 on 2017/11/04.
//  Copyright © 2017年 Ryukyu. All rights reserved.
//

import Foundation
import UIKit
import SceneKit
import ARKit
import UserNotifications

class AlarmController: UIViewController{
    
    @IBOutlet weak var timeDisplayLabel: UILabel!
    @IBOutlet weak var selectTime: UIDatePicker!
    
    var tempTime: String = "00:00"
    var setTime: String = "00:00"
    let content = UNMutableNotificationContent()
    var timer: Timer!
    var timerFlag: Int! = 1
    
    let timeController:TimeController = TimeController()
    
    @IBAction func selectTimeButton(_ sender: Any) {
        let format = DateFormatter()
        format.dateFormat = "HH:mm"
        tempTime = format.string(from: selectTime.date)
        timerFlag = 1
    }
    
    @IBAction func decideTimeButton(_ sender: Any) {
        setTime = tempTime
        timeDisplayLabel.text = setTime
        print(setTime)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        timeDisplayLabel.text = "00:00"
        
        timer = Timer.scheduledTimer(timeInterval: 0.1, target: self, selector: #selector(update), userInfo: nil, repeats: true)
        timer.fire()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    @objc func update(tm: Timer) {
        // 現在時刻を取得
        let str = timeController.getNowTime()
        // アラーム鳴らすか判断
        myAlarm(str)
    }
    
    func myAlarm(_ str:String) {
        if timerFlag == 1 {
            // 現在時刻が設定時刻と一緒なら
            if str == setTime{
                alert()
                timerFlag = 0
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
    
    // MARK: - ARSCNViewDelegate
    
    /*
     // Override to create and configure nodes for anchors added to the view's session.
     func renderer(_ renderer: SCNSceneRenderer, nodeFor anchor: ARAnchor) -> SCNNode? {
     let node = SCNNode()
     
     return node
     }
     */
    
    func session(_ session: ARSession, didFailWithError error: Error) {
        // Present an error message to the user
    }
    
    func sessionWasInterrupted(_ session: ARSession) {
        // Inform the user that the session has been interrupted, for example, by presenting an overlay
    }
    
    func sessionInterruptionEnded(_ session: ARSession) {
        // Reset tracking and/or remove existing anchors if consistent tracking is required
    }
    
}
