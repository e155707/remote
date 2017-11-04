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

class AlarmController: UIViewController{
    
    @IBOutlet weak var timeDisplayLabel: UILabel!
    @IBOutlet weak var selectTime: UIDatePicker!
    
    var tempTime: String = "00:00"
    var setTime: String = "00:00"
    
    let timeController:TimeController = TimeController()
    
    @IBAction func selectTimeButton(_ sender: Any) {
        let format = DateFormatter()
        format.dateFormat = "HH:mm"
        tempTime = format.string(from: selectTime.date)
    }
    
    @IBAction func decideTimeButton(_ sender: Any) {
        setTime = tempTime
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        timeDisplayLabel.text = "00:00"
        _ = Timer.scheduledTimer(timeInterval: 60, target: self, selector: #selector(self.update), userInfo: nil, repeats: true)
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
    
    @objc func update() {
        // 現在時刻を取得
        let str = timeController.getNowTime()
        // myLabelに反映
        timeDisplayLabel.text = str
        // アラーム鳴らすか判断
        myAlarm(str)
    }
    
    func myAlarm(_ str:String) {
        // 現在時刻が設定時刻と一緒なら
        if str == setTime{
            alert()
        }
    }
    
    func alert() {
        let myAlert = UIAlertController(title: "alert", message: "ring ding", preferredStyle: .alert)
        let myAction = UIAlertAction(title: "dong", style: .default) {
            action in print("foo!!")
        }
        myAlert.addAction(myAction)
        present(myAlert, animated: true, completion: nil)
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
