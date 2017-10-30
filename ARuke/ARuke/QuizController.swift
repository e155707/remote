//
//  QuizController.swift
//  ARuke
//
//  Created by e155707 on 2017/10/30.
//  Copyright © 2017年 Ryukyu. All rights reserved.
//

import UIKit
import SceneKit
import ARKit

class QuizController: UIViewController{
    
    let Answer:QuizEventManager = QuizEventManager()
    
    @IBAction func red(_ sender: Any) {
        Answer.setAnswerRed(true)
        Answer.setAnswerBlue(false)
        Answer.setAnswerGreen(false)
    }
    
    @IBAction func blue(_ sender: Any) {
        Answer.setAnswerRed(false)
        Answer.setAnswerBlue(true)
        Answer.setAnswerGreen(false)
    }
    
    @IBAction func green(_ sender: Any) {
        Answer.setAnswerRed(false)
        Answer.setAnswerBlue(false)
        Answer.setAnswerGreen(true)
    }
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Release any cached data, images, etc that aren't in use.
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

