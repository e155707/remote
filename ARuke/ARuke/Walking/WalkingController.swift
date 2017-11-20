//
//  WalkingController.swift
//  ARuke
//
//  Created by e155707 on 2017/11/20.
//  Copyright © 2017年 Ryukyu. All rights reserved.
//

import UIKit
import SceneKit
import ARKit

class WalkingController: UIViewController, ARSCNViewDelegate{
    @IBOutlet weak var WalkingDescriptionLabel: UILabel!
    @IBOutlet weak var characterDisplay: SCNView!
    
    let character:ManageCharacter = ManageCharacter()
    var characterScene:SCNScene = SCNScene()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        characterScene = character.managerCamera()
        
        character.managerCharacter(characterScene)
        characterDisplay.scene = characterScene
        
        WalkingDescriptionLabel.text = "指定した　チェックポイントに向かって、\n戦いに　いどむんやで\n\n...歩きスマホは　アカンやで！！"
        WalkingDescriptionLabel.numberOfLines = 0
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Release any cached data, images, etc that aren't in use.
    }
    
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



