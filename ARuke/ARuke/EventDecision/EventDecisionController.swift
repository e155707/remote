//
//  EventDecision.swift
//  ARuke
//
//  Created by e155707 on 2017/11/06.
//  Copyright © 2017年 Ryukyu. All rights reserved.
//

import UIKit
import SceneKit
import ARKit

class EventDecisionController: UIViewController, ARSCNViewDelegate {
    
    @IBOutlet weak var eventLabel: UILabel!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        eventLabel.text = "?"
    }
    
    @IBAction func randomButton(_ sender: Any) {
        let random = arc4random_uniform(3)
        
        if(random == 0){
            eventLabel.text = "アフロ育て"
        }else if(random == 1){
            eventLabel.text = "クイズ"
        }else{
            eventLabel.text = "パズル集め"
        }
        
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

