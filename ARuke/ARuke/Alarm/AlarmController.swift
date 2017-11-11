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
    @IBOutlet weak var dayOfTheWeekLabel: UILabel!
    
    var tempTime: String = "00:00"
    var setTime: String = "00:00"
    var setDayOfTheWeek: String = "なし"
    let content = UNMutableNotificationContent()
    var timer: Timer!
    var timerFlag: Int! = 1
    
    let timeManage:TimeManager = TimeManager()
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
        setDayOfTheWeek = timeManage.getTrueDayOfTheWeek()
        dayOfTheWeekLabel.text = setDayOfTheWeek
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        selectTime.setValue(UIColor.white, forKey: "textColor")
        selectTime.setValue(false, forKey: "highlightsToday")
        
        timeDisplayLabel.text = "00:00"
        dayOfTheWeekLabel.text = "なし"
        
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
