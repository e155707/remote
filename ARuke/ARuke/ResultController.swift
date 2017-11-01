//
//  ResultController.swift
//  ARuke
//
//  Created by e155707 on 2017/10/24.
//  Copyright © 2017年 Ryukyu. All rights reserved.
//

import UIKit
import SceneKit
import ARKit

class ResultController: UIViewController{
    
    @IBOutlet weak var Result: UIView!
    
    
    @IBOutlet weak var ThisKiro: UILabel!
    @IBOutlet weak var ThisScore: UILabel!
    
    @IBOutlet weak var Kiro: UILabel!
    @IBOutlet weak var Score: UILabel!
    
    //@IBOutlet weak var Map: UIButton!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //TitleLabel.adjustsFontSizeToFitWidth = true;
        //Map.adjustsFontSizeToFitWidth = true;
        //クラスのインスタンス
        let score = ScoreManager()
        
        score.setTotalScore()
        
        ThisScore.text = score.getScore()
        ThisKiro.text = score.getDistance()
        
        
        Result.layer.borderColor = UIColor.white.cgColor
        Result.layer.borderWidth = 2.0
        Result.layer.masksToBounds = true
        
        
        Kiro.text = score.getTotalDistance()
        Score.text = score.getTotalScore()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        // Create a session configuration
        //let configuration = ARWorldTrackingConfiguration()
        
        // Run the view's session
        //sceneView.session.run(configuration)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        // Pause the view's session
        //sceneView.session.pause()
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

