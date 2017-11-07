//
//  ViewController.swift
//  ARuke
//
//  Created by 赤堀　貴一 on 2017/10/18.
//  Copyright © 2017年 Ryukyu. All rights reserved.
//

import UIKit
import SceneKit
import ARKit

class StartController: UIViewController, ARSCNViewDelegate {
    
    @IBOutlet weak var scoreView: UIView!
    @IBOutlet weak var startView: UIView!
    
    @IBOutlet weak var distanceLabel: UILabel!
    @IBOutlet weak var scoreLabel: UILabel!
    
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var goMap: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //上のViewの枠作り
        scoreView.layer.borderColor = UIColor.white.cgColor
        scoreView.layer.borderWidth = 2.0
        scoreView.layer.masksToBounds = true
        
        //下のViewの枠作り
        startView.layer.borderColor = UIColor.white.cgColor
        startView.layer.borderWidth = 2.0
        startView.layer.masksToBounds = true
        
        //クラスのインスタンス
        let score = ScoreManager()
        
        score.scoreInitialization()
        //score.scoreTotalInitialization()
        score.getTimesEffect(1)
        
        scoreLabel.text = score.getTotalScore()
        distanceLabel.text = score.getTotalDistance()
        
        //Answerの初期化
        let Answer:QuizEventManager = QuizEventManager()
        Answer.answerInitialization()
        
        let timeManage:TimeManager = TimeManager()
        timeManage.timeInit()
    
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
